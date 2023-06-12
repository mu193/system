#!/usr/bin/ksh

################################################################################
# restart queue manager and rotate password via UC4
# 
# prerequisites:
#   the queue manager must be either under VCS or systemd control
#   primary mq installation has to be defined
#
# description:
#   stop or start queue manager 
#     via vcs commands if VCS is installed, 
#     via systemctl user command if VCS is not installed
#   password will be rotated on each start, 
# 
################################################################################


# ------------------------------------------------------------------------------
# Command line
# ------------------------------------------------------------------------------
CMD=$1
QMGR=$2

# ------------------------------------------------------------------------------
# commands
# ------------------------------------------------------------------------------
SYSCTL="/usr/bin/systemctl"
DSPMQ="/usr/bin/dspmq"

# ------------------------------------------------------------------------------
# main
# ------------------------------------------------------------------------------

# ----------------------------------------------------------
# check if queue manager is valid
# ----------------------------------------------------------
${DSPMQ} -m ${QMGR} >> /dev/null 2>&1 ; rc=$?;

case ${rc} in
  0)   ;;
  36)  
    echo "DSPMQ: Invalid arguments supplied"
    exit 1;;
  58)  
    echo "DSPMQ: Inconsistent use of installations detected"
    exit 1;;
  71)  
   echo "DSPMQ: Unexpected error"
   exit 1;;
  72)  
   echo "DSPMQ: Queue manager name error"
   exit 1;;
  *)
esac;

# ----------------------------------------------------------
# real work
# ----------------------------------------------------------

case ${CMD} in
  # --------------------------------------------------------
  # stop queue manager
  # --------------------------------------------------------
  "-stop")
      ${SYSCTL} --user stop mq@${QMGR}.service
    ;;

  # --------------------------------------------------------
  # start queue manager
  # --------------------------------------------------------
  "-start")
      ${SYSCTL} --user start mq@${QMGR}.service
    ;;

  # --------------------------------------------------------
  # wrong call
  # --------------------------------------------------------
  *)
    echo "$0 [-start | -stop] $QMGR"
    exit 1 ;

esac;

