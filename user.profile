# ------------------------------------------------------------------------------
# systemd if real user id not mqm
# ------------------------------------------------------------------------------
export XDG_RUNTIME_DIR="/run/user/${UID}"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"

# ------------------------------------------------------------------------------
# prompt for shell & runmqsc
# ------------------------------------------------------------------------------
export PS1=`whoami`@`/bin/hostname`'$ '
export MQPROMPT="+QMNAME+> "

# ------------------------------------------------------------------------------
# setting up for ksh (only ksh)
# ------------------------------------------------------------------------------
[[ $0 == "-ksh" ]] &&
       unalias vi  &&
       unalias ls  &&
       unalias rm 

# ------------------------------------------------------------------------------
# general usage of the shell
# ------------------------------------------------------------------------------
export PATH=$HOME/.bin:$PATH:$HOME/bin:.
export CDPATH=.:$HOME
export MANPATH=$MANPATH:$(dspmqver -f 128 -b)/man 

set -o vi

# ------------------------------------------------------------------------------
# involve local customized profiles 
# ------------------------------------------------------------------------------
for prof in $HOME/.profile.d/*
do
  [ $(echo "$prof" | grep -P '^disable\.') ] || source $prof
done
