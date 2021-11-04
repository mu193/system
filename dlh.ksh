#!/usr/bin/ksh

################################################################################
#
#   C O M M A N D   L I N E
#
################################################################################

until [[ $# -eq 0 ]]
do
  if [[ $1 =~ ^- ]]
  then
    OPT=$1 ;
    shift
  fi

  if [[ $OPT == '-start' ]]
  then
    CMD='start'
    continue 
  fi

  if [[ $OPT == '-stop' ]]
  then
    CMD='stop'
    continue 
  fi

  if [[ $OPT == '-qmgr' ]]
  then
    QMGR=$1
    shift
    continue 
  fi

  if [[ $OPT == '-path' ]]
  then
    INSTPATH=$1
    shift
    continue 
  fi

  if [[ $OPT == '-pid' ]]
  then
    PID=$1
    shift
    continue 
  fi

  if [[ $OPT == '-rule' ]]
  then
    RULE=$1
    shift
    continue 
  fi

  shift ;

done

################################################################################
#
#   M A I N  
#
################################################################################
DLH="$INSTPATH/bin/runmqdlq"
STOP="$INSTPATH/bin/amqsstop"

if [[ "$CMD" = "start" ]]
then
  $DLH "" $QMGR < $RULE
fi

if [[ "$CMD" = "stop" ]]
then
  DLPID=$(/usr/bin/ps --no-headers -e -o pid,ppid,args     |\
          /usr/bin/awk -v pid=$PID ' $2==pid {print $1}')
  $STOP -m $QMGR -p $DLPID ;
fi

