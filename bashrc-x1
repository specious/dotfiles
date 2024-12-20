#
# Shell configuration that works with a Lenovo Thinkpad X1 Carbon 8th Gen on Linux
#

# Set screen brightness
function light() {
  if [[ $# == 1 ]]; then
    echo $1 > /sys/class/backlight/intel_backlight/brightness
  else
    cat /sys/class/backlight/intel_backlight/brightness
  fi
}

# Keyboard backlight (values: 0, 1, 2)
function kbd () {
  echo $1 > /proc/acpi/ibm/kbdlight
}

# Power led <on|off|blink>
function pled () {
  echo 0 $1 > /proc/acpi/ibm/led
}
