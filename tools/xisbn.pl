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
    @ARGV = schema->p->search(undef, { rows => 1, order_by => \'RANDOM()' })->first->isbn;
}
for my $isbn (@ARGV) {
    my $root_title = schema->p->find({asin => $isbn })->title_obj;
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

        schema->txn_do(sub {
            my $rp = eval { schema->rp->import_by_asin($new_isbn) };
            warn $@ if $@;
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
    }

    say ' ' x 2, $root_title->id, ' ', $root_title->title;
}
