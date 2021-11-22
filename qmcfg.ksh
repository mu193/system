#!/usr/bin/ksh

#-------------------------------
# usage
#-------------------------------
if [ $# -ne 1 ]; then
  echo "Usage: `basename $0` {Qmgr}"
  exit 0
fi

#-------------------------------
# variables
#-------------------------------
QMGR=$1
USERMQM=mqm
HOME="$(eval echo ~${USERMQM})"
DSPMQ="/usr/bin/dspmq"
CHMOD="/usr/bin/chmod"
CHGRP="/usr/bin/chgrp"

#-------------------------------
# check if queue manager exist
#-------------------------------
${DSPMQ} -m ${QMGR} >/dev/null 2>&1
QMGRSTATE=$?
 if [ ${QMGRSTATE} -ne 0 ]; then
  echo "${QMGR} does not exist"
  exit 1
 fi

#-------------------------------
# copy ini files
#-------------------------------
 if [ -d /mq/data/${QMGR}/qm.ini.d ]; then
  cp $HOME/cfg/qm.**.ini /mq/data/${QMGR}/qm.ini.d
 else
  echo "directory /mq/data/${QMGR}/qm.ini.d doesn't exist"
  exit 1
 fi

#-------------------------------
# rights
#-------------------------------
${CHGRP} mqmon /var/mqm/errors
${CHGRP} mqmon /mq/data/${QMGR}/errors
${CHMOD} 6770 /mq/data/${QMGR}/errors
${CHMOD} 640 /mq/data/${QMGR}/errors/*

exit 0

