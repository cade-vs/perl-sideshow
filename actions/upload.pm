package reactor::actions::upload;
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

  if( $reo->get_input_form_name() eq 'UPLOAD' and $reo->get_input_button() eq 'CANCEL' )
    {
    return $reo->forward_back();
    }
    
  if( $reo->get_input_form_name() eq 'UPLOAD' and $reo->get_input_button() eq 'OK' )
    {
    my $in = $reo->get_user_input();
    my $text = $in->{ 'TEXT' };
    ss_doc_write( $doc, $text );

    my $file_name   = $in->{ 'FILE' };
    my $file_handle = $in->{ 'FILE:FH' };
    my $file_info   = $in->{ 'FILE:UPLOAD_INFO' };
    binmode( $file_handle );
    local $/ = undef;
    my $file_body = <$file_handle>;
    ss_doc_write( $doc, $file_body, { TYPE => 'BIN', MIME => $file_info->{ 'Content-Type' } } );
    
    print STDERR "body length: " . length($file_body) . " ******************\n";

    return $reo->forward_back();
    }
  
  my $form_def = [
                  {
                    NAME  => 'FILE',
                    TYPE  => 'FILE',
                    LABEL => 'File upload test',
                  },
                  {
                    NAME  => 'TEXT',
                    TYPE  => 'TEXT',
                    COLS  => '64',
                    ROWS  => '4',
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
    ( $form_data, $form_errors ) = html_form_engine_import_input( $reo, $form_def, NAME => 'UPLOAD' );
    }
  else
    {
    $form_data = $page_session_hr->{ 'FORM_INPUT_DATA' }{ 'UPLOAD' };
    }  
  my $form_text = html_form_engine_display( $reo, $form_def, NAME => 'UPLOAD', INPUT_DATA => $form_data, INPUT_ERRORS => $form_errors );

  $text .= "<h2>Uploading doc: $doc</h2>";
  $text .= $form_text;
  
  return $text;
}

1;
