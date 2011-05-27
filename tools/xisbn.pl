use 5.010;
use strict;
use warnings;
use lib 'lib';
use Quelology::XISBNImport qw/from_isbn/;
binmode STDOUT, ':encoding(UTF-8)';

# see http://xisbn.worldcat.org/xisbnadmin/doc/api.htm#response


use Mojo::UserAgent;
use Mojo::DOM;
use lib 'lib';
use Quelology::Config qw/schema amazon/;

unless (@ARGV) {
    @ARGV = schema->p->search({isbn => { '<>' => undef }}, { rows => 1, order_by => \'RANDOM()' })->first->isbn;
}
for my $isbn (@ARGV) {
    unless (defined $isbn) {
        say 'Ugh, undefined ISBN.';
        next;
    }
    my $pub_obj = schema->p->find({asin => $isbn });
    next unless $pub_obj;
    my $root_title = $pub_obj->title_obj;
    say ' ' x 2, $root_title->id, ' ', $root_title->title;
    say $isbn;
    use Data::Dumper;
    my $data = from_isbn($isbn);
    while (my ($new_isbn, $attrs) = each %$data) {
        say $new_isbn;
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
        import_related_isbn($root_title, $new_isbn, $attrs);

    }

    say ' ' x 2, $root_title->id, ' ', $root_title->title;
}

sub import_related_isbn {
    my ($root_title, $new_isbn, $attrs) = @_;
    schema->txn_do(sub {
        my $rp = eval { schema->rp->import_by_asin($new_isbn) };
        print $@ if $@;
        unless ($rp) {
            $rp = schema->rp->import_from_xisbn_attrs($attrs);
            say "    using worldcat data for raw publication (" . $rp->id . ")";
        }
        # there some weird "publications" which are actually audio players
        # with a certain audio title preloaded. Those don't add any value,
        # so filter 'em out
        if ($rp->title =~ /With Earbuds/) {
            $rp->delete;
            return;
        }
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

}
