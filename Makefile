SRC = strmqm endmqm mq@.service user@.service  editrc \
      mq.ctrl.ksh  xapass.pl dlh.ksh                  \
      user.profile uc4.logging _QMGR_.profile         \
      service.env qm.fs.ini qm.ssl.ini qm.chl.ini     

.INTERMEDIATE : arch.tar.gz 

all : mqinstaller

mqinstaller : selfinstall arch.tar.gz
	cat $^ > $@

arch.tar.gz : $(SRC) installer cert.tar
	date "+mqinstaller %Y-%m-%d" > version
	tar czf $@ $^ version cert.tar
	rm version

cert.tar : Clearstream_Banking_CA_2.crt                                       \
        Deutsche_Boerse_AG_CA.crt Deutsche_Boerse_Group_Root_CA.crt           \
        TEST_Deutsche_Boerse_AG_CA.crt TEST_Deutsche_Boerse_Group_Root_CA.crt
	tar cf $@ $^ 

