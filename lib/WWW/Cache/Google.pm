package WWW::Cache::Google;

use strict;
use vars qw($VERSION @ISA @EXPORT_OK);
$VERSION = '0.02';

require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw(url2google get_google_cache);

use URI;
use URI::Escape;

# functional wrapper
sub url2google {
    my $url = shift;
    return __PACKAGE__->new($url)->as_string;
}

sub get_google_cache {
    my $url = shift;
    return __PACKAGE__->new($url)->fetch;
}

sub cache_base {
    return 'http://www.google.com/search?q=cache:%s';
}


# ro-accessor
sub orig   { $_[0]->[0] }
sub cache  { $_[0]->[1] }

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
    my $uri = sprintf $self->cache_base, $self->_cache_param;
    $self->[1] = URI->new($uri);
}

sub _cache_param {
    my $self = shift;
    return $self->orig->host . uri_escape($self->orig->path_query, q(\W));
}

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
  $cache = WWW::Cache::Google->new('http://www.yahoo.com/');

  $url  = $cache->as_string;	# cache URL
  $html = $cache->fetch; 	# fetches via LWP::Simple

  # functional way
  use WWW::Cache::Google qw(url2google get_google_cache);
  $cache_url  = url2google('http://www.yahoo.com/');
  $cache_html = get_google_cache('http://www.yahoo.com');

=head1 DESCRIPTION

404 Not Found. But wait ... there's a google cache!

WWW::Cache::Google provides an easy way conversion from an URL to
Google cache URL.

=head1 METHODS

=over 4

=item $cache = WWW::Cache::Google->new($url);

constructs WWW::Cache::Google instance.

=item $orig_uri = $cache->orig;

returns original URL as URI instance.

=item $cache_uri = $cache->cache;

returns Google cache URL as URI instance.

=item $html = $cache->fetch;

gets HTML contents of Google cache. Requires L<LWP::Simple>.

=item $url_str = $cache->as_string;

returns Google cache's URL as string. Every method defined in URI
class is autoloaded through $cache->cache. See L<URI> for details.

=back

=head1 FUNCTIONS

Following functions are provided for non-OO programmers, or one-liners.

=over 4

=item $cache_url = url2google($url);

converts URL to Google cache URL. Same as

  $cache_url = WWW::Cache::Google->new($url)->as_string;


=item $cache_html = get_google_cache($url);

returns HTML contents of Google cache. Same as:

  $cache_html = WWW::Cache::Google->new($url)->fetch;

=back

These functions are not exported by default.


=head1 AUTHOR

Tatsuhiko Miyagawa <miyagawa@bulknews.net>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<URI>, L<URI::Escape>, L<LWP::Simple>, http;//www.google.com/

=cut
