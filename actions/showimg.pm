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
    my ( $data, $des ) = ss_doc_read( $doc );
    $reo->render_data( $data, $des->{ 'MIME' } );
    }
  else
    {
    $text .= "undef";
    }
  
  return $text;
}

1;
