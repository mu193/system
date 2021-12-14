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
# HOME="$(eval echo ~${USERMQM})"
DSPMQ="/usr/bin/dspmq"
CHMOD="/usr/bin/chmod"
CHGRP="/usr/bin/chgrp"
CP="/usr/bin/cp"

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
# copy qm.ini files
#-------------------------------
[ -d /mq/data/${QMGR}/qm.ini.d ] || mkdir /mq/data/${QMGR}/qm.ini.d
${CP} ${HOME}/cfg/global.qm.chl.ini     /mq/data/${QMGR}/qm.ini.d
${CP} ${HOME}/cfg/global.qm.errlog.ini  /mq/data/${QMGR}/qm.ini.d
${CP} ${HOME}/cfg/global.qm.fs.ini      /mq/data/${QMGR}/qm.ini.d
${CP} ${HOME}/cfg/global.qm.ssl.ini     /mq/data/${QMGR}/qm.ini.d

#-------------------------------
# create {QMGR}.profile
#-------------------------------
[ -f ${HOME}/qmgr.profile/${QMGR}.profile ] || \
${CP} ${HOME}/qmgr.profile/_QMGR_.profile ${HOME}/qmgr.profile/${QMGR}.profile

#-------------------------------
# rights
#-------------------------------
${CHGRP} mqmon /var/mqm/errors
${CHGRP} mqmon /mq/data/${QMGR}/errors
${CHGRP} mqmon /mq/data/${QMGR}/errors/AMQERR*
${CHMOD} 6770 /mq/data/${QMGR}/errors
${CHMOD} 640 /mq/data/${QMGR}/errors/*

exit 0

