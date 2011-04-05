package Quelology::Model::Result::Publication;
use parent qw/DBIx::Class::Core/;
use Locales;

use utf8;
use strict;
use warnings;

__PACKAGE__->load_components(qw( Tree::NestedSet ));
__PACKAGE__->table('publication');
__PACKAGE__->add_columns(qw/
    id
    asin
    ISBN
    title
    author
    publisher
    amazon_url
    title_id
    publication_date
    lang

    small_image
    small_image_width
    small_image_height
    medium_image
    medium_image_width
    medium_image_height
    large_image
    large_image_width
    large_image_height


    /);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(['asin']);
__PACKAGE__->belongs_to('title', 'Quelology::Model::Result::Title', 'title_id');

__PACKAGE__->has_many('attributions', 'Quelology::Model::Result::PublicationAttribution', 'publication_id');

my $locales = Locales->new('en');

sub language {
    my $lang = shift->lang;
    return $locales->code2language($lang) if defined $lang;
    return;
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
