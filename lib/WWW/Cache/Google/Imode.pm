package WWW::Cache::Google::Imode;

use strict;
use vars qw($VERSION);
$VERSION = '0.01';

use base qw(WWW::Cache::Google);

sub cache_base {
    return 'http://wmlproxy.google.com/chtmltrans/p=i/s=0/u=%s/c=0';
}

1;
__END__


=head1 NAME

WWW::Cache::Google::Imode - URI class for Google proxy on i-mode

=head1 SYNOPSIS

  use WWW::Cache::Google::Imode;

  # OO decorator way
  $cache = WWW::Cache::Google::Imode->new('http://www.yahoo.com/');

  $url  = $cache->as_string;	# cache URL
  $html = $cache->fetch; 	# fetches via LWP::Simple

=head1 DESCRIPTION

Easy conversion from HTML to CHTML. That's google on i-mode!

WWW::Cache::Google::Imode provides an easy way conversion from an URL
to Google i-mode proxy/cache URL.

=head1 METHODS

Same as WWW::Cache::Google.

=head1 AUTHOR

Tatsuhiko Miyagawa <miyagawa@bulknews.net>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<WWW::Cache::Google>.

=cut
