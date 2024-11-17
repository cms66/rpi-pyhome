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
repo="rpi-pyhome"
repobranch="main"
pimodelnum=$(cat /sys/firmware/devicetree/base/model | cut -d " " -f 3)

# Functions
# ---------
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
	# Add bash alias for setup and test menu
	echo "alias mysetup=\"sudo bash ~/.pisetup/$repo/setup_main.sh\"" >> /home/$usrname/.bashrc
	echo "alias mytest=\"sudo bash ~/.pisetup/$repo/test_main.sh\"" >> /home/$usrname/.bashrc
	echo "alias pysetup=\"sudo python ~/.pisetup/$repo/setup_main.py\"" >> /home/$usrname/.bashrc 	
	echo "alias pytest=\"sudo python ~/.pisetup/$repo/test_main.py\"" >> /home/$usrname/.bashrc
}

# - Create python Virtual Environment (with access to system level packages) and bash alias for activation
create_venv()
{
	python -m venv --system-site-packages /home/$usrname/.venv
	echo "alias myvp=\"source ~/.venv/bin/activate\"" >> /home/$usrname/.bashrc
	echo "alias dvp=\"deactivate\"" >> /home/$usrname/.bashrc
	chown -R $usrname:$usrname /home/$usrname/.venv
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

# create local folder structure for created user with code examples
create_local()
{
	tar -xvzf /home/$usrname/.pisetup/$repo/local.tgz -C /home/$usrname
	chown -R $usrname:$usrname /home/$usrname/local/
}

# Networking
setup_network()
{
	#echo "127.0.0.1   $piname.local $piname" >> /etc/hosts
	#localip=$(hostname -I | awk '{print $1}')
	#echo "$localip   $piname.local $piname" >> /etc/hosts
	#sed -i "s/rootwait/rootwait ipv6.disable=1/g" /boot/firmware/cmdline.txt
 	echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
  	sysctl --system
   	read -p "ipv6 disabled"
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

# Update firmware - Only applies to model 4/5
update_firmware()
{
	if [ $pimodelnum = "4" ] || [ $pimodelnum = "5" ]; then # Model has firmware
		printf "Model has firmware\n"
		updfirm=$(sudo rpi-eeprom-update | grep BOOTLOADER | cut -d ":" -f 2 | tr -d '[:blank:]') # Check for updates
		printf "Update status: $updfirm\n"
 		if ! [ $updfirm = "uptodate" ]; then # Update available - TODO - test when updates are available
 			printf "Update available\n"
  			read -p "Firmware update available, press y to update now or any other key to continue: " input </dev/tty
  			printf "Update selected\n"
    			if [ X$input = X"y" ]; then # Apply firmware update
    				printf "Update firmware\n"
				rpi-eeprom-update -a
   			fi
    	 	else
     			printf "Firmware is up to date\n"
     		fi
	else
		printf "No firmware\n"
	fi
}

get_subnet_cidr()
{
	wifi=$(tail -n+3 /proc/net/wireless | grep -q . && echo "yes") # works
	wired=$(ethtool eth0 | grep "Link\ detected" | cut -f 2 -d ":" | tr -d '[:blank:]') # works
 	dev="eth0" # default device
 	if [[ $wifi = "yes" ]] && [[ $wired = "yes" ]]
	then
		read -p "Use ethernet or wifi for setup? (e/w): " inp
		if [[ ${inp,} = "e" ]]
		then
			dev="eth0"
		elif [[ ${inp,} = "w" ]]
		then
			dev="wlan0"
		else
			printf "invalid option"
		fi
	fi
 	export localnet=$(nmcli -t device show $dev | grep "ROUTE\[1\]" | cut -f 2 -d "=" | tr -d '[:blank:]' | sed "s/,nh//")
  	#export x=1; echo "$x"; command
	echo "$localnet"
}

# Run setup
# ---------
set_default_shell
update_system
setup_fail2ban
disable_root_ssh
setup_git
create_local
create_venv
setup_network
get_subnet_cidr
setup_firewall
update_firmware

read -rp "Finished base setup press p to poweroff or any other key to reboot: " inp </dev/tty
if [ X$inp = X"p" ]
then
	poweroff
else
	reboot
fi
