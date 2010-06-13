use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Time::Duration::fr',
    license             => 'perl',
    dist_author         => 'Sebastien Aperghis-Tramoni <sebastien@aperghis.net>',
    dist_version_from   => 'lib/Time/Duration/fr.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Time-Duration-fr-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
