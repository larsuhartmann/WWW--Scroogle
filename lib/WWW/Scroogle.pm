package WWW::Scroogle;

use 5.008008;
use strict;
use warnings;
use Carp;

require LWP;
require WWW::Scroogle::Result;

our $VERSION = '0.006';

sub new
{
     my $class = shift;
     my $self = {
                 num_results       => $class->_default_num_results,
                 language          => $class->_default_language,
                };
     bless $self, $class;
     return $self;
}

sub _default_num_results { return 100; }

sub searchstring
{
     ref(my $self = shift)
          or croak 'instance variable needed!';
     defined($self->{searchstring})
          or croak 'no searchstring given yet!';
     return $self->{searchstring};
}

sub set_searchstring
{
     ref(my $self = shift)
          or croak 'instance variable needed!';
     defined(my $searchstring = shift)
          or croak 'no searchstring given!';
     if ($searchstring eq '') { croak 'nullstring given!' }
     $self->{searchstring} = $searchstring;
     return $self;
}

sub _default_language { return ''; }

sub language
{
     ref(my $either = shift)
          or croak 'instance variable needed!';
     if ($either->{language} eq '') {
          return 'all';
     }else {
          return $either->{language};
     }
}

sub set_language
{
     ref(my $self = shift)
          or croak 'instance variable needed!';
     my $language = shift;
     if (not defined $language) {
          $self->{language} = $self->_default_language;
     }else {
          grep{$language eq $_}$self->languages
               or croak($language.' is not a valid language! ');
          if ($language eq 'all') {
               $self->{language} = '';
          }else {
               $self->{language} = $language;
               return $self;
          }
     }
     return $self;
}

sub languages
{
     my $either = shift;
     my @languages = qw(
                            all ar zs zt cs da nl en et fi fr de el iw
                            hu is it ja ko lv lt no pt pl ro ru es sv tr
                      );
     return @languages;
}

sub num_results
{
     ref(my $self = shift)
          or croak 'instance variable needed!';
     return $self->{num_results};
}

sub set_num_results
{
     ref(my $self = shift)
          or croak "instance variable needed!";
     my $num_results = shift;
     if (not defined $num_results) {
          $self->{num_results} = $self->_default_num_results;
          return $self;
     }
     if (not $num_results =~ m/^\d+$/) { croak 'odd number expected!'; }
     if ($num_results < 1) { croak 'minimum is 1 result!'}
     $self->{num_results} = $num_results;
     return $self;
}

sub perform_search
{
     ref(my $self = shift)
          or croak 'instance variable needed!';
     my $searchstring = $self->searchstring;
     my $language = $self->language;
     my $num_results = $self->num_results;
     if ($self->has_results) { $self->delete_results };
     my $agent = LWP::UserAgent->new;
     my $request = HTTP::Request->new(POST => 'http://www.scroogle.org/cgi-bin/nbbw.cgi');
     $request->content_type('application/x-www-form-urlencodde');
     my $postdata;
     if ($language ne 'all') {
          $postdata = 'Gw='.$searchstring.'&n=100&l='.$language.'&z=';
     } else {
          $postdata = 'Gw='.$searchstring.'&n=100&z=';
     }
     my $niterate;
     if ($self->num_results <= 100) {
          $niterate = 1;
     }else {
          $niterate = ($num_results - $num_results%100)/100;
          if ($num_results%100 == 0) { $niterate--; }
     }
     my $results_left = $num_results;
     for (0..$niterate) {
          $request->content($postdata.$_);
          my $result = $agent->request($request);
          for (split( '\n', $result->content)) {
               if ($results_left <= 0) { last; }
               if (m/^(\d{1,5})\. <A Href="(.*)">/) {
                    $self->_add_result({
                                        position => $1,
                                        url => $2
                                       });
                    $results_left--;
               }
          }
     }
     return 1;
}

sub _add_result
{
     ref (my $self = shift)
          or croak 'instance variable needed!';
     my $options = shift;
     if (not ref $options eq "HASH") { croak 'no options hash given!'; }
     if (not exists $options->{url}) { croak 'no url given!'; }
     if (not exists $options->{position}) { croak 'no position given!'; }
     my $result = WWW::Scroogle::Result->new({
                                              url            => $options->{url},
                                              position       => $options->{position},
                                              searchstring   => $self->searchstring,
                                              language       => $self->language,
                                             });
     push @ {$self->{results}}, $result;
     return $self;
}

sub nresults
{
     ref (my $self = shift)
          or croak 'instance variable needed!';
     if ($self->has_results) {
          my $nresults = @ {$self->{results}};
          return $nresults;
     }
     croak 'no results avaible';

}

sub get_results
{
     ref (my $self = shift)
          or croak 'instance variable needed!';
     if (not $self->has_results) { croak 'no results avaible' }
     return @ {$self->{results}};
}

sub has_results
{
     ref (my $self = shift)
          or croak 'instance variable needed!';
     if (exists $self->{results}) {
          1;
     }else {
          return;
     }
}

sub delete_results
{
     ref (my $self = shift)
          or croak 'instance variable needed!';
     if ($self->has_results) {
          delete $self->{results};
          1;
     }else {
          return;
     }
}

sub get_result
{
     ref (my $self = shift)
          or croak 'instance variable needed!';
     defined (my $requested_result = shift)
          or croak 'no value given';
     if (not $self->has_results) { croak 'no results avaible'; }
     return $self->{results}[$requested_result -1];
}

sub position
{
     ref (my $self = shift)
          or croak 'instance variable needed!';
     defined (my $string = shift)
          or croak 'no string given!';
     if (not $self->has_results) { croak 'no results avaible'; }
     for (0..(@ {$self->{results}} -1)) {
          my $result = $self->{results}->[$_];
          if ($result->url =~ /$string/) {
               return $_+1;
          }
     }
     return;
}

sub positions
{
     ref (my $self = shift)
          or croak 'instance variable needed!';
     defined (my $string = shift)
          or croak 'no string given!';
     if (not $self->has_results) { croak 'no results avaible'; }
     my @return;
     for (0..(@ {$self->{results}} -1)) {
          my $result = $self->{results}->[$_];
          if ($result->url =~ /$string/) {
               push @return, $_+1;
          }
     }
     # no matches found
     if (scalar(@return) == 0) { return; }
     return @return;
}

1;

__END__

=head1 NAME

WWW::Scroogle - Perl Extension for Scrooge

=head1 SYNOPSIS

   use WWW::Scroogle;
   
   # create a new WWW::Scroogle object
   my $scroogle = WWW::Scroogle->new;
   
   # set searchstring
   $scroogle->searchstring('foobar');
   
   # get search_results
   my $results = $scroogle->get_results;
   
   # print rank of website 'bar'
   print $results->position('bar').'\n';
   
   # get all results
   my @results = $results->get_results;
   
   # iterate over all results
   for (@results){
       print $_->url."\n";
   }

=head1 DESCRIPTION

WWW::Scroogle uses LWP to fetch the search results from scroogle and parses
the returned html output.

=head1 METHODS

blablabla

=head2 WWW::Scroogle->new

Returns a new WWW::Scroogle object.

=head2 $searchstring = $scroogle->searchstring

returns the current searchstring

=head2 $scroogle->set_searchstring($searchstring)

sets $searchstring as the current searchstring

=head2 $language = $scroogle->language

returns the current Language - defaults to all

=head2 $scroogle->set_language($language)

sets $language as the current language

=head2 @languages = $scroogle->languages

Returns a list of avaible languages.

=head2 $num_results = $scroogle->num_results

Returns the current number of search results - defaults to 100

=head2 $scroogle->set_num_results

sets the number of results

=head2 $scroogle->perform_search

performs search and stores result. expects that a searchstring was set.

=head2 @results = $scroogle->get_results

returns list of WWW::Scroogle::Result objects.

=head2 @results = $scroogle->get_results_mach($regexp|$string)

returns list of results matching $string|$regexp

=head2 $result = $scroogle->get_result_pos(every,position,wanted)

returns the corresponding result objects

=head2 $position = $scroogle->position($string|$regexp)

returns the position of the first result matching $string|$regexp

=head2 @positions = $scroogle->positions($string|$regexp)

returns a list of the positions of all matching results.

=head1 CAVEATS

This is just a alpha release so dont expect it to work properly
ie there are no checks for null-strings and such things

=head1 AUTHOR

Written by Lars Hartmann, <lars at chaotika.org>.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Lars Hartmann, All Rights Reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
