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
# /opt/mqm/91a/bin/setmqxacred -m A31HUB11 -x AQAccess -u hub_app_user -p $p
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

my( $cfgUser, $cfgEnv) = &getCfg($cfg) if defined $cfg ;
$user = $cfgUser unless defined $user ;
$env  = $cfgEnv  unless defined $env  ;

$user = $ENV{USERNAME} if exists $ENV{USERNAME} ;
$env  = $ENV{ENVNAME}  if exists $ENV{USERNAME} ;

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

    $user = $val if $key eq 'USERNAME' ;
    $env  = $val if $key eq 'ENVNAME' ;
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
  my $qmgr = $_[0] ;

  my $ini = "/mq/data/$qmgr/qm.ini" ;

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

print "environment start\n" ;

foreach my $key (keys %ENV)
{
  print "$key $ENV{$key}\n" ;
}

print "environment stop\n" ;

my %qmIni = readQmIni $qmgr ;
my $xaManager = $qmIni{XAResourceManager}{Name} ;
my $passwd = getPasswd $user, $env ;
setPasswd( $qmgr, $xaManager, $user, $passwd ) ;


