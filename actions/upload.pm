package reactor::actions::upload;
use strict;
use Exception::Sink;
use Web::Reactor::HTML::FormEngine;
use SideShow::File;

sub main
{
  my $reo = shift;

  my $in = $reo->is_logged_in();
  return "Access denied" unless $in;

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
    my $des         = $in->{ 'DES' };
    my $file_name   = $in->{ 'FILE' };
    my $file_handle = $in->{ 'FILE:FH' };
    my $file_info   = $in->{ 'FILE:UPLOAD_INFO' };

    if( $file_name )
      {
      binmode( $file_handle );
      local $/ = undef;
      my $file_body = <$file_handle>;
      my $file_len  = length( $file_body );
      ss_doc_write( $doc, $file_body, { TYPE => 'BIN', MIME => $file_info->{ 'Content-Type' }, LEN => $file_len, DES => $des } );
      }
    else
      {
      # update only description
      my $ds = ss_doc_read_des( $doc );
      $ds->{ 'DES' } = $des;
      ss_doc_write_des( $doc, $ds );
      }  

    return $reo->forward_back();
    }

  my $des;
  if( ss_doc_exists( $doc ) )
    {
    $des = ss_doc_read_des( $doc );
    }
  
  my $form_def = [
                  {
                    NAME  => 'FILE',
                    TYPE  => 'FILE',
                    LABEL => 'Upload new file version',
                  },
                  {
                    NAME  => 'DES',
                    TYPE  => 'TEXT',
                    COLS  => '64',
                    ROWS  => '4',
                    LABEL => 'Document description',
                  },
                  {
                    NAME  => 'OK',
                    TYPE  => 'BUTTON',
                    LABEL => '',
                    VALUE => 'OK',
                  },
                  {
                    NAME  => 'CANCEL',
                    TYPE  => 'BUTTON',
                    LABEL => '',
                    VALUE => 'CANCEL',
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
    $form_data->{ 'DES' } = $des->{ 'DES' };
    }  
  my $form_text = html_form_engine_display( $reo, $form_def, NAME => 'UPLOAD', INPUT_DATA => $form_data, INPUT_ERRORS => $form_errors );

  $text .= "<h2>Updating detauls for document: $doc</h2>";
  $text .= $form_text;
  
  return $text;
}

1;
