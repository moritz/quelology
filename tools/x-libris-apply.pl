use 5.010;
use strict;
use warnings;
use lib 'lib';
use Quelology::Config qw/schema/;
use WebService::Libris;
use WebService::Libris::FileCache;

use utf8;
binmode STDOUT, ':encoding(UTF-8)';
use autodie;

my $schema = schema;

my ($title, $publication);
open my $f, '<:encoding(UTF-8)', 'xl-reviewed.log';
while (my $line = <$f>) {
    if ($line =~ /^\w\w \((\w+)\)/) {
        my $isbn = $1;
        $publication = $schema->p->find({ isbn => $isbn });
        next unless $publication;
        $title = $publication->title_obj;
    } else {
        next unless $publication;
        my (undef, $lang1, $lang2, $libris) = split /  /, $line;
        my $lang = chose_lang($lang1, $lang2);
        $libris =~ s/[()]//g;
        next unless defined $lang;
        my $lp = WebService::Libris->new(
            type    => 'bib',
            id      => $libris,
            cache   => WebService::Libris::FileCache->new(
                directory   => 'data/libris/',
            ),
        );
        if ($schema->p->search({ -or =>  { isbn => $lp->isbn, asin => $lp->isbn, libris_id => $lp->id}})->first) {
            say "publication already exists...";
            next;

        }
        my $rp = $schema->rp->from_libris_book($lp, language => $lang);
        my $cook_into = $title->lang eq $lang
                        ? $title
                        : $title->translations->search({lang => $lang })->first;
        if ($cook_into) {
            say "Cooking...";
            $rp->cook($cook_into);
        } else {
            say "Creating translation ...";
            $schema->txn_do(sub {
                my $new_title = $title->create_related('aliases', {
                        title   => fixup_title($lp->title),
                        lang    => $lang,
                });
                for ($title->author_titles) {
                    $new_title->create_related('author_titles',
                        {
                            author_id => $_->author_id,
                        },
                    );

                }
                $rp->cook($new_title);
                $new_title->create_related('attributions',
                    {
                        url     => "http://libris.kb.se/bib/" . $lp->id,
                        name    => 'libris',
                    },
                );
            });
        }
    }
}



sub chose_lang {
    my %lang_prio =  (
        XX  => 0,
        en  => 1,
        sv  => 2,
    );
    my @langs = reverse sort { ($lang_prio{$a} // 3) <=> ($lang_prio{$b} // 3) } @_;
    return undef if $langs[0] eq 'XX';
    my @prio = map { $lang_prio{$_} // 3 } @langs;
    return undef if $prio[1] == 3 && $langs[0] ne $langs[1];
    return $langs[0];
}

sub fixup_title {
    my $title = shift;
    $title =~ s/ [:;\[].*//;
    $title;
}
