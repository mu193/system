# mq.systemd
systemd system files for starting and stopping mq
  
  user@.service used to enable systemd for user mqm
  
    as root:
    
    cp user@.service /etc/systemd/system/
  
    systemctl enable user@400.service  # for systems in Frankfurt
    systemctl enable user@4010.service # for systems in Luxemburg
    system daemon-reload 
    systemctl start user@400.service   # for systems in Frankfurt
    systemctl start user@4010.service  # for systems in Luxemburg

  mq@.service used to start / stop queue manager
    
    as mqm:
    
    mkdir -p /home/mqm/.config/systemd/user
    cp mq@.service /home/mqm/.config/systemd/user
    cp message /home/mqm/.config
    cp user.profile /home/mqm/.profile
   
    for each queue manager:

    cp /home/mqm/sys/profile/_QMGR_.profile /home/mqm/profile/{QMGR}.profile
    edit /home/mqm/profile/{QMGR}.profile
 
    systemctl --user enable mq@{QMGR}.service 
    systemctl --user daemon-reload
    systemctl --user start mq@{QMGR}.service
    systemctl --user stop  mq@{QMGR}.service
    
    
