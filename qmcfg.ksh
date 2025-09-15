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

#-------------------------------
# check if /mq exists as the file system || 
# check if /mq/etc exists as a dir. 
#   This option is used on dev only.
#   you must create /mq/etc manually on dev
#-------------------------------
[ $(df -h /mq | awk '{if(FNR>1) print $6}') == '/mq' ] || \
[ -d /mq/etc ] && \
{                                \
  CFG=/mq/etc                  ; \
  CFG_INI=${CFG}/ini/${QMGR}   ; \
  CFG_MQSC=${CFG}/mqsc/${QMGR} ; \
  CFG_SSL=${CFG}/ssl/${QMGR}   ; \
} 

#-------------------------------
# create directories for configuration
#-------------------------------
[ -d ${CFG_INI}  ] || mkdir -p ${CFG_INI}  
[ -d ${CFG_MQSC} ] || mkdir -p ${CFG_MQSC} 
[ -d ${CFG_SSL}  ] || mkdir -p ${CFG_SSL}  

#-------------------------------
# copy qm.ini files
#-------------------------------
${CP} ${HOME}/cfg/global.qm.chl.ini    ${CFG_INI}  
${CP} ${HOME}/cfg/global.qm.errlog.ini ${CFG_INI}  
${CP} ${HOME}/cfg/global.qm.fs.ini     ${CFG_INI}  
${CP} ${HOME}/cfg/global.qm.ssl.ini    ${CFG_INI}  

[ -d ${CFG}/mqsc/${QMGR} ] && \
{
  echo "ALTER QMGR CERTLABL('${QMGR}_int')"            >${CFG_MQSC}/qmgr.ssl.mqsc
  echo "ALTER QMGR SSLKEYR('/mq/etc/ssl/${QMGR}/key')">>${CFG_MQSC}/qmgr.ssl.mqsc
}

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

