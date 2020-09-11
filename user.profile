strmqm() 
{ 
  cat ~/.config/message 
}
endmqm() 
{ 
  cat ~/.config/message 
}

export PS1=`whoami`@`/bin/hostname`'$ '
export MQPROMPT="+QMNAME+> "

[[ $0 == "-ksh" ]] &&
       unalias vi  &&
       unalias ls  &&
       unalias rm 

export PATH=$PATH:.
export CDPATH=.:$HOME

set -o vi

