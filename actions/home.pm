package reactor::actions::home;
use strict;
use Data::Dumper;
use SideShow::File;
use SideShow::Format;

sub main
{
  my $reo = shift;
  
  my $in = $reo->is_logged_in();
  my $ps = $reo->get_page_session();
  my $rs = $reo->get_page_session( 1 );

  my $text;

  my $doc = $reo->param( 'DOC' ) || 'main';
  $ps->{ 'DOC' } = $doc;
  
  my $back_doc = $rs->{ 'DOC' };
  
  $text .= "<p><a reactor_none_href=?action=home&doc=main>[home]</a>";
  $text .= " | <a reactor_back_href=?>[back to $back_doc]</a>" if $back_doc;
  $text .= " | <a reactor_new_href=?action=edit&doc=$doc>[edit]</a><p>";
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
