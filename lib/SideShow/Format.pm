package SideShow::Format;
use strict;
use SideShow::File;
use Exception::Sink;

use Exporter;
our @ISA    = qw( Exporter );
our @EXPORT = qw(

                ss_doc_format

                );



sub ss_doc_format
{
  my $dn = shift;
  
  my $text = ss_doc_read( $dn );
  
  $text =~ s/\[([#])([a-z_0-9\-]+)\]/__item( $1, $2 )/gie;
  
  return $text;
}

sub __item
{
  my $type = shift;
  my $item = shift;
  
  if( $type eq '#' )
    {
    if( ss_doc_exists( $item ) )
      {
      return "<a reactor_new_href=?action=home&doc=$item>$item</a>";
      }
    else
      {
      return "<a reactor_new_href=?action=edit&doc=$item>[create: $item]</a>";
      }  
    }
  else
    {
    return undef;
    }  
}

1;
