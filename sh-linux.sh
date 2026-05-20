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

function getip() {
  ip -4 -o addr show scope global up | awk '{split($4,a,"/"); print a[1]; exit}'
}

function getip6() {
  ip -6 -o addr show scope global up | awk '{split($4,a,"/"); print a[1]; exit}'
}

function getips() {
  ip -o -brief addr show up 2>/dev/null \
    | awk '{for(i=3;i<=NF;i++){split($i,a,"/"); if(a[1] !~ /^127(\\.|$)/ && a[1] !~ /^::1$/ && a[1] !~ /^fe80:/) print a[1]}}'
}

# Connect to a wifi
function wifi() {
  if [[ $# -eq 0 ]]; then
    ssid=$(nmcli -t -f active,ssid dev wifi | awk -F: '$1=="yes"{print $2}')
    if [[ -n "$ssid" ]]; then
      echo "$ssid"
    else
      echo "Not connected to a wifi"
    fi

    return
  fi

  if [[ $# == 1 ]]; then
    nmcli device wifi connect "$1"
  else
    nmcli device wifi connect "$1" password "$2"
  fi
}

# Show wifi password
function wpasswd() {
  # Use active Wi-Fi connection (if no arguments)
  if [[ $# -eq 0 ]]; then
    ssid=$(nmcli -t -f active,ssid dev wifi | awk -F: '$1=="yes"{print $2}')
    if [[ -z "$ssid" ]]; then
      echo "Usage: wpasswd <ssid>"
      return 1
    fi
  else
    ssid="$1"
  fi

  nmcli -s -g 802-11-wireless-security.psk connection show "$ssid"
}

alias wifis="nmtui connect"
alias wlist="nmcli dev wifi list"
alias wscan="iwlist wlan0 scanning"
alias wknown="iwctl known-networks list || nmcli connection show"
alias woff="nmcli radio wifi off"
alias won="nmcli radio wifi on"
alias rewi="sudo systemctl restart NetworkManager"

alias pmix="pulsemixer"
alias vplay="mplayer -vo fbdev2"
alias cplay="mpv -vo caca"

alias bb="acpi -i"
alias zzz="su -c echo mem > /sys/power/state"
