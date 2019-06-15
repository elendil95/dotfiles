alias vpns='expressvpn status'
alias vpnc='expressvpn connect'
alias vpnd='expressvpn disconnect'
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -Iv'
alias cd..='cd ..'
alias ll='ls -lah'
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
