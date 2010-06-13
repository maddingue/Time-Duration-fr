use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Time::Duration::fr',
    AUTHOR              => 'Sebastien Aperghis-Tramoni <sebastien@aperghis.net>',
    VERSION_FROM        => 'lib/Time/Duration/fr.pm',
    ABSTRACT_FROM       => 'lib/Time/Duration/fr.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        # build/test prereqs
        'Test::More'    => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Time-Duration-fr-*' },
);
