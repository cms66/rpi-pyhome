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

# create/export variables for other scripts
usrname=$(logname)
export usrname
usrpath="/home/$usrname"
export usrpath
pinum=$(hostname | tr -cd '[:digit:].')
export pinum
localnet=$(ip route | awk '/proto/ && !/default/ {print $1}')
export localnet
pimodel=$(cat /sys/firmware/devicetree/base/model)
export pimodel
pirev=$(cat /proc/cpuinfo | grep 'Revision' | awk '{print $3}' | sed 's/^1000//')
export pirev
pimem=$(free -mt)
export pimem
osarch=$(getconf LONG_BIT)
export osarch
repo="rpi-pyhome"
export repo
reposcr=$PWD
export reposcr

show_menu()
{
	printf "Main Menu\n"
	#printf "${$1[@]}\n"
	printf "$1" 
}
# Associative array for menu/actions
declare -A arrSetupMenu
arrSetupMenu+=([System-Summary]="show_system_summary")

# Source setup shell scripts in same directory
for file in $(find $(dirname -- "$0") -type f -name "setup_*.sh" ! -name $(basename "$0"));
do
  source $file;
done

show_menu "Main menu - Bash"
read -rp "Finished setup system: " inp </dev/tty
