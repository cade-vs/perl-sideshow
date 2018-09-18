package reactor::actions::showimg;
use strict;
use SideShow::File;
use SideShow::Format;

sub main
{
  my $reo = shift;
  
  my $in = $reo->is_logged_in();

  my $text;

  my $doc = $reo->param( 'DOC' );
  
  if( ss_doc_exists( $doc ) )
    {
    $reo->render_data( ss_doc_read( $doc ), 'image/jpeg' );
    }
  else
    {
    $text .= "undef";
    }
  
  return $text;
}

1;
