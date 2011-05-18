use 5.010;
use strict;
use warnings;
use lib 'lib';
use Quelology::XISBNImport qw/lang_marc_to_iso binding/;
binmode STDOUT, ':encoding(UTF-8)';

# see http://xisbn.worldcat.org/xisbnadmin/doc/api.htm#response

my $isbn;

use Mojo::UserAgent;
use Mojo::DOM;
use lib 'lib';
use Quelology::Config qw/schema amazon/;

if (@ARGV) {
    $isbn = shift @ARGV;
} else {
    $isbn = schema->p->search(undef, { rows => 1, order_by => \'RANDOM()' })->first->isbn;
}

my $xml;

if (open my $f, '<', "data/xisbn/$isbn.xml") {
    $xml = do { local $/; <$f> };
    close $f;
    say "retrieved $isbn from cache";
} else {
    use autodie;
    say "getting $isbn via web";
    $xml = Mojo::UserAgent->new->get("http://xisbn.worldcat.org/webservices/xid/isbn/$isbn?method=getEditions&format=xml&fl=*")->res->body;
    open my $f, '>', "data/xisbn/$isbn.xml";
    print { $f } $xml;
    close $f;
}

my $dom = Mojo::DOM->new->parse($xml);

say $isbn;
my $root_title = schema->p->find({asin => $isbn })->title_obj;
say ' ' x 2, $root_title->id, ' ', $root_title->title;
use Data::Dumper;
for my $d ($dom->find('isbn')->each) {
    my $new_isbn = $d->text;
    say $new_isbn;
    my $attrs = $d->attrs;
    for (qw/lang originalLang/) {
        $attrs->{$_} = lang_marc_to_iso($attrs->{$_}) if exists $attrs->{$_};
    }
    for (split / /, $attrs->{form}) {
        if (binding($_)) {
            $attrs->{form} = binding($_);
            last;
        }
    }
    unless (defined $attrs->{lang}) {
        say '    language unknown';
        next;
    };
    say ' ' x 4, $attrs->{lang};
    if (my $np = schema->p->find({asin => $new_isbn})) {
        say '    publication known';
        unless ($np->lang) {
            say '    updating language';
            $np->update({ lang => $attrs->{lang} });
            $np->create_related('attributions', {
                url     => $attrs->{url},
                name    => 'worldcat',
            });
        }
        next;
    }

    schema->txn_do(sub {
        my $rp = eval { schema->rp->import_by_asin($new_isbn) };
        return unless $rp;
        eval {
            $rp->update({ lang => $attrs->{lang}}) unless $rp->lang eq $attrs->{lang};
            my $title = $root_title->lang eq $attrs->{lang}
                        ? $root_title
                        : $root_title->translations->search({ lang => $attrs->{lang} })->first;
            if (defined $title) {
                say "    adding to existing title";
                $rp->cook($title);
            } else {
                my $t = $rp->title;
                $t =~ s/\s*\((German|Spanish|French|Chinese|Russian) Edition\)$//;
                printf "    creating new title '%s' as %s translation of '%s'\n",
                        $t, $rp->lang, $root_title->title;
                my $title = $root_title->create_related('aliases', {
                        title   => $t,
                        lang    => $rp->lang
                });
                for ($root_title->author_titles) {
                    $title->create_related('author_titles',
                        {
                            author_id => $_->author_id,
                        },
                    );

                }
                $rp->cook($title);
                $title->create_related('attributions',
                    {
                        url     => $attrs->{url},
                        name    => 'worldcat',
                    },
                );
            }
        };
        warn $@ if $@;
    });
#    print Dumper $attrs;
}

say ' ' x 2, $root_title->id, ' ', $root_title->title;
