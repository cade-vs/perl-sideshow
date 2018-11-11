#!/usr/bin/perl
use lib '/home/cade/perl';
use Web::Reactor;
use strict;

my $ROOT = "/home/cade/pro/sideshow";


my %cfg = (
          'APP_NAME'       => 'sideshow',
          'APP_ROOT'       => $ROOT,
          'LIB_DIRS'       => [ "$ROOT/lib/" ],
          'HTML_DIRS'      => [ "$ROOT/html/" ], 
          'SESS_VAR_DIR'   => "$ROOT/var/sess/",
          'REO_ACTS_CLASS' => 'Web::Reactor::Actions::Alt',
          'DEBUG'          => 1,
          'DISABLE_SECURE_COOKIES'  => 1,
          );

eval 
  { 
  my $app = new Web::Reactor( %cfg );
  require SideShow::Env;
  SideShow::Env::ss_set_root( $ROOT );
  $app->run(); 
  };
if( $@ )
  {
  print STDERR "REACTOR CGI EXCEPTION: $@";
  print "content-type: text/html\n\nsystem is temporary unavailable";
  }
