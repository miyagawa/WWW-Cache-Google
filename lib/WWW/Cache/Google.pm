package WWW::Cache::Google;

use strict;
use vars qw($VERSION @ISA @EXPORT_OK);
$VERSION = '0.01';

require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw(url2google get_google_cache);

use URI;
use URI::Escape;

# functional wrapper
sub url2google {
    my $url = shift;
    return WWW::Cache::Google->new($url)->as_string;
}

sub get_google_cache {
    my $url = shift;
    return WWW::Cache::Google->new($url)->fetch;
}

# lexical scope for class variables
{
    my $base = 'http://www.google.com/search?q=cache:%s';
    sub google_cache_base {
	my $class = shift;
	$base = shift if @_;
	$base;
    }
}

sub new {
    my($class, $thingy) = @_;
    my $uri = _make_uri($thingy);
    my $self = bless [ $uri ], $class;
    $self->init;
    return $self;
}

sub _make_uri {
    my $thingy = shift;
    return $thingy if UNIVERSAL::isa($thingy => 'URL');
    return URI->new($thingy);
}

sub init {
    my $self = shift;
    my $uri = sprintf $self->google_cache_base, $self->_cache_param;
    $self->[1] = URI->new($uri);
}

sub _cache_param {
    my $self = shift;
    return $self->orig->host . uri_escape($self->orig->path_query, q(\W));
}

# ro-accessor
sub orig   { $_[0]->[0] }
sub cache  { $_[0]->[1] }

sub fetch {
    require LWP::Simple;
    my $self = shift;
    return LWP::Simple::get($self->cache->as_string);
}

use vars qw($AUTOLOAD);
sub AUTOLOAD {
    my $self = shift;
    (my $meth = $AUTOLOAD) =~ s/.*://;
    $self->cache->$meth(@_);
}


1;
__END__


=head1 NAME

WWW::Cache::Google - URI class for Google cache

=head1 SYNOPSIS

  use WWW::Cache::Google;

  # OO decorator way
  $cache = WWW::Cache::Google->new(URI->new('http://www.yahoo.com/'));

  print $cache->as_string; # cache URL
  print $cache; # overloaded

  $html = $cache->fetch; # fetches via LWP::Simple

  # functional way
  use WWW::Cache::Google qw(url2google get_google_cache);
  $cache_url  = url2google('http://www.yahoo.com/');
  $cache_html = get_google_cache('http://www.yahoo.com');

=head1 DESCRIPTION

WWW::Cache::Google provides an easy way conversion from an URL to
Google cache URL.

=head1 AUTHOR

Tatsuhiko Miyagawa <miyagawa@bulknews.net>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<URI>, L<URI::Escape>, L<LWP::Simple>, http;//www.google.com/

=cut
