use ExtUtils::MakeMaker;
WriteMakefile(
              NAME              => 'WWW::Scroogle',
              VERSION_FROM      => 'lib/WWW/Scroogle.pm', # finds $VERSION
              LICENSE           => 'perl',
              PREREQ_PM         => {
                                    LWP => 5.808,
                                    Carp => 0,
                                    warnings => 0,
                                    strict => 0,
#                                   perl => 5.6.1,
                                   }, # e.g., Module::Name => 1.1
              ABSTRACT_FROM   => 'lib/WWW/Scroogle.pm', # retrieve abstract from module
              AUTHOR          => 'Lars Hartmann <lars (at) chaotika (dot) org>',
              INSTALLDIRS => 'site',
              EXE_FILES => [],
              PL_FILES => {}
             );
