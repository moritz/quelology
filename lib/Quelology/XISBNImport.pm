package Quelology::XISBNImport;
use 5.010;

use Exporter qw/import/;
our @EXPORT_OK = qw/lang_marc_to_iso binding get_xml from_isbn/;

use Mojo::UserAgent;
use Mojo::DOM;


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

sub lang_marc_to_iso {
    $langcodes{ shift() };
}

sub binding {
    $form{ shift() };
}

sub get_xml {
    my $isbn = shift;
    if (open my $f, '<:encoding(UTF-8)', "data/xisbn/$isbn.xml") {
        $xml = do { local $/; <$f> };
        close $f;
    } else {
        use autodie;
        $xml = Mojo::UserAgent->new->get("http://xisbn.worldcat.org/webservices/xid/isbn/$isbn?method=getEditions&format=xml&fl=*")->res->body;
        open my $f, '>:encoding(UTF-8)', "data/xisbn/$isbn.xml";
        print { $f } $xml;
        close $f;
    }
    return $xml;
}

sub fixup_author {
    my $a = shift;
    $a =~ s/\s*\[.*//;
    $a = (split /\s*;/, $a)[0];
    $a =~ s/^(by|af|un[ae]? \w+ de) //;
    $a =~ s/\bill\. by.*//i;
    $a =~ s/\b(\w)\. (\w)\./$1.$2./g;
    $a =~ s/\. Aus dem.*//;
    $a = join ', ', split / and /, $a;
    return $a;
}


sub preprocess {
    my $xml = shift;
    my %isbn;
    for my $d (Mojo::DOM->new->charset('UTF-8')->parse($xml)->find('isbn')->each) {
        my $isbn = $d->text;
        my $attrs = $d->attrs;
        $attrs->{isbn} = $isbn;
        for (qw/lang originalLang/) {
            $attrs->{$_} = lang_marc_to_iso($attrs->{$_}) if exists $attrs->{$_};
        }
        my $form = delete $attrs->{form};
        for (split / /, $form) {
            if (binding($_)) {
                $attrs->{form} = binding($_);
                last;
            }
            $attrs->{author} = fixup_author($attrs->{author});
        }
        $isbn{$isbn} = $attrs;
    }
    return \%isbn;
}

sub from_isbn {
    my $isbn = shift;
    preprocess(get_xml($isbn));
}

1;
