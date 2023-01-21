#!/usr/bin/ksh

{
################################################################################
#
# USER CHECK
#
################################################################################

# ------------------------------------------------------------------------------
# user mqm
# ------------------------------------------------------------------------------
echo "checking user mqm "
echo -ne "\tuser mqm exists\t\t..................... " 
getent passwd mqm >> /dev/null
rc=$?
if [[ $rc -eq 0 ]]
then 
  echo "OK" ;
else
  echo "ERR  failed user mqm doesnt exist" 
fi

id=$(id -u mqm)
echo -ne "\tuser mqm id $id \t..................... "
if [[ $id -eq '400' ]] ; then
  echo "OK for Frankfurt"
elif [[ $id -eq '4010' ]] ; then
  echo "OK for Luxemburg" 
else
  echo "ERR wrong id"
fi

id=$(id -g mqm)
echo -ne "\tgroup mqm id $id\t..................... "
if [[ $id -eq '400' ]] ; then
  echo "OK for Frankfurt"
elif [[ $id -eq '4000' ]] ; then
  echo "OK for Luxemburg" 
else
  echo "ERR wrong id"
fi
  
pswd=$(getent passwd mqm) 
shell=$(basename $(echo $pswd | awk -F: '{print $7}'))
echo -en "\tcheck mqm shell\t\t..................... "
if [[ $shell = "ksh" ]] 
then
  echo "OK" 
else
  echo -e "ERR\n\t\t $shell not allowed"
fi

grp=$(groups mqm | awk -F: '{print $2}')
echo  -ne "\tprimary group mqm\t..................... "
if [[ $(echo $grp | grep -q "^mqm ") -eq 0 ]]
then
  echo "OK"
else
  echo "ERR"
fi
grp=${grp/mqm / }

echo  -ne "\tsecondary group systemd-journal ............. "
if [[ $(echo $grp | grep -q "systemd-journal") -eq 0 ]]
then
  echo "OK"
else
  echo "ERR"
fi
grp=${grp/systemd-journal/ }

echo  -ne "\tsecondary group mqmon\t..................... "
if [[ $(echo $grp | grep -q "mqmon") -eq 0 ]]
then
  echo "OK"
else
  echo "ERR"
fi
grp=${grp/mqmon/ }

echo  -e "\tcheck other groups:" 
if [[ -z ${grp// } ]]
then
  echo "OK"
else
  for sec in $(echo $grp)
  do
    echo -e "\t\tuser mqm in group $sec\t..... WAR"
  done
fi

echo -en "\tcheck group mqm"
grp=$(getent group mqm | awk -F: '{print $4}' | tr -d " " )

if [[ -z "$grp" ]]
then 
  echo "..................... OK"
  else
    echo " :"
    for member in $(echo $grp | tr "," " " )
    do
      echo -e "\t\tuser $member in group mqm ............ ERR"
    done
fi

# ------------------------------------------------------------------------------
# user mcaadm
# ------------------------------------------------------------------------------
echo "checking user mcaadm "
echo -ne "\tuser mcaadm exists\t..................... " 
pswd=$(getent passwd mcaadm) 
rc=$?
if [[ $rc -eq 0 ]]
then 
  echo "OK" ;
else
  echo "ERR  failed user mcaadm doesnt exist" 
fi

shell=$(basename $(echo $pswd | awk -F: '{print $7}'))
echo -en "\tcheck mcaadm shell\t..................... "
if [[ $shell = "nologin" ]] 
then
  echo "OK" 
else
  echo -e "ERR\n\t\t$shell not allowed"
fi

grp=$(groups mcaadm | awk -F: '{print $1}' | tr -d " " )
echo -en "\tmcaadm group membership\t..................... "
if [[ $grp  = 'mcaadm' ]]
then
  echo "OK"
else
  echo "ERR mcaadm is member of $grp "
fi

grp=$(getent group mcaadm | awk -F: '{print $4}')
echo -en "\tmcaadm group member\t..................... " 
if [[ -z ${grp// } ]]
then
  echo "OK"
else
  for $member in $(echo $grp)
  do
    echo -e "\t\tuser $member in group mcaadm ............ WAR"
  done
fi

# ------------------------------------------------------------------------------
# user mqdeploy
# ------------------------------------------------------------------------------
echo "checking user mqdeploy "
echo -ne "\tuser mqdeploy exists\t..................... " 
pswd=$(getent passwd mqdeploy) 
rc=$?
if [[ $rc -eq 0 ]]
then 
  echo "OK" ;
else
  echo "ERR  failed user mqdeploy doesnt exist" 
fi

shell=$(basename $(echo $pswd | awk -F: '{print $7}'))
echo -en "\tcheck mqdeploy shell\t..................... "
if [[ $shell = "nologin" ]] 
then
  echo "OK" 
else
  echo -e "ERR\n\t\t $shell not allowed"
fi

grp=$(groups mqdeploy | awk -F: '{print $1}' | tr -d " " )
echo -en "\tmqdeploy group membership ................... "
if [[ $grp  = 'mqdeploy' ]]
then
  echo "OK"
else
  echo "ERR mqdeploy is member of $grp "
fi

grp=$(getent group mqdeploy | awk -F: '{print $4}')
echo -en "\tmqdeploy group member\t..................... " 
if [[ -z ${grp// } ]]
then
  echo "OK"
else
  for $member in $(echo $grp)
  do
    echo -e "\t\tuser $member in group mqdeploy ............ WAR"
  done
fi

# ------------------------------------------------------------------------------
# user mqmon
# ------------------------------------------------------------------------------
echo "checking user mqmon "
echo -ne "\tuser mqmon exists\t..................... " 
pswd=$(getent passwd mqmon) 
rc=$?
if [[ $rc -eq 0 ]]
then 
  echo "OK" ;
else
  echo "ERR  failed user mqmon doesnt exist" 
fi

shell=$(basename $(echo $pswd | awk -F: '{print $7}'))
echo -en "\tcheck mqmon shell\t..................... "
if [[ $shell = "ksh" ]] 
then
  echo "OK" 
else
  echo -e "ERR\n\t\t $shell not allowed"
fi

grp=$(groups mqmon | awk -F: '{print $1}' | tr -d " " )
echo -en "\tmqmon group membership\t..................... "
if [[ $grp  = 'mqmon' ]]
then
  echo "OK"
else
  echo "ERR mqdeploy is member of $grp "
fi

grp=$(getent group mqdeploy | awk -F: '{print $4}')
echo -en "\tmqdeploy group member\t..................... " 
if [[ -z ${grp// } ]]
then
  echo "OK"
else
  for $member in $(echo $grp)
  do
    echo -e "\t\tuser $member in group mqmon ............ WAR"
  done
fi
} 

################################################################################
#
# INSTALLATION
# 
################################################################################
{
echo
dspver="/usr/bin/dspmqver"
echo "installation check"
echo -en "\tprimary installation set\t............. " ;
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
  echo -e "\n\tchecking $ver"

  echo -en "\t\tkeep installation\t............. "
  if [[ $ver < $qmgrver ]]
  then
    echo -e "ERR"
  else
    echo -e "OK"
  fi
  # --------------------------------------------------------
  # Server
  # --------------------------------------------------------
  echo -en "\t\tServer or client\t............. "
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
  echo -en "\t\tJava\t............................. "
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
  echo -en "\t\tJMS\t............................. "
  subver=$($cmd -p 4 -f 2 -b | head -1 )

  if [[ $subver = $ver  ]]
  then
    echo "OK"
  else
    echo "ERR ver $subver"
  fi

  $cmd -p 4 -f 1 -b | awk '!/^$/{printf("\t\t\t%s\n",$0)}'

  # --------------------------------------------------------
  # GSK
  # --------------------------------------------------------
  name=$(  $cmd -p 64 -f 1 -b | grep -v AMQ8250I)
  subver=$($cmd -p 64 -f 2 -b | grep -v AMQ8250I)
  echo -en "\t\tGSK (V $subver)\t............. "
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
  echo -en "\t\tAMS "
  if [[ $(echo $name | grep -q "^AMQ8250I:") -eq 0 ]]
  then 
    echo -e "(not installed)\t............. OK"
  else
    echo -e "(installed)\t............. ERR"
  fi

  # --------------------------------------------------------
  # AMQP
  # --------------------------------------------------------
  name=$($cmd -p 512 -f 1 -b )
  echo -en "\t\tAMQP "
  if [[ $(echo $name | grep -q "^AMQ8250I:") -eq 0 ]]
  then 
    echo -e "(not installed)\t............. OK"
  else
    echo -e "(installed)\t............. ERR"
  fi
done

} 

################################################################################
#
# QMGR
#
################################################################################
for qmgr in $(dspmq | tr "()" " " | awk '{print $2}')
do
  echo ""
  echo "checking user qmgr $qmgr "
done
