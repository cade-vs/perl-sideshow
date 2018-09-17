package SideShow::Env;
use strict;
use Exception::Sink;

use Exporter;
our @ISA    = qw( Exporter );
our @EXPORT = qw(

                ss_set_root
                ss_get_root

                );



my $ROOT;
sub ss_set_root
{
  my $root = shift;
  boom "ROOT already set, cannot be reset" if $ROOT and -d $ROOT;
  $ROOT = $root;
}

sub ss_get_root
{
  boom "ROOT not set, but it is mandatory" unless $ROOT;
  return $ROOT;
}


1;
