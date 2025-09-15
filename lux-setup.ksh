groupadd mqmon
useradd -c "IBM MQ Read-Only" -d /home/mqmon -m -g mqmon -G systemd-journal -s /bin/ksh mqmon
groupadd -g 4000 mqm
useradd -c "IBM MQ Admin" -d /home/mqm -m -g mqm -G systemd-journal,mqmon -s /bin/ksh -u 4010 mqm
mkdir -p /mq/etc
mkdir -p /mq/data
mkdir -p /mq/log
chown -R mqm:mqm /mq

