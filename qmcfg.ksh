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
# set the MQCFG variable
#-------------------------------
CFG=/mq/data/${QMGR}/
CFG_INI=${CFG}/qm.ini.d/
CFG_MQSC=${CFG}/mqsc.d/
CFG_SSL=${CFG}/ssl/
[ $(df -h /mq | awk '{if(FNR>1) print $6}') == '/mq' ] && \
{                                \
  CFG=/mq/etc/                 ; \
  CFG_INI=${CFG}/ini/${QMGR}   ; \
  CFG_MQSC=${CFG}/mqsc/${QMGR} ; \
  CFG_SSL=${CFG}/ssl/${QMGR}   ; \
} 


#-------------------------------
# copy qm.ini files
#-------------------------------
[ -d ${CFG_INI}  ] || mkdir -p ${CFG_INI}  
[ -d ${CFG_MQSC} ] || mkdir -p ${CFG_MQSC} 
[ -d ${CFG_SSL}  ] || mkdir -p ${CFG_SSL}  
${CP} ${HOME}/cfg/global.qm.chl.ini    ${CFG_INI}  
${CP} ${HOME}/cfg/global.qm.errlog.ini ${CFG_INI}  
${CP} ${HOME}/cfg/global.qm.fs.ini     ${CFG_INI}  
${CP} ${HOME}/cfg/global.qm.ssl.ini    ${CFG_INI}  

#-------------------------------
# create {QMGR}.profile
#-------------------------------
[ -f ${HOME}/qmgr.profile/${QMGR}.profile ] || \
${CP} ${HOME}/qmgr.profile/_QMGR_.profile ${HOME}/qmgr.profile/${QMGR}.profile

#-------------------------------
# rights
#-------------------------------
if [[ "$(id -un)" == "mqm" ]]
then
  ${CHGRP} mqmon /var/mqm/errors
  ${CHGRP} mqmon /mq/data/${QMGR}/errors
  ${CHGRP} mqmon /mq/data/${QMGR}/errors/AMQERR*
  ${CHMOD} 6770 /mq/data/${QMGR}/errors
  ${CHMOD} 640 /mq/data/${QMGR}/errors/*
else
  echo "${CHMOD} only on AMQERR possible only with user mqm"
  echo "all other tasks -> OK" 
fi

exit 0

