package reactor::actions::edit;
use strict;
use Exception::Sink;
use Web::Reactor::HTML::FormEngine;
use SideShow::File;

sub main
{
  my $reo = shift;

  my $in = $reo->is_logged_in();
  my $page_session_hr = $reo->get_page_session();                                                                               

  my $text;

  my $doc = $reo->param( 'DOC' );
  boom "missing DOC name" unless $doc;

  if( $reo->get_input_form_name() eq 'EDIT' and $reo->get_input_button() eq 'CANCEL' )
    {
    return $reo->forward_back();
    }
    
  if( $reo->get_input_form_name() eq 'EDIT' and $reo->get_input_button() eq 'OK' )
    {
    my $in = $reo->get_user_input();
    my $text = $in->{ 'TEXT' };
    ss_doc_write( $doc, $text );
    return $reo->forward_back();
    }
  
  my $form_def = [
                  {
                    NAME  => 'TEXT',
                    TYPE  => 'TEXT',
                    COLS  => '64',
                    ROWS  => '16',
                    LABEL => 'Document text',
                  },
                  {
                    NAME  => 'CANCEL',
                    TYPE  => 'BUTTON',
                    LABEL => '',
                    VALUE => 'CANCEL',
                  },
                  {
                    NAME  => 'OK',
                    TYPE  => 'BUTTON',
                    LABEL => '',
                    VALUE => 'OK',
                  },
                ];

  my ( $form_data, $form_errors );
  if( $reo->get_input_button() )
    {
    ( $form_data, $form_errors ) = html_form_engine_import_input( $reo, $form_def, NAME => 'EDIT' );
    }
  else
    {
    $form_data = $page_session_hr->{ 'FORM_INPUT_DATA' }{ 'EDIT' };
    $form_data->{ 'TEXT' } = ss_doc_read( $doc );
    }  
  my $form_text = html_form_engine_display( $reo, $form_def, NAME => 'EDIT', INPUT_DATA => $form_data, INPUT_ERRORS => $form_errors );

  $text .= "<h2>Editing doc: $doc</h2>";
  $text .= $form_text;
  
  return $text;
}

1;
