#!/usr/bin/ksh

  qmgr=ADMPF1

  # 1.2   - check if MCAUSER in CHLAUTH has invalid shell

    i=0
    echo -ne "\tchlauth mcauser shell set to 'nologin'\t....................... "

    for mcauser in $(echo "dis chlauth(*)" | runmqsc $qmgr | tr "()" " " | awk '$1~/MCAUSER/ {print $2}' | sort -u)
    do
      pswd=$(getent passwd $mcauser)
      shell=$(basename $(echo $pswd | awk -F: '{print $7}'))

      if [[ $shell != nologin ]]
       then
        if [[ i -eq 0 ]]
          then
            echo "ERR failed shell is not set to 'nologin' on following mca users: "
            echo "$mcauser"
            let i++
          else
            echo "$mcauser"
            let i++
         fi
       fi
    done

    if [[ i -eq 0 ]]
    then
      echo "OK"
    fi

