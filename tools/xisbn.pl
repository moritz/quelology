use 5.010;
use strict;
use warnings;
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

my %langcodes = (
    'som' => 'so',
    'ido' => 'io',
    'esp' => 'eo',
    'mal' => 'ml',
    'uzb' => 'uz',
    'ukr' => 'uk',
    'cha' => 'ch',
    'sao' => 'sm',
    'kon' => 'kg',
    'far' => 'fo',
    'ava' => 'av',
    'epo' => 'eo',
    'ven' => 've',
    'tel' => 'te',
    'rus' => 'ru',
    'cre' => 'cr',
    'ita' => 'it',
    'pol' => 'pl',
    'mac' => 'mk',
    'kor' => 'ko',
    'geo' => 'ka',
    'nya' => 'ny',
    'bur' => 'my',
    'tsw' => 'tn',
    'bam' => 'bm',
    'kin' => 'rw',
    'tur' => 'tr',
    'wol' => 'wo',
    'ewe' => 'ee',
    'est' => 'et',
    'sun' => 'su',
    'ndo' => 'ng',
    'swe' => 'sv',
    'nep' => 'ne',
    'chi' => 'zh',
    'gag' => 'gl',
    'lug' => 'lg',
    'lim' => 'li',
    'aym' => 'ay',
    'nor' => 'no',
    'rum' => 'ro',
    'dzo' => 'dz',
    'ara' => 'ar',
    'bul' => 'bg',
    'ind' => 'id',
    'por' => 'pt',
    'cam' => 'km',
    'asm' => 'as',
    'bre' => 'br',
    'gal' => 'om',
    'snd' => 'sd',
    'iii' => 'ii',
    'tuk' => 'tk',
    'xho' => 'xh',
    'arg' => 'an',
    'wln' => 'wa',
    'fin' => 'fi',
    'tag' => 'tl',
    'sho' => 'sn',
    'nav' => 'nv',
    'may' => 'ms',
    'cor' => 'kw',
    'ori' => 'or',
    'lao' => 'lo',
    'ave' => 'ae',
    'khm' => 'km',
    'que' => 'qu',
    'ice' => 'is',
    'aar' => 'aa',
    'tar' => 'tt',
    'div' => 'dv',
    'san' => 'sa',
    'lub' => 'lu',
    'scr' => 'hr',
    'lat' => 'la',
    'scc' => 'sr',
    'hrv' => 'hr',
    'run' => 'rn',
    'bak' => 'ba',
    'mon' => 'mn',
    'ben' => 'bn',
    'lin' => 'ln',
    'oss' => 'os',
    'smo' => 'sm',
    'gua' => 'gn',
    'kur' => 'ku',
    'ile' => 'ie',
    'tat' => 'tt',
    'glv' => 'gv',
    'guj' => 'gu',
    'tsn' => 'tn',
    'jav' => 'jv',
    'gla' => 'gd',
    'yid' => 'yi',
    'iri' => 'ga',
    'arm' => 'hy',
    'grn' => 'gn',
    'cze' => 'cs',
    'srp' => 'sr',
    'ltz' => 'lb',
    'pus' => 'ps',
    'kan' => 'kn',
    'bel' => 'be',
    'sna' => 'sn',
    'mol' => 'mo',
    'tir' => 'ti',
    'chv' => 'cv',
    'lav' => 'lv',
    'mlt' => 'mt',
    'fij' => 'fj',
    'cat' => 'ca',
    'baq' => 'eu',
    'pli' => 'pi',
    'lit' => 'lt',
    'her' => 'hz',
    'kom' => 'kv',
    'tso' => 'ts',
    'tgk' => 'tg',
    'gle' => 'ga',
    'kaz' => 'kk',
    'hin' => 'hi',
    'wel' => 'cy',
    'urd' => 'ur',
    'mao' => 'mi',
    'kik' => 'ki',
    'vie' => 'vi',
    'ger' => 'de',
    'slv' => 'sl',
    'tgl' => 'tl',
    'max' => 'gv',
    'dan' => 'da',
    'orm' => 'om',
    'fre' => 'fr',
    'bis' => 'bi',
    'srd' => 'sc',
    'glg' => 'gl',
    'zha' => 'za',
    'hau' => 'ha',
    'yor' => 'yo',
    'mar' => 'mr',
    'bih' => 'bh',
    'dut' => 'nl',
    'afr' => 'af',
    'mah' => 'mh',
    'per' => 'fa',
    'taj' => 'tg',
    'eng' => 'en',
    'heb' => 'he',
    'ipk' => 'ik',
    'tib' => 'bo',
    'fao' => 'fo',
    'oji' => 'oj',
    'iku' => 'iu',
    'nno' => 'nn',
    'nob' => 'nb',
    'amh' => 'am',
    'ibo' => 'ig',
    'tam' => 'ta',
    'mla' => 'mg',
    'hun' => 'hu',
    'sme' => 'se',
    'chu' => 'cu',
    'alb' => 'sq',
    'twi' => 'tw',
    'cos' => 'co',
    'slo' => 'sk',
    'nau' => 'na',
    'zul' => 'zu',
    'kua' => 'kj',
    'jpn' => 'ja',
    'tha' => 'th',
    'che' => 'ce',
    'swa' => 'sw',
    'kas' => 'ks',
    'bos' => 'bs',
    'mlg' => 'mg',
    'spa' => 'es',
    'kau' => 'kr',
    'aka' => 'ak',
    'tah' => 'ty',
    'hmo' => 'ho'
);

my %form = (
    AA  => 'audio',
    DA  => 'ebook',
    BB  => 'hardcover',
    BC  => 'paperback',
    VA  => 'video',
);

say $isbn;
my $root_title = schema->p->find({asin => $isbn })->title_obj;
say ' ' x 2, $root_title->id, ' ', $root_title->title;
use Data::Dumper;
for my $d ($dom->find('isbn')->each) {
    my $new_isbn = $d->text;
    say $new_isbn;
    my $attrs = $d->attrs;
    for (qw/lang originalLang/) {
        $attrs->{$_} = $langcodes{$attrs->{$_}} if exists $attrs->{$_};
    }
    for (split / /, $attrs->{form}) {
        if ($form{$_}) {
            $attrs->{form} = $form{$_};
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
