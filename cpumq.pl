#!/usr/bin/perl

my $qmgr = $ARGV[0] ;
die "qmgr not set" unless defined $qmgr ;
shift @ARGV ;

my $path =  $ARGV[0] ;
die "qmgr not set" unless defined $qmgr ;

use strict ;

use FileHandle ;           # for file handel as object
use IPC::Open2 ;           # for runmqsc starting in the background
use POSIX ":sys_wait_h" ;  # for no hang on runmqsc in the background
use Time::HiRes qw(usleep) ;

my $amqsru = "/opt/mqm/942a/samp/bin/amqsrua " ;


my $wr = FileHandle->new() ;
my $rd = FileHandle->new() ;
my $pid = open2( $rd, $wr, "$amqsru -m $qmgr -c CPU -t QMgrSummary" );

usleep 100000 ;

if( $pid == waitpid $pid, &WNOHANG )      # check if runmqsc is still
{                                         #
  $pid = 0;
  close $wr;
  close $rd;
  die "can connect to default queue manager, aborting..." ;
}

my $date ;
my $time ;
my $sysCPU ;
my $usrCPU ;
my $ram ;

while ( my $line = <$rd> )
{
  chomp $line ;
  if( $line =~ /\sPutDate:(\d{8})\s+PutTime:(\d{8})\s/ )
  {
    $date = $1;
    $time = $2;
    next ;
  }
  if( $line =~ /User CPU time - .+\s(\d+\.\d+%)/ )
  {
    $usrCPU = $1 ;
    next ;
  }
  if( $line =~ /System CPU time - .+\s(\d+\.\d+%)/ )
  {
    $sysCPU = $1 ;
    next ;
  }
  if( $line =~ /RAM total bytes - .+\s(\d+\w{2})/ )
  {
    $ram = $1 ;
    next ;
  }
  
  if( $line =~ /^\s*$/ )
  {
    open FD, ">>", "$path/$qmgr.cpu.$date.stat" ;
    print FD "$date $time $sysCPU $usrCPU $ram\n" ;
    close FD ;
    next ;
  }
  print FD "$date $time >$line< \n" ;
}
