SRC = strmqm endmqm mq@.service user@.service editrc       \
      mq.ctrl.ksh xapass.pl dlh.ksh qmcfg.ksh              \
      mq.serv.exec.ksh chkmqconfig.ksh cpumq.pl            \
      user.profile _QMGR_.profile service.env              \
      scp.own  sscmd.own remote.commands  remote.transfer  \
      global.qm.fs.ini global.qm.ssl.ini global.qm.chl.ini global.qm.errlog.ini      
      

.INTERMEDIATE : arch.tar.gz 

all : mqinstaller

mqinstaller : selfinstall arch.tar.gz
	cat $^ > $@
	chmod 755 $@

arch.tar.gz : $(SRC) installer cert.tar
	date "+mqinstaller %Y-%m-%d" > version
	tar czf $@ $^ version 
	rm version

cert.tar : Clearstream_Banking_CA_2.crt BAT_Clearstream_CA.pub               \
           Deutsche_Boerse_AG_CA.crt Deutsche_Boerse_Group_Root_CA.crt       \
           TEST_Deutsche_Boerse_AG_CA.crt TEST_Deutsche_Boerse_Group_Root_CA.crt
	tar cf $@ $^ 

clean: 
	rm mqinstaller
