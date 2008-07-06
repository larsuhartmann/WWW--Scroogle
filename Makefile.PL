use 5.008008;
use ExtUtils::MakeMaker;
WriteMakefile(
              NAME              => 'WWW::Scroogle',
              VERSION_FROM      => 'lib/WWW/Scroogle.pm', # finds $VERSION
              LICENSE           => 'perl',
              PREREQ_PM         => {
                                    LWP         => 5.808,
                                    Carp        => 0,
                                    warnings    => 0,
                                    strict      => 0,
                                   },
              ABSTRACT_FROM   => 'lib/WWW/Scroogle.pm',
              AUTHOR          => 'Lars Hartmann <lars (at) chaotika (dot) org>',
              INSTALLDIRS => 'site',
              EXE_FILES => [],
              PL_FILES => {}
             );
