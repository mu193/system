################################################################################
#
# this a standar mqm profile
#   please don't change it, it might be overwritten
#
################################################################################

# ------------------------------------------------------------------------------
# diable bypass systemd by calling strmqm / endmqm directly 
# ------------------------------------------------------------------------------
strmqm() 
{ 
  cat ~/.config/message 
}
endmqm() 
{ 
  cat ~/.config/message 
}

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

export PATH=$PATH:.
export CDPATH=.:$HOME

set -o vi

