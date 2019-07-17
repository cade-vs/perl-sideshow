##############################################################################
##
##  Decor application machinery core
##  2014-2017 (c) Vladi Belperchinov-Shabanski "Cade"
##  <cade@bis.bg> <cade@biscom.net> <cade@cpan.org>
##
##  LICENSE: GPLv2
##
##############################################################################
package reactor::actions::login_logout;
use strict;

sub main
{
  my $reo = shift;
  
  return "<#menu_outside>" unless $reo->is_logged_in();
  return "<#menu_inside>"  if     $reo->is_logged_in();
}

1;
