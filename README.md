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
    cp message /home/mqm/.config/systemd
    cp profile /home/mqm/.profile
    
    systemctl --user enable mq@{QMGR}.service 
    systemctl daemon-reload
    systemctl --user start mq@{QMGR}.service
    systemctl --user stop  mq@{QMGR}.service
    
    
