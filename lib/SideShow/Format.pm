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
  
  my ( $text, $des ) = ss_doc_read_text( $dn );

  my @text = split /\n/, $text;
  for( @text )
    {
    if( /^\s*=h(\d)\s*(.*)/ )
      {
      $_ = "<h$1>$2</h$1>\n";
      next;
      }
    if( /^\s*$/ )
      {
      $_ = "<br>\n";
      next;
      }
  
    s/\[([#\*])([a-z_0-9\-]+)(\s*(.*))?\]/__item( $1, $2, $3 )/gie;
    }
  
  return join '', @text;
}

sub __item
{
  my $type = shift;
  my $item = shift;
  my $args = shift;
  
  if( $type eq '#' )
    {
    my $name = $args || $item;
    # FIXME: text formatting for $name
    if( ss_doc_exists( $item ) )
      {
      return "<a reactor_new_href=?action=home&doc=$item>$name</a>";
      }
    else
      {
      return "<a reactor_new_href=?action=edit&doc=$item>[create: $name]</a>";
      }  
    }
  if( $type eq '*' )
    {
    if( ss_doc_exists( $item ) )
      {
      my $des = ss_doc_read_des( $item );
      $des = $des->{ 'DES' } if $des;
      my $args;
      $args .= "width=$2"  if $des =~ /\/w(idth)?\s*(\d*)/;
      $args .= "height=$2" if $des =~ /\/h(eight)?\s*(\d*)/;
      $args .= "width=$1 height=$2" if $des =~ /\/wh\s*(\d*)x(\d*)/;
      return "<img reactor_new_src=?action=showimg&doc=$item $args><a reactor_new_href=?action=upload&doc=$item>[*]</a>";
      }
    else
      {
      return "<a reactor_new_href=?action=upload&doc=$item>[upload image: $item]</a>";
      }  
    }
  else
    {
    return undef;
    }  
}

1;
