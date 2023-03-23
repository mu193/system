#!/usr/bin/ksh

  qmgr=ADMPF1

  echo "checking receiver channels "

  # 1.1   - check if mcauser set to 'dummy' on all RCVR chls

  echo -ne "\tmcauser on the channel set to 'dummy'\t....................... "
  channel=$(echo "dis chl(*) chltype(rcvr) where(mcauser ne 'dummy')" | runmqsc $qmgr | tr "()" " " | awk '$1~/CHANNEL/ {print $2}' )
  if [[ -z "$channel" ]]
    then
      echo "OK"
    else
      echo "ERR failed for the following channels: "
      echo "$channel"
  fi

