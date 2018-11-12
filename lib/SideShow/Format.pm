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

  my $plain;
  my @in  = split /\n/, $text;
  my @out;
  while( @in )
    {
    my $line = shift @in;
    if( $line =~ /^\s*=cut/i )
      {
      $plain = ! $plain;
      next;
      }
    if( $plain )
      {
      push @out, $line;
      next;
      }
    if( $line =~ /^\s*=h(\d)\s*(.*)/i )
      {
      my $t = inline_formatting( $2 );
      push @out, "<h$1>$t</h$1>\n";
      next;
      }
    if( $line =~ /^\s*$/ )
      {
      push @out, "<br>\n";
      next;
      }

    $line =~ s/\[([#\*]+)([a-z_0-9\-]+)(\s*(.*))?\]/__item( $1, $2, $3 )/gie;
    $line = inline_formatting( $line );
    push @out, $line;
    }
  
  return join '', @out;
}

sub __item
{
  my $type = shift;
  my $item = shift;
  my $args = shift;
  
  if( $type eq '#' )
    {
    my $name = inline_formatting( $args || $item );
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

sub inline_formatting
{
  my $text = shift;
  
  $text =~ s/\*\*(.+?)\*\*/<b>$1<\/b>/g;
  $text =~ s/__(.+?)__/<tt>$1<\/tt>/g;
  return $text;
}

1;
