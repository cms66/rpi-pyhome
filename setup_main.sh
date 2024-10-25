# Entry point for bash based management system

# Error handling
set -e
# Error handler
handle_error()
{
	echo "Error: $(caller) : ${BASH_COMMAND}"
}
# Set the error handler to be called when an error occurs
trap handle_error ERR

# Variables
usrname=$(logname)
usrpath="/home/$usrname"
pinum=$(hostname | tr -cd '[:digit:].')
localnet=$(ip route | awk '/proto/ && !/default/ {print $1}')
pimodel=$(cat /sys/firmware/devicetree/base/model)
pirev=$(cat /proc/cpuinfo | grep 'Revision' | awk '{print $3}' | sed 's/^1000//')
pimem=$(free -mt)
osarch=$(getconf LONG_BIT)
repo="rpi-pyhome"
dirscr=$PWD # Directory of calling script

# Source setup shell scripts in same directory
for file in $(find $(dirname -- "$0") -type f -name "setup_*.sh" ! -name $(basename "$0"));
do
  source $file;
done

show_menu "Setup - main menu"
check_package_status nfs-kernel-server y
read -rp "Finished setup system: " inp </dev/tty
