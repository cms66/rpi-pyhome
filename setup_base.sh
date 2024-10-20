# First boot - Base setup
# Assumes
# - rpi imager or sdm used to configure user/hostname/network
# sudo run this script as created user

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
usrname=$(logname) # Script runs as root
piname=$(hostname)
localnet=$(ip route | awk '/proto/ && !/default/ {print $1}')
repo="rpi-pyhome"
repobranch="main"
pimodelnum=$(cat /sys/firmware/devicetree/base/model | cut -d " " -f 3)

# Functions
# Set default shell to bash
set_default_shell()
{
	dpkg-divert --remove --no-rename /usr/share/man/man1/sh.1.gz
	dpkg-divert --remove --no-rename /bin/sh
	ln -sf bash.1.gz /usr/share/man/man1/sh.1.gz
	ln -sf bash /bin/sh
	dpkg-divert --add --local --no-rename /usr/share/man/man1/sh.1.gz
	dpkg-divert --add --local --no-rename /bin/sh
}

# Install/update software
update_system()
{
	apt-get -y update
	apt-get -y upgrade
	apt-get -y install python3-dev gcc g++ gfortran libraspberrypi-dev libomp-dev git-core build-essential cmake pkg-config make screen htop stress zip nfs-common fail2ban ufw ntpdate
}

# Git setup
setup_git()
{
	mkdir /home/$usrname/.pisetup
	cd /home/$usrname/.pisetup
	git clone https://github.com/cms66/$repo.git
	printf "# Setup - Custom configuration\n# --------------------\n\
	repo = $repo\n\
	repobranch = $repobranch\n" > /home/$usrname/.pisetup/custom.conf
	chown -R $usrname:$usrname /home/$usrname/.pisetup
}

# Configure fail2ban
setup_fail2ban()
{
	cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
	cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
}

# Disable root SSH login
disable_root_ssh()
{
	sed -i 's/#PermitRootLogin\ prohibit-password/PermitRootLogin\ no/g' /etc/ssh/sshd_config
}

# Networking
setup_network()
{
	echo "127.0.0.1   $piname.local $piname" >> /etc/hosts
	localip=$(hostname -I | awk '{print $1}')
	echo "$localip   $piname.local $piname" >> /etc/hosts
	sed -i "s/rootwait/rootwait ipv6.disable=1/g" /boot/firmware/cmdline.txt
}

# Configure firewall (ufw)
setup_firewall()
{
	# Allow SSH from local subnet only, unless remote access needed
	read -rp "Allow remote ssh acces (y/n): " inp </dev/tty
	if [ X$inp = X"y" ] # TODO - not case insensitive
	then # Remote
 		yes | sudo ufw allow ssh
	else # Local
		yes | sudo ufw allow from $localnet to any port ssh
	fi
	yes | sudo ufw logging on
	yes | sudo ufw enable
}

# Run setup
set_default_shell
update_system
setup_fail2ban
disable_root_ssh
setup_network
setup_git
# setup_firewall # TODO

read -rp "Finished base setup press p to poweroff or any other key to reboot: " inp </dev/tty
if [ X$inp = X"p" ]
then
	echo "poweroff selected"
else
	echo "reboot selected"
fi
