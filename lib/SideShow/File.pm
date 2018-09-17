package SideShow::File;
use strict;
use Exception::Sink;
use Data::Tools;
use SideShow::Env;

use Exporter;
our @ISA    = qw( Exporter );
our @EXPORT = qw(

                ss_doc_read
                ss_doc_write
                ss_doc_exists

                );

sub __fn
{
  my $fn   = lc shift;
  boom "invalid DOC name [$fn], expected alphanumeric" unless $fn =~ /^[a-z_0-9]+$/i;
  my $root = ss_get_root();
  return "$root/docs/$fn.ssdoc";
}

sub ss_doc_read
{
  my $dn   = shift;
  my $opt  = shift || {};
  
  my $fn = __fn( $dn );
  
  return file_load( $fn );
  
}

sub ss_doc_write
{
  my $dn   = shift;
  my $data = shift;
  my $opt  = shift || {};

  my $fn = __fn( $dn );
  
  return file_save( $fn, $data );
}

sub ss_doc_exists
{
  my $dn   = shift;
  my $opt  = shift || {};
  
  my $fn = __fn( $dn );

  return -e $fn;
}


1;
