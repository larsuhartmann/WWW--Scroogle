use Test::More 'no_plan';
eval {use Test::Pod::Coverage 1.00};
plan skip_all => "Test::Pod::Coverage 1.00 required for testing POD coverage" if $@;

TODO: {
      local $TODO = 'lacks documentation!';
      pod_coverage_ok($_) for qw(WWW::Scroogle WWW::Scroogle::Result);
}
