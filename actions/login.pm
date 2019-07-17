package reactor::actions::login;
use strict;

use Data::Dumper;

sub main
{
  my $reo = shift;

  my $ui        = $reo->get_user_input();
  my $button    = $reo->get_input_button_and_remove();
  my $button_id = $reo->get_input_button_id();

  my $user;
  my $pass;

  return "<#login_form>" unless $button eq 'LOGIN';

  $user = $ui->{ 'USER' };
  $pass = $ui->{ 'PASS' };
  
  my $login_ok = 1 if $user eq 'cade';

  if( $login_ok )
    {
    $reo->login();                                                                                                              
    $reo->forward_new( ACTION => 'home' );
    }
  else
    {
    $reo->html_content_set( 'login-error' => "Login error, please, try again." );
    return "<#login_form>";
    }  
  
}

1;
