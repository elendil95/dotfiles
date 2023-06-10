# Basic Sysytem aliases
alias cd..='cd ..'
alias ll='ls -lah'
alias la='ls -lAh'
alias l='ls -CF'
# alias lsa='ls -lah'
alias cp='cp -v'
alias mv='mv -v'

#User aliases
alias rm='rm -Iv'
alias timezones='tzwatch'
alias du='du -sh'
alias df='df -hT -x tmpfs'
alias reminder='calcurse -d 14'
alias gs='git status'
alias gt='tig'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gca='git commit -a -m'
alias gpl='git pull'
alias gps='git push'
alias gd='git diff'
alias gcl='git clone'
alias vm='vim'
alias vpns='expressvpn status'
alias vpnc='expressvpn connect'
alias vpnd='expressvpn disconnect'

binary(){
echo "obase=2; $1"|bc

}

hex(){
echo "obase=16; $1"|bc
}

hex2Binary(){
echo "ibase=16; obase=2; $1"|bc
}

binary2Hex(){
echo "ibase=2; obase=16; $1"|bc
}

wheretfis(){
 #using : after a switch variable means it requires some input (ie, t: requires something after t to validate while h requires nothing.
while getopts “hp:” OPTION
do
     case $OPTION in
         h)
             echo "Usage wheretfis <pattern>"
             echo "-p: Optional. Specify a path. '.' Will be used by default"
             ;;
         p)
             PATH=$OPTARG
             ;;
     esac
done

if [ -z $PATH ]; then
    # -H is a GNU grep flag
    egrep -RHn "$1" "$PATH"
else
    egrep -RHn "$1" .
fi
}

# # usage: ex <file>
extract(){
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
