package reactor::actions::home;
use strict;
use SideShow::File;
use SideShow::Format;

sub main
{
  my $reo = shift;
  
  my $in = $reo->is_logged_in();

  my $text;

  my $doc = $reo->param( 'DOC' ) || 'main';
  
  $text .= "hello worlds";

  $text .= "<p><a reactor_back_href=?>[back]</a> | <a reactor_new_href=?action=edit&doc=$doc>[edit]</a><p>";
  if( ss_doc_exists( $doc ) )
    {
    $text .= ss_doc_format( $doc );
    }
  else
    {
    $text .= "*** empty ***";
    }
  
  return $text;
}

1;
