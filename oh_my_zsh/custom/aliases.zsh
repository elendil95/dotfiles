alias vpns='expressvpn status'
alias vpnc='expressvpn connect'
alias vpnd='expressvpn disconnect'
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -iv'
alias timezones='tzwatch'
alias du='du -sh'
alias df='df -hT -x tmpfs'

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
