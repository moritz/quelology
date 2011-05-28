use 5.014;
use warnings;
use lib 'lib';
use Quelology::Config qw/schema/;
my $s = schema;

my $rs = $s->p->search(
    {
        isbn    => undef,
        asin    => { '<>' => undef },
    }
);
$s->txn_do(sub {
    while (my $p = $rs->next) {
        if ($p->asin =~ /^\d/) {
            $p->update({isbn => $p->asin});
        } else {
#            printf "'%s' (id %d) has asin %s, which is not an ISBN\n",
#                    $p->title, $p->id, $p->asin;
        }
    }
});

$rs = $s->t->search(
    {
        'publications_unordered.asin'   => undef,
    },
    {
        join        => 'publications_unordered',
        prefetch    => 'publications_unordered',
        having      => \'COUNT(publications_unordered.id) > 1',
        # TODO: come up with a better way :-/
        group_by    => 'me.id, me.title, me.same_as, me.isfdb_id, me.lang, me.root_id, me.l, me.r, me.level, me.created, me.modified',
    }
);

my @attrs = qw/title publication_date language binding publisher_id/;
while (my $t = $rs->next) {
    my %seen;
    for ($t->publications_unordered) {
        next if defined $_->asin;
        my %col = $_->get_columns;
        no warnings 'uninitialized';
        my $key = join '|', @col{@attrs};
        if ($seen{$key}++) {
            say '     deleting';
            $_->delete;
        }
    }
}
