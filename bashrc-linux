#
# Shell configuration specific to Linux
#

# Add yourself to group
function gadd() {
  gpasswd -a $(whoami) "$1"
}

# Remove yourself from group
function gdel() {
  gpasswd -d $(whoami) "$1"
}

# Connect to a wifi
function wifi() {
  [[ $# -eq 0 ]] && echo "Usage: $0 <wifi-name> [<wifi-password>]" && return 1

  if [[ $# == 1 ]]; then
    iwctl station wlan0 connect "$1"
  else
    iwctl -P "$2" station wlan0 connect "$1"
  fi
}

# Show wifi password
function wpasswd () {
  nmcli connection show "$1" -s | grep psk
}

alias wifis="nmtui connect"
alias wknown="iwctl known-networks list"
alias wlist="nmcli dev wifi list"
alias wscan="iwlist wlan0 scanning"
alias killwifi="iwctl station wlan0 disconnect && killall dhclient"
alias rewi="sudo systemctl restart NetworkManager"

alias pmix="pulsemixer"
alias vplay="mplayer -vo fbdev2"
alias cplay="mpv -vo caca"

alias bb="acpi -i"
alias zzz="sudo echo mem > /sys/power/state"
