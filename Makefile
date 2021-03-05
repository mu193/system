SRC = strmqm endmqm mq@.service user@.service  \
      mq.ctrl.ksh  xapass.pl                   \
      user.profile uc4.logging _QMGR_.profile  \
      installer    

.INTERMEDIATE : arch.tar.gz 

all : mqinstaller

mqinstaller : selfinstall arch.tar.gz
	cat $^ > $@


arch.tar.gz : $(SRC)
	tar czf $@ $^ 
