################################################################################
#
# chkmqconfig.kshq
#
# check user configuration:
#   - mqm (user & groups)
################################################################################
#!/usr/bin/ksh

PAGER=cat

[ -z "$1" ] || PAGER="$1"

{
cat <<EOF
################################################################################
# USER CHECK
################################################################################
EOF

# ------------------------------------------------------------------------------
# user mqm
# ------------------------------------------------------------------------------

# ----------------------------------------------------------
# check if user mqm exists
# ----------------------------------------------------------
echo "check user mqm "
echo -ne "\tuser mqm exists\t\t....................... "
getent passwd mqm >> /dev/null
rc=$?
if [[ $rc -eq 0 ]]
then
  echo "OK" ;
else
  echo "ERR  failed user mqm doesnt exist"
fi

# ----------------------------------------------------------
# check if user mqm has a right id (400 / 4010)
# ----------------------------------------------------------
id=$(id -u mqm)
echo -ne "\tuser mqm id $id \t....................... "
if [[ $id -eq '400' ]] ; then
  echo "OK for Frankfurt"
elif [[ $id -eq '4010' ]] ; then
  echo "OK for Luxemburg"
else
  echo "ERR wrong id"
fi

# ----------------------------------------------------------
# check if user mqm has right group id (400 / 4000)
# ----------------------------------------------------------
id=$(id -g mqm)
echo -ne "\tgroup mqm id $id\t....................... "
if [[ $id -eq '400' ]] ; then
  echo "OK for Frankfurt"
elif [[ $id -eq '4000' ]] ; then
  echo "OK for Luxemburg"
else
  echo "ERR wrong id"
fi

# ----------------------------------------------------------
# check if user mqm has the right shell
# ----------------------------------------------------------
pswd=$(getent passwd mqm)
shell=$(basename $(echo $pswd | awk -F: '{print $7}'))
echo -en "\tmqm shell\t\t....................... "
if [[ $shell = "ksh" ]]
then
  echo "OK"
else
  echo -e "ERR\n\t\t $shell not allowed"
fi

# ----------------------------------------------------------
# check if mqm is a primary group of user mqm
# ----------------------------------------------------------
grp=$(groups mqm | awk -F: '{print $2}')
echo  -ne "\tprimary group mqm\t....................... "
if [[ $(echo $grp | grep -q "^mqm ") -eq 0 ]]
then
  echo "OK"
else
  echo "ERR"
fi
grp=${grp/mqm / }

# ----------------------------------------------------------
# check if mqm is member of system-jounal
# ----------------------------------------------------------
echo  -ne "\tsecondary group systemd-journal ............... "
if [[ $(echo $grp | grep -q "systemd-journal") -eq 0 ]]
then
  echo "OK"
else
  echo "ERR"
fi
grp=${grp/systemd-journal/ }

# ----------------------------------------------------------
# check if mqm is member of group mqmon
# ----------------------------------------------------------
echo  -ne "\tsecondary group mqmon\t....................... "
if [[ $(echo $grp | grep -q "mqmon") -eq 0 ]]
then
  echo "OK"
else
  echo "ERR"
fi
grp=${grp/mqmon/ }

# ----------------------------------------------------------
# check if mqm has other groups
# ----------------------------------------------------------
echo  -e "\tcheck other groups:"
if [[ -z ${grp// } ]]
then
  echo ":OK"
else
  for sec in $(echo $grp)
  do
    echo -e "\t\tuser mqm in group $sec\t....... WAR"
  done
fi

# ----------------------------------------------------------
# check if other user are in group mqm
# ----------------------------------------------------------
echo -en "\tcheck group mqm"
grp=$(getent group mqm | awk -F: '{print $4}' | tr -d " " )

if [[ -z "$grp" ]]
then
  echo "...................... OK"
  else
    echo " :"
    for member in $(echo $grp | tr "," " " )
    do
      echo -e "\t\tuser $member in group mqm\t....... ERR"
    done
fi

# ------------------------------------------------------------------------------
# user mcaadm
# ------------------------------------------------------------------------------

# ----------------------------------------------------------
# check if user mcaadm exists
# ----------------------------------------------------------
echo -e "\ncheck user mcaadm "
echo -ne "\tuser mcaadm exists\t....................... "
pswd=$(getent passwd mcaadm)
rc=$?
if [[ $rc -eq 0 ]]
then
  echo "OK" ;
else
  echo "ERR  failed user mcaadm doesnt exist"
fi

# ----------------------------------------------------------
# check if mcaadm has unvalid shell
# ----------------------------------------------------------
shell=$(basename $(echo $pswd | awk -F: '{print $7}'))
echo -en "\tmcaadm shell\t\t....................... "
if [[ $shell = "nologin" ]]
then
  echo "OK"
else
  echo -e "ERR\t$shell not allowed"
fi

# ----------------------------------------------------------
# check if mcaadm has primary group mcaadm
# ----------------------------------------------------------
grp=$(groups mcaadm | awk -F: '{print $2}' )
echo -en "\tprimary group mcaadm\t....................... "
if [[ $(echo $grp | grep -q "^mcaadm ") -eq 0 ]]
then
  echo "OK"
else
  echo "ERR mcaadm is member of $grp "
fi
grp=${grp/mcaadm / }

# ----------------------------------------------------------
# check if other user in group mcaadm
# ----------------------------------------------------------
grp=$(getent group mcaadm | awk -F: '{print $4}')
echo -en "\tmcaadm group member\t....................... "
if [[ -z ${grp// } ]]
then
  echo "OK"
else
  for $member in $(echo $grp)
  do
    echo -e "\t\tuser $member in group mcaadm ............ ERR"
  done
fi

# ------------------------------------------------------------------------------
# user mqdeploy
# ------------------------------------------------------------------------------

# ----------------------------------------------------------
# check if user mqdeploy exists
# ----------------------------------------------------------
echo -e "\ncheck user mqdeploy "
echo -ne "\tuser mqdeploy exists\t....................... "
pswd=$(getent passwd mqdeploy)
rc=$?
if [[ $rc -eq 0 ]]
then
  echo "OK" ;
else
  echo "ERR  failed user mqdeploy doesnt exist"
fi

# ----------------------------------------------------------
# check if user has a unvalid shell
# ----------------------------------------------------------
shell=$(basename $(echo $pswd | awk -F: '{print $7}'))
echo -en "\tmqdeploy shell\t\t....................... "
if [[ $shell = "nologin" ]]
then
  echo "OK"
else
  echo -e "ERR $shell not allowed"
fi

# ----------------------------------------------------------
# check if mqdeploy has primary group mqdeploy
# ----------------------------------------------------------
grp=$(groups mqdeploy | awk -F: '{print $2}' )
echo -en "\tprimary group mqdeploy\t....................... "
if [[ $(echo $grp | grep -q "^mqdeploy ") -eq 0 ]]
then
  echo "OK"
else
  echo "ERR mqdeploy is member of $grp "
fi
grp=${grp/mqdeploy / }

# ----------------------------------------------------------
# check if other user are member of group mqdeploy
# ----------------------------------------------------------
grp=$(getent group mqdeploy | awk -F: '{print $4}')
echo -en "\tmqdeploy group member\t"

if [[ -z "$grp" ]]
then
  echo " ...................... OK"
else
  for member in $(echo $grp | tr "," " " )
  do
    echo -e "\t\tuser $member in group mqdeploy .............. ERR"
  done
fi

# ------------------------------------------------------------------------------
# user mqmon
# ------------------------------------------------------------------------------

# ----------------------------------------------------------
# check if user mqmon exists
# ----------------------------------------------------------
echo -e "\ncheck user mqmon "
echo -ne "\tuser mqmon exists\t....................... "
pswd=$(getent passwd mqmon)
rc=$?
if [[ $rc -eq 0 ]]
then
  echo "OK" ;
else
  echo "ERR  failed user mqmon doesnt exist"
fi

# ----------------------------------------------------------
# check if user mqmon has korn shell
# ----------------------------------------------------------
shell=$(basename $(echo $pswd | awk -F: '{print $7}'))
echo -en "\tcheck mqmon shell\t....................... "
if [[ $shell = "ksh" ]]
then
  echo "OK"
else
  echo -e "ERR $shell not allowed"
fi

# ----------------------------------------------------------
# check if user mqmon has a primary group mqmon
# ----------------------------------------------------------
grp=$(groups mqmon | awk -F: '{print $2}' )
echo -en "\tprimary group mqmon\t....................... "
if [[ $(echo $grp | grep -q "^mqmon ") -eq 0 ]]
then
  echo "OK"
else
  echo "ERR mqmon is member of $grp "
fi
grp=${grp/mqmon/ }

# ----------------------------------------------------------
# check if user mqmon is member of systemd-journal
# ----------------------------------------------------------
echo -en "\tsecondary group systemd-journal\t............... "
if [[ $(echo $grp | grep -q "systemd-journal") -eq 0 ]]
then
  echo "OK"
else
  echo "ERR"
fi
grp=${grp/systemd-journal/ }

# ----------------------------------------------------------
# check if other user are member of group of mqmon
# ----------------------------------------------------------
echo -en "\tmqmon group member"
if [[ -z ${grp// } ]]
then
  echo -e "\t................... OK"
else
  for member in $(echo $grp)
  do
    echo -en "\n\t\tgroup mqmon has member $member\t....... WAR"
  done
  echo ""
fi
} |$PAGER

{
cat <<EOF
################################################################################
# INSTALLATION CHECK
################################################################################
EOF
echo
dspver="/usr/bin/dspmqver"
echo -en "primary installation set\t....................... " ;
if [[ -x $dspver ]]
then
  echo "OK"
else
  echo "ERR"
fi

qmgrver=$(/usr/bin/dspmq -o installation | tr " " "\n"                   |\
                                           tr "()" " "                   |\
                                           awk '$1~/INSTVER/ {print $2}' |\
                                           sort -n                       |\
                                           head -1                       )

# 1=Server or client
# 2=Java
# 4=JMS
# 16=WCF
# 32=XMS
# 64=GSKit
# 128=AMS
# 256=AMQP
# 512=MQXR
# 1024=Other
# 2048=WebSphere Liberty Profile
# 4096=Java Runtime Environment
# 8192=RDQM
# 16384=Managed File Transfer

for inst in $($dspver -i | awk -F: '$1=/InstPath/ {print $2}')
do
  cmd="$inst/bin/dspmqver"
  ver=$($cmd -f 2 -b)
  echo -e "\ncheckg MQ-Ver:$ver"

  echo -en "\tkeep installation\t....................... "
  if [[ $ver < $qmgrver ]]
  then
    echo -e "ERR"
  else
    echo -e "OK"
  fi
  # --------------------------------------------------------
  # Server
  # --------------------------------------------------------
  echo -en "\tServer or client\t....................... "
  name=$($cmd -p 1 -f 1 -b )
  subver=$($cmd -p 1 -f 2 -b )
  if [[ $name = "IBM MQ" ]]
  then
    if [[ $subver = $ver  ]]
    then
      echo "OK"
    else
      echo "ERR ver $subver"
    fi
  else
    echo "ERR name $name"
  fi

  # --------------------------------------------------------
  # Java
  # --------------------------------------------------------
  echo -en "\tJava\t....................................... "
  name=$($cmd -p 2 -f 1 -b )
  subver=$($cmd -p 2 -f 2 -b )
  if [[ $name = "IBM MQ classes for Java" ]]
  then
    if [[ $subver = $ver  ]]
    then
      echo "OK"
    else
      echo "ERR ver $subver"
    fi
  else
    echo "ERR name $name"
  fi

  # --------------------------------------------------------
  # JMS
  # --------------------------------------------------------
  echo -en "\tJMS\t....................................... "
  subver=$($cmd -p 4 -f 2 -b | head -1 )

  if [[ $subver = $ver  ]]
  then
    echo "OK"
  else
    echo "ERR ver $subver"
  fi

  $cmd -p 4 -f 1 -b | awk '!/^$/{printf("\t\t%s\n",$0)}'

  # --------------------------------------------------------
  # GSK
  # --------------------------------------------------------
  name=$(  $cmd -p 64 -f 1 -b | grep -v AMQ8250I)
  subver=$($cmd -p 64 -f 2 -b | grep -v AMQ8250I)
  echo -en "\tGSK (V $subver)\t....................... "
  if [[ $name = "IBM Global Security Kit for IBM MQ" ]]
  then
    echo "OK"
  else
    echo "ERR name $name"
  fi

  # --------------------------------------------------------
  # AMS
  # --------------------------------------------------------
  name=$($cmd -p 128 -f 1 -b )
  echo -en "\tAMS "
  if [[ $(echo $name | grep -q "^AMQ8250I:") -eq 0 ]]
  then
    echo -e "(not installed)\t....................... OK"
  else
    echo -e "(installed)\t....................... ERR"
  fi

  # --------------------------------------------------------
  # AMQP
  # --------------------------------------------------------
  name=$($cmd -p 512 -f 1 -b )
  echo -en "\tAMQP "
  if [[ $(echo $name | grep -q "^AMQ8250I:") -eq 0 ]]
  then
    echo -e "(not installed)\t....................... OK"
  else
    echo -e "(installed)\t....................... ERR"
  fi
done

} | $PAGER


################################################################################
# loop over all queue manager 
################################################################################

for qmgr in $(dspmq | tr "()" " " | awk '{print $2}')
do
{
cat <<EOF

################################################################################
# QMGR CHECK $qmgr
################################################################################
EOF
  echo "checking user qmgr $qmgr "
  # 1   - get all RCVR & SVRCONN chls
  # 1.1 - check if mcauser set to 'dummy'
  # 1.2 - check if CHLAUTH exists
  # 1.3 - check if MCAUSER in CHLAUTH has unvalid shell

  # 2. check file systems (must be own FS, credentials, size)
  # 2.1 data
  # 2.2 log
  # 2.3 var
  # 2.4 opt
  # 2.5 home

  # 3. certifcates
  # 3.1 certlabl must exist
  # 3.2 internal must exist
  # 3.3 CA's must exist (depends on environment)
} | $PAGER
done

# all under this point should be in a loop, otherwise only the last qmgr will be checked

# ----------------------------------------------------------
#   1.1   - check if mcauser set to 'dummy' on all RCVR chls
# ----------------------------------------------------------
i=0
echo -ne "checking mcauser set to 'dummy' on receiver channels\t....................... "
for channel in $(echo "dis chl(*) chltype(rcvr) where(mcauser ne 'dummy')" | runmqsc $qmgr | tr "()" " " | awk '$1~/CHANNEL/ {print $2}' )
do
  if [[ i -eq 0 ]]
    then
      echo "ERR failed for the following channels: "
      echo -ne "\t$channel\n"
      let i++
    else
      echo -ne "\t$channel\n"
  fi
done

if [[ -z "$channel" ]]
  then
    echo "OK"
fi

# ----------------------------------------------------------
#  1.2   - check if mcauser set to 'dummy' on all RQSTR chls
# ----------------------------------------------------------
i=0
echo -ne "checking mcauser set to 'dummy' on requester channels\t....................... "
for channel in $(echo "dis chl(*) chltype(rqstr) where(mcauser ne 'dummy')" | runmqsc $qmgr | tr "()" " " | awk '$1~/CHANNEL/ {print $2}' )
do
  if [[ i -eq 0 ]]
    then
      echo "ERR failed for the following channels: "
      echo -ne "\t$channel\n"
      let i++
    else
      echo -ne "\t$channel\n"
  fi
done

if [[ -z "$channel" ]]
  then
    echo "OK"
fi

# SVRCONN is missing

# ----------------------------------------------------------
# 1.3   - check if MCAUSER in CHLAUTH has invalid shell
# ----------------------------------------------------------
i=0
echo -ne "chlauth mcauser shell set to 'nologin'\t....................... "
for mcauser in $(echo "dis chlauth(*)" | runmqsc $qmgr | tr "()" " " | awk '$1~/MCAUSER/ {print $2}' | sort -u)
do
  pswd=$(getent passwd $mcauser)
  shell=$(basename $(echo $pswd | awk -F: '{print $7}'))
  if [ "$shell" != "nologin" ] | [ "$shell" != "false" ]
    then
    if [[ i -eq 0 ]]
      then
        echo "ERR failed shell is not set to 'nologin' on following mca users: "
        echo -ne "\t$mcauser\n"
        let i++
      else
        echo -ne "\t$mcauser\n"
        let i++
    fi
  fi
done

if [[ i -eq 0 ]]
  then
    echo "OK"
fi

# ----------------------------------------------------------
# 2.1   - check FS User  (AMQ6242E)
# split this part into system and qmgr part
# move system part to the top
# move qmgr part into loop
# ----------------------------------------------------------
i=0
echo -ne "MQ filesystems Ownership\t....................... "
#    for ownership in $(crtmqdir -a 2>&1 | awk 'NR%2{printf"%s ",$0;next}2' | tr "()" " " | awk '$1~/AMQ6242E:/ {print $4}')
for ownership in $(crtmqdir -a 2>&1 | tr "()" " " | awk '$1~/AMQ6242E:/ {print $5}')
do
  if [[ i -eq 0 ]]
    then
      echo "ERR failed User is not set to 'mqm' on following FSs: "
      echo -ne "\t$ownership\n"
      let i++
    else
      echo -ne "\t$ownership\n"
      let i++
  fi
done

# ----------------------------------------------------------
# manual check on /home/mqm and /mq/log
# ----------------------------------------------------------
# /home/mqm
# move home to top
for fs in $(find /home/mqm ! -user mqm )
do
  if [[ i -eq 0 ]]
    then
      echo "ERR failed for following FSs: "
      echo -ne "\t$fs\n"
      let i++
    else
      echo -ne "\t$fs\n"
  fi
done

# /mq/log
# move log to loop & reconsidure to use /mq/log/$qmgr 
for fs in $(find /mq/log ! -user mqm )
do
  if [[ i -eq 0 ]]
    then
      echo "ERR failed for following FSs: "
      echo -ne "\t$fs\n"
      let i++
    else
      echo -ne "\t$fs\n"
  fi
done

if [[ i -eq 0 ]]
  then
    echo "OK"
fi

# ----------------------------------------------------------
# 2.2   - check FS Group  (AMQ6243E)
# ----------------------------------------------------------
i=0
echo -ne "MQ filesystems Group\t....................... "
#    for group in $(crtmqdir -a 2>&1 | awk 'NR%2{printf"%s ",$0;next}2' | tr "()" " " | awk '$1~/AMQ6243E:/ {print $6}')
for group in $(crtmqdir -a 2>&1 | tr "()" " " | awk '$1~/AMQ6243E:/ {print $6}')
do
  if [[ i -eq 0 ]]
    then
      echo "ERR failed Group is not set to 'mqm' on following FSs: "
      echo -ne "\t$group\n"
      let i++
    else
      echo -ne "\t$group\n"
      let i++
  fi
done

# ----------------------------------------------------------
# manual check on /home/mqm and /mq/log
# move home to top
# move /mq/log to loop, reconsidure /mq/log/$qmgr
# ----------------------------------------------------------
# /home/mqm
for fs in $(find /home/mqm ! -group mqm )
do
  if [[ i -eq 0 ]]
    then
      echo "ERR failed for following FSs: "
      echo -ne "\t$fs\n"
      let i++
    else
      echo -ne "\t$fs\n"
  fi
done

# /mq/log
for fs in $(find /mq/log ! -group mqm )
do
  if [[ i -eq 0 ]]
    then
      echo "ERR failed for following FSs: "
      echo -ne "\t$fs\n"
      let i++
    else
      echo -ne "\t$fs\n"
  fi
done

if [[ i -eq 0 ]]
  then
    echo "OK"
fi

# ----------------------------------------------------------
# 2.3   - check FS Permission  (AMQ6244E)
# split system and queue manager 
# move system to top 
# move qmgr to loop
# ----------------------------------------------------------
i=0
echo -ne "MQ filesystems Permission\t....................... "
#    for permission in $(crtmqdir -a 2>&1 | awk 'NR%2{printf"%s ",$0;next}2' | tr "()" " " | awk '$1~/AMQ6244E:/ {print $6}')
for permission in $(crtmqdir -a 2>&1 | tr "()" " " | awk '$1~/AMQ6244E:/ {print $6}')
do
  if [[ i -eq 0 ]]
    then
      echo "ERR failed Permission is not set correctly on following FSs: "
      echo -ne "\t$permission\n"
      let i++
    else
      echo -ne "\t$permission\n"
      let i++
  fi
done

# ----------------------------------------------------------
# manual check on /home/mqm and /mq/log
# move home to top
# move log to loop, reconsidure /mq/log/$qmgr
# ----------------------------------------------------------
# /home/mqm - G and O must not have W access
for permission in $(find /home/mqm -perm /g=w,o=w )
do
  if [[ i -eq 0 ]]
    then
      echo "ERR failed Permission is not set correctly on following FSs: "
      echo -ne "\t$permission\n"
      let i++
    else
      echo -ne "\t$permission\n"
  fi
done

# /home/mqm/.ssh - G and O must have no priviledge
for permission in $(find /home/mqm/.ssh ! -perm 700 )
do
  if [[ i -eq 0 ]]
    then
      echo "ERR failed Permission is not set correctly on following FSs: "
      echo -ne "\t$permission\n"
      let i++
    else
      echo -ne "\t$permission\n"
  fi
done

# /mq/log - O must have no priviledge
for permission in $(find /mq/log -perm /o=rwx )
do
  if [[ i -eq 0 ]]
    then
      echo "ERR failed Permission is not set correctly on following FSs: "
      echo -ne "\t$permission\n"
      let i++
    else
      echo -ne "\t$permission\n"
  fi
done

if [[ i -eq 0 ]]
  then
    echo "OK"
fi


# ----------------------------------------------------------
# 2.4   - check FS mountpoint
# ----------------------------------------------------------
echo -ne "FS Mountpoints\t\t....................... "
i=0

# /opt/mqm
if [[ $(df -m /opt/mqm | awk '$1~/dev/ {print $6}' ) == "/" ]]
  then
    echo "ERR failed for following FSs: "
    echo -ne "\t/opt/mqm\n"
    let i++
fi

# /home/mqm
if [[ $(df -m /home/mqm | awk '$1~/dev/ {print $6}' ) == "/" ]]
  then
    if [[ i -eq 0 ]]
      then
        echo "ERR failed for following FSs: "
        echo -ne "\t/home/mqm\n"
        let i++
      else
        echo -ne "\t/home/mqm\n"
    fi
fi

# /mq/log
if [[ $(df -m /mq/log | awk '$1~/dev/ {print $6}' )  == "/" ]]
  then
    if [[ i -eq 0 ]]
      then
        echo "ERR failed for following FSs: "
        echo -ne "\t/mq/log\n"
        let i++
      else
        echo -ne "\t/mq/log\n"
    fi
fi

if [[ i -eq 0 ]]
  then
    echo "OK"
fi

# ----------------------------------------------------------
# 3 - check Certificate in Keystore
# move to loop
# ----------------------------------------------------------
echo -ne "Default certificate\t....................... "
certlabl=$(echo "dis QMGR CERTLABL" | runmqsc $qmgr   | tr "()" " " | awk '$1~/QMNAME/ {print $4}' )
if [[ -z "$certlabl" ]]
  then
    echo "ERR failed CERTLABL not set in QMGR configuration"
  else
    sslkeyr=$(echo "dis QMGR SSLKEYR" | runmqsc $qmgr   | tr "()" " " | awk '$1~/QMNAME/ {print $4}' )
    label=$(/usr/bin/runmqakm -cert -list -stashed -db $sslkeyr.kdb | grep -E "$certlabl" )
    if [[ -z "$label" ]]
      then
        echo "ERR failed "$certlabl" not found in keystore"
      else
        echo "OK"
    fi
fi

if [[ $certlabl != "$qmgr"_int ]]
  then
    echo -ne "Internal certificate\t....................... "
    label=$(/usr/bin/runmqakm -cert -list -stashed -db $sslkeyr.kdb | grep -E "$qmgr"_int )
    if [[ -z "$label" ]]
      then
        echo "ERR failed "$qmgr"_int not found in keystore"
      else
        echo "OK"
    fi
fi
# ----------------------------------------------------------


