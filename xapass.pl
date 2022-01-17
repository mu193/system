#!/usr/bin/perl

################################################################################
#
#   X A P A S S . P L   
#     set XA password 
#
# ------------------------------------------------------------------------------
#
# description:
#   get password via get_password and set it for queue manager vi setmqxacred   
#
# call:
#  xapass.pl -qmgr QMGR -cfg env.file -env env_name -user USER
#    -qmgr QMGR is mandantory
#    environment_name and user are mandantory but they can be set either by 
#    command line (-env , -user) or in -cfg file
#
################################################################################

use strict ; 

my $getpass = "/usr/local/bin/get_passwd" ;
my $setpass = "setmqxacred" ;
my $dspmq   = "/usr/bin/dspmq -o installation " ;

################################################################################
#
#   C O M M A N D   L I N E    
#
################################################################################
my $qmgr ;
my $user ;
my $env  ;
my $cfg  ;

my $opt ;

while( defined $ARGV[0] )
{
  if( $ARGV[0] =~ s/^-// )
  {
    $opt = $ARGV[0] ;
    shift ;
    next  ;
  }

  if( $opt eq 'qmgr' )
  {
    $qmgr = $ARGV[0] ;
    shift ;
    next  ;
  }

  if( $opt eq 'user' )
  {
    $user = $ARGV[0] ;
    shift ;
    next  ;
  }

  if( $opt eq 'env' )
  {
    $env = $ARGV[0] ;
    shift ;
    next  ;
  }

  if( $opt eq 'cfg' )
  {
    $cfg = $ARGV[0] ;
    shift ;
    next  ;
  }

  &usage() ;
}

&usage() unless defined $qmgr ;

# $qmIni{XAResourceManager}{Name}

my $ini = "/mq/data/$qmgr/qm.ini" ;
my %qmIni = &readQmIni( $ini );
exit 0 unless( exists $qmIni{XAResourceManager} );

my( $cfgUser, $cfgEnv) = &getCfg($cfg) if defined $cfg ;
$user = $cfgUser unless defined $user ;
$env  = $cfgEnv  unless defined $env  ;

$user = $ENV{XA_USER_NAME} if exists $ENV{XA_USER_NAME} ;
$env  = $ENV{XA_ENV_NAME}  if exists $ENV{XA_ENV_NAME} ;

&usage() unless defined $user ;
&usage() unless defined $env  ;

# ------------------------------------------------------------------------------
# usage
# ------------------------------------------------------------------------------
sub usage
{
  die "
  use:   $0 -qmgr [QMGR] -user [USER] -env [ENV]
  
  QMGR\tqueue manager
  USER\toracle user
  ENV\tenvironment

" ;
}

# ------------------------------------------------------------------------------
# read cfg
# ------------------------------------------------------------------------------
sub getCfg
{
  my $cfg = $_[0] ;
 
  my $user ;
  my $env  ;
 
  return () unless open CFG, $cfg ;

  foreach my $line (<CFG>)
  {
    chomp $line ;

    next if $line =~ /^\s*#/ ;
    next if $line =~ /^\s*$/ ;

    next unless $line =~ /^\s*(\w+)\s*=\s*(\S+)\s*$/ ;
    my $key = $1;
    my $val = $2;

    $user = $val if $key eq 'XA_USER_NAME' ;
    $env  = $val if $key eq 'XA_ENV_NAME' ;
  }

  return ($user, $env);
}

################################################################################
#
#   F U N C T I O N S   
#
################################################################################

# ------------------------------------------------------------------------------
# get_password wraper function
# ------------------------------------------------------------------------------
sub getPasswd
{
  my $user = $_[0] ;
  my $env  = $_[1] ;

  my $pass = `$getpass $user $env` ;

  return $pass ;
}

# ------------------------------------------------------------------------------
# readm qm ini
# ------------------------------------------------------------------------------
sub readQmIni
{
  my $ini = $_[0] ;


  die "can't open $ini" unless open INI, "$ini" ;

  my %qmini ;

  my $stanza ;
  
  foreach my $line (<INI>)
  {
    chomp $line ;
    next if $line =~ /^\s*#/ ;  # ignore comment line
    next if $line =~ /^\s*$/ ;  # ignore comment empty
  
    if( $line =~ /^\s*(\w+):/ )
    {
      $stanza = $1 ;
      next ;
    }
    $line =~ /^\s*(\w+)\s*=\s*(\S+)\s*$/ ;
    my $key = $1 ;
    my $val = $2 ;
 
    if( $stanza eq 'AutoConfig' &&
        $key    eq 'IniConfig'   )
    {
      if( -d $val )
      {
        foreach my $file ( glob "$val/*" ) 
        {
          my %subIni = &readQmIni($file);
          %qmini = (%qmini, %subIni);
        }
      }
      else
      {
        my %subIni = &readQmIni($val);
        %qmini = (%qmini, %subIni);
      }
    }
 
    $qmini{$stanza}{$key} = $val ;
  }
  close INI ;

  return %qmini ;
}

# ------------------------------------------------------------------------------
# get install path
# ------------------------------------------------------------------------------
sub getMqInstallPath
{
  my $qmgr = $_[0] ;
  
  my $line = `$dspmq -m $qmgr` ;
  chomp $line ;
  $line =~ s/^.+INSTPATH\((.+)\).+$/$1/ ;

  return $line ;
}

# ------------------------------------------------------------------------------
# set password
# ------------------------------------------------------------------------------
sub setPasswd
{
  my $qmgr = $_[0] ;
  my $xa   = $_[1] ;
  my $user = $_[2] ;
  my $pass = $_[3] ;

  my $path = getMqInstallPath( $qmgr );
  `$path/bin/$setpass -m $qmgr -x $xa -u $user -p $pass` ;
  return ;
}

################################################################################
#
#   M A I N   
#
################################################################################

my $xaManager = $qmIni{XAResourceManager}{Name} ;
my $passwd = getPasswd $user, $env ;
setPasswd( $qmgr, $xaManager, $user, $passwd ) ;

