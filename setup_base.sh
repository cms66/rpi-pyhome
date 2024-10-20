# First boot - Base setup
# Assumes
# - rpi imager or sdm used to configure user/hostname/network
# sudo run this script as created user

set -e

# Error handler
handle_error()
{
	echo "Error: $(caller) : ${BASH_COMMAND}"
}

# Set the error handler to be called when an error occurs
trap handle_error ERR

# Set default shell to bash
dpkg-divert --remove --no-rename /usr/share/man/man1/sh.1.gz
dpkg-divert --remove --no-rename /bin/sh
ln -sf bash.1.gz /usr/share/man/man1/sh.1.gz
ln -sf bash /bin/sh
dpkg-divert --add --local --no-rename /usr/share/man/man1/sh.1.gz
dpkg-divert --add --local --no-rename /bin/sh

# Variables
usrname=$(logname) # Script runs as root
piname=$(hostname)
localnet=$(ip route | awk '/proto/ && !/default/ {print $1}')
repo="rpi-nvme"
repobranch="main"
pimodelnum=$(cat /sys/firmware/devicetree/base/model | cut -d " " -f 3)

read -rp "Finished base setup press p to poweroff or any other key to reboot: " inp </dev/tty

if [ X$inp = X"p" ]
then
	echo "poweroff selected"
else
	echo "reboot selected"
fi
