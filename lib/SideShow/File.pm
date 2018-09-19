package SideShow::File;
use strict;
use Exception::Sink;
use Data::Tools;
use SideShow::Env;

use Exporter;
our @ISA    = qw( Exporter );
our @EXPORT = qw(

                ss_doc_read
                ss_doc_read_text
                ss_doc_read_des
                ss_doc_write
                ss_doc_write_des
                ss_doc_exists

                );

sub __fn
{
  my $fn   = lc shift;
  boom "invalid DOC name [$fn], expected alphanumeric" unless $fn =~ /^[a-z_0-9]+$/i;
  my $root = ss_get_root();
  return wantarray ? ( "$root/docs/$fn.ssdoc", "$root/docs/$fn.ssdes" ) : "$root/docs/$fn.ssdoc";
}

sub ss_doc_read
{
  my $dn   = shift;
  
  my ( $fn, $fd ) = __fn( $dn );
  
  return ( file_load( $fn ), hash_load( $fd ) );
}

sub ss_doc_read_text
{
  my $dn   = shift;
  
  my ( $data, $des ) = ss_doc_read( $dn );

  boom "error: requested DOC [$dn] is not of type TEXT" unless $des->{ 'TYPE' } eq 'TEXT';

  return wantarray ? ( $data, $des ) : $data;
}

sub ss_doc_read_des
{
  my $dn   = shift;
  
  my ( $fn, $fd ) = __fn( $dn );
  
  return hash_load( $fd );
}

sub ss_doc_write
{
  my $dn   = shift;
  my $data = shift;
  my $des  = shift || {};

  my ( $fn, $fd ) = __fn( $dn );
  
  file_save( $fn, $data );
  hash_save( $fd, $des  );
  return 1;
}

sub ss_doc_write_des
{
  my $dn   = shift;
  my $des  = shift || {};

  my ( $fn, $fd ) = __fn( $dn );
  
  hash_save( $fd, $des  );
  return 1;
}

sub ss_doc_exists
{
  my $dn   = shift;
  my $opt  = shift || {};
  
  my ( $fn, $fd ) = __fn( $dn );

  return -e $fn;
}


1;
