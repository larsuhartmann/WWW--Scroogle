#!/usr/bin/env perl

# use Test::More tests => 23;
use Test::More qw(no_plan);

# look if we can load it
BEGIN { use_ok( 'WWW::Scroogle' ); }

# testing the construktor
can_ok('WWW::Scroogle','new');
ok(my $scroogle = WWW::Scroogle->new,'$object = WWW::Scroogle->new');
isa_ok($scroogle,'WWW::Scroogle');

# testing (set_)searchstring
my $searchstring = 'foobar';
can_ok('WWW::Scroogle', $_) for(qw(searchstring set_searchstring));
eval{WWW::Scroogle->searchstring};
ok($@, 'WWW::Scroogle->searchstring - fails (instance variable needed)');
eval{WWW::Scroogle->set_searchstring($searchstring)};
ok($@, 'WWW::Scroogle->set_searchstring('.$searchstring.') - fails (instance variable needed)');
eval{$scroogle->searchstring};
ok($@, '$object->searchstring - fails (no searchstring given jet)');
eval{$scroogle->set_searchstring()};
ok($@, '$object->set_searchstring() - fails (no searchstring given)');
eval{$scroogle->set_searchstring('')};
ok($@, '$object->set_searchstring("") - fails (nullstring given)');
ok($scroogle->set_searchstring($searchstring), '$object->set_searchstring("'.$searchstring.'")');
is($scroogle->searchstring,$searchstring,'$object->searchstring eq "'.$searchstring.'"');

# testing (default_|set_)language
my $language = 'de';
can_ok('WWW::Scroogle', $_) for(qw(language set_language _default_language languages));
eval{WWW::Scroogle->language};
ok($@, 'WWW::Scroogle->language - fails (instance variable needed)');
eval{WWW::Scroogle->set_language};
ok($@, 'WWW::Scroogle->set_language - fails (instance variable needed)');
is($scroogle->_default_language, '', '$object->_default_language eq ""');
is($scroogle->language, 'all', '$object->_default_language eq "all"');
ok($scroogle->set_language("en"), '$object->set_language("en")');
is($scroogle->language, 'en','$object->language eq "en"');
ok($scroogle->set_language(), '$object->set_language()');
is($scroogle->language, 'all','$object->language eq "all"');
eval{$scroogle->set_language("invalid")};
ok($@,'$object->set_language("invalid") - fails (invalid input)');
ok($scroogle->set_language('de'), '$object->set_language("de")');
is($scroogle->language, 'de', '$object->language eq "de"');
ok($scroogle->set_language('all'), '$object->set_language("all")');
is($scroogle->language, 'all', '$object->language eq "all"');

# testing (set_)num_results
can_ok('WWW::Scroogle', $_) for(qw(num_results set_num_results));
eval {WWW::Scroogle->num_results};
ok($@, 'WWW::Scroogle->num_results - fails (instance variable needed)');
eval {WWW::Scroogle->set_num_results(100)};
ok($@, 'WWW::Scroogle->set_num_results - fails (instance variable needed)');
eval {$scroogle->set_num_results("")};
ok($@, '$object->set_num_results("") - fails (odd number expected)');
eval {$scroogle->set_num_results('invalid')};
ok($@,'$object->set_num_results("invalid") - fails (odd number expected)');
eval {$scroogle->set_num_results(5.7)};
ok($@, '$object->set_num_results(5.7) - fails (odd number expected)');
eval {$scroogle->set_num_results(0)};
ok($@, '$object->set_num_results(0) - fails (minimum is 1result)');
is($scroogle->num_results,100,'$object->num_results == 100');
ok($scroogle->set_num_results(230), '$object->set_num_results(230)');
is($scroogle->num_results,230,'$object->num_results == 230');
ok($scroogle->set_num_results(), '$object->set_num_results()');
is($scroogle->num_results,100,'$object->num_results == 100');

# perform_search
can_ok('WWW::Scroogle', $_) for(qw(perform_search));
eval {WWW::Scroogle->perform_search};
ok($@,'WWW::Scroogle->perform-search - failed (instance variable needed)');
my $error = WWW::Scroogle->new;
eval {$error->perform_search};
ok($@,'object-without-searchstring->perform_search - failed (no searchstring given)');
ok($scroogle->perform_search, '$object->perform_search');
