SRC = strmqm endmqm mq@.service user@.service  editrc \
      mq.ctrl.ksh  xapass.pl dlh.ksh                  \
      user.profile uc4.logging _QMGR_.profile         \
      service.env qm.fs.ini qm.ssl.ini qm.chl.ini     

.INTERMEDIATE : arch.tar.gz 

all : mqinstaller

mqinstaller : selfinstall arch.tar.gz
	cat $^ > $@


arch.tar.gz : $(SRC) installer
	tar czf $@ $^ 
