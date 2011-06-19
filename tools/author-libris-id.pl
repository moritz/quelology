use 5.010;
use strict;
use warnings;
use lib 'lib';
use Quelology::Config qw/schema/;
use WebService::Libris;
binmode STDOUT, ':encoding(UTF-8)';

my $rs = schema->p->search({ libris_id => {'<>' => undef }});
my %seen;
while (my $pub = $rs->next) {
    my @authors = $pub->title_obj->authors;
    if (@authors == 1) {
        next if $authors[0]->libris_id;
        next if $seen{$authors[0]->id};
        my $l = WebService::Libris->new(
            type    => 'bib',
            id      => $pub->libris_id,
        );
        my @la = grep { defined $_->libris_key } $l->authors_obj->all;
        next unless @la;
        if (@la == 1) {
            my $munged = munge_name($la[0]->libris_key);
            if ($authors[0]->name eq $munged || $authors[0]->legal_name eq $munged) {
                $authors[0]->update({ libris_id => $la[0]->id });
            } else {
                printf "REVIEW: %d %s  '%s'  VS '%s'\n",
                        $authors[0]->id,
                        $la[0]->id,
                        $authors[0]->name,
                        $munged,
                        ;
                $seen{$authors[0]->id}++;
            }

        } else {
            printf "Quelology says %s has one author, but Libris says %d (%s)\n",
                    $pub->title,  scalar(@la), join(', ', map $_->libris_key, @la);
            next;
        }
    } else {
#        say "More than one author, ignoring for now...";
    }
}

sub munge_name {
    my $name = shift;
    my @parts = split /,\s*/, $name;
    pop @parts if $parts[-1] =~ /^\d+-/;
    my $munged = join ' ', reverse @parts;
    $munged =~ s/\(.*?\) //;
    return $munged;
}
