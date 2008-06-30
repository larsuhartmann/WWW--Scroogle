package WWW::Scroogle::Result;

use 5.008008;
use strict;
use warnings;
use Carp;

our $VERSION = '0.002';

sub new
{
     my $class = shift;
     my $options = shift;
     if (not ref $options eq "HASH") { croak 'no options hash provided!'; }
     if (not exists $ {$options}{url}) { croak 'url expected!'; }
     if (not exists $ {$options}{position}) { croak 'position expected!'; }
     if (not exists $ {$options}{searchstring}) { croak 'searchstring expected!'; }
     if (not exists $ {$options}{language}) { croak 'language expected!'; }

     my $self;
     $self->{url} = $ {$options}{url};
     $self->{position} = $ {$options}{position};
     $self->{searchstring} = $ {$options}{searchstring};
     $self->{language} = $ {$options}{language};
     bless $self, $class;

     return $self;
}

sub searchstring
{
     ref(my $self = shift)
          or croak 'instance variable needed!';
     return $self->{searchstring};
}

sub language
{
     ref(my $self = shift)
          or croak 'instance variable needed!';
     return $self->{language};
}

sub position
{
     ref(my $self = shift)
          or croak 'instance variable needed!';
     return $self->{position};
}

sub url
{
     ref(my $self = shift)
          or croak 'instance variable needed!';
     return $self->{url};
}
1;
