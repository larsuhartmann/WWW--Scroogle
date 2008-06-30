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
can_ok('WWW::Scroogle', $_) for qw(searchstring set_searchstring);
eval{WWW::Scroogle->searchstring};
ok($@ =~ m/instance variable needed/, 'WWW::Scroogle->searchstring - fails (instance variable needed)');
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
can_ok('WWW::Scroogle', $_) for qw(language set_language _default_language languages);
eval{WWW::Scroogle->language};
ok($@ =~ m/instance variable needed/, 'WWW::Scroogle->language - fails (instance variable needed)');
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
can_ok('WWW::Scroogle', $_) for qw(num_results set_num_results);
eval {WWW::Scroogle->num_results};
ok($@ =~ m/instance variable needed/, 'WWW::Scroogle->num_results - fails (instance variable needed)');
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

# (n|has|delete|_add)(_)result(s)
for (qw(_add_result delete_results has_results nresults)) {
     can_ok('WWW::Scroogle', $_);
     eval "WWW::Scroogle->$_";
     ok($@ =~ m/instance variable needed/, 'WWW::Scroogle->'.$_.' - failed (instance variable needed)');
}
my $error = WWW::Scroogle->new;
ok(not($error->has_results), '$objectwithoutresults->has_results returns boolean false');
ok(not($error->delete_results), '$objectwithoutresults->delete_results returns boolean false');
eval {$error->nresults};
ok($@, '$objectwithoutresults->nresults - failed (no results avaible)');
eval {$scroogle->_add_result()};
ok($@ =~ m/hash/, '$object->_add_result() - failed (no options hash given)');
eval {$scroogle->_add_result({})};
ok($@ =~ m/no url/, '$object->_add_result({}) - failed (no url given)');
eval {$scroogle->_add_result({url=>'a.b.c',})};
ok($@ =~ m/no position/, '$object->_add_result({url=>"a.b.c",})');
ok($scroogle->_add_result({url=>'a.b.c',position=>'1'}), '$object->_add_results({valid_options})');
ok($scroogle->has_results, '$object->has_results');
is($scroogle->nresults, 1, '$object->nresults == 1');
my $result = $scroogle->{results}->[0];
isa_ok($result, 'WWW::Scroogle::Result');
is($result->language, 'all', '$result->language eq "all"');
is($result->position, 1, '$result->position == 1');
is($result->searchstring, 'foobar', '$result->searchstring eq "foobar"');
is($result->url, 'a.b.c', '$result->url eq "a.b.c"');
ok($scroogle->delete_results, '$object->delete_results');
ok(not($scroogle->has_results), '$object->has_results returns boolean false');

# perform_search
can_ok('WWW::Scroogle', $_) for qw(perform_search);
eval {WWW::Scroogle->perform_search};
ok($@ =~ m/instance variable needed/,'WWW::Scroogle->perform-search - failed (instance variable needed)');
$error = WWW::Scroogle->new;
eval {$error->perform_search};
ok($@ =~ m/searchstring/,'object-without-searchstring->perform_search - failed (no searchstring given)');
ok($scroogle->perform_search, '$object->perform_search');
