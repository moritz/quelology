package Quelology::Model::Result::RawPublication;
use parent qw/DBIx::Class::Core/;
use Locales;

use utf8;
use strict;
use warnings;

__PACKAGE__->table('raw_publication');
__PACKAGE__->add_columns(qw/
    id
    asin
    isbn
    libris_id
    title
    publisher
    amazon_url
    authors
    publication_date
    lang
    binding
    pages

    maybe_title_id

    small_image
    small_image_width
    small_image_height
    medium_image
    medium_image_width
    medium_image_height
    large_image
    large_image_width
    large_image_height

    created
    modified
    /);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(['asin']);

__PACKAGE__->belongs_to('maybe_title', 'Quelology::Model::Result::Title', 'maybe_title_id');
__PACKAGE__->has_many('attributions', 'Quelology::Model::Result::RawPublicationAttribution', 'raw_publication_id');

my $locales = Locales->new('en');

sub language {
    my $lang = shift->lang;
    return $locales->code2language($lang) if defined $lang;
    return;
}

# make less raw
sub cook {
    my ($self, $title) = @_;
    die "Need a title to attach to" unless $title;
    die "Title should be of class 'Q::M::Result::Title', is $title"
        unless $title->isa('Quelology::Model::Result::Title');
    $self->result_source->schema->txn_do(sub {
        my @columns = grep !/created|modified/,
                      $self->result_source->schema
                      ->source('Quelology::Model::Result::Publication')->columns;
        my %cols = $self->get_columns;
        my %pub_cols;
        for (@columns) {
            $pub_cols{$_} = $cols{$_} if exists $cols{$_};
        }
        # TODO: automatically generate that list with get_columns or so
        my $pub = $title->create_related('publications', \%pub_cols);
        if ($self->publisher) {
            my @publishers = $self->result_source->schema->resultset('Publisher')
                                ->search({ name => $self->publisher });
            if (@publishers == 1) {
                $pub->update({ publisher_id => $publishers[0]->id });
            }
        }
        for ($self->attributions) {
            $pub->create_related('attributions',
                {
                    url         => $_->url,
                    name        => $_->name,
                    retrieved   => $_->retrieved,
                }
            );
        };
        $self->delete;
        return $pub;
    });
}

sub attribute {
    my ($self, $url) = @_;
    if ($url =~ /\b(amazon|isfdb)\./) {
        $self->create_related('attributions',
            {
                name    => $1,
                url     => $url,
            },
        );
    } else {
        die "Don't know how to extract attribution name from '$url'."
            . " Please call ->create_related(attributions => { ... }) directly yourself.";
    }
}

1;
