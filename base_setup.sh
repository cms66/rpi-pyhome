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
	printf "%s\n" "Updating system"
	apt-get -y update
	apt-get -y upgrade
	apt-get -y install python3-dev gcc g++ gfortran libraspberrypi-dev libomp-dev git-core build-essential cmake pkg-config make screen htop stress zip nfs-common fail2ban ufw ntpdate bzip2 pkgconf openssl
 	# TODO check SDM removal works on 32 bit
  	rm -rf /usr/local/sdm
 	rm -rf /usr/local/bin/sdm
  	rm -rf /etc/sdm
}

# Git setup
setup_git()
{
	printf "%s\n" "Setting up Git"
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
	printf "%s\n" "Creating python Virtual Environment"
	python -m venv --system-site-packages /home/$usrname/.venv
	echo "alias myvp=\"source ~/.venv/bin/activate\"" >> /home/$usrname/.bashrc
	echo "alias dvp=\"deactivate\"" >> /home/$usrname/.bashrc
	chown -R $usrname:$usrname /home/$usrname/.venv
}

# Configure fail2ban
setup_fail2ban()
{
	printf "%s\n" "Configuring fail2ban"
	cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
	cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
 	# Setup ssh rules
	strssh="filter	= sshd\n\
banaction = iptables-multiport\n\
bantime = -1\n\
maxretry = 3\n\
findtime = 24h\n\
backend = systemd\n\
journalmatch = _SYSTEMD_UNIT=ssh.service + _COMM=sshd\n\
enabled = true\n"
	sed -i "s/backend = %(sshd_backend)s/$strssh/g" /etc/fail2ban/jail.local
}

# Disable root SSH login
disable_root_ssh()
{
	sed -i 's/#PermitRootLogin\ prohibit-password/PermitRootLogin\ no/g' /etc/ssh/sshd_config
}

# create local folder structure for created user with code examples
create_local()
{
	printf "%s\n" "Creating local"
	tar -xvzf /home/$usrname/.pisetup/$repo/local.tgz -C /home/$usrname
	chown -R $usrname:$usrname /home/$usrname/local/
}

# Networking
setup_network()
{
	printf "%s\n" "Configuring network"
 	sed -i "s/#FallbackNTP/FallbackNTP/g" /etc/systemd/timesyncd.conf # Setup NTP
	echo "127.0.1.1   $piname" >> /etc/hosts
	localip=$(hostname -I | awk '{print $1}')
	echo "$localip  $piname $piname.local" >> /etc/hosts # TODO - Setup for eth or wifi
 	sed -i "s/regdom=US/regdom=GB/g" /boot/firmware/cmdline.txt
 	# Enforce NFSv4
	sed -i "s/NEED_STATD=/NEED_STATD=\"no\"/g" /etc/default/nfs-common
	sed -i "s/NEED_IDMAPD=/NEED_IDMAPD=\"yes\"/g" /etc/default/nfs-common
}

# Configure firewall (ufw)
setup_firewall()
{
	printf "%s\n" "Configuring firewall"
	# Allow SSH from local subnet only, unless remote access needed
	read -rp "Allow remote ssh acces (y/n): " inp </dev/tty
	if [ X$inp = X"y" ] # TODO - not case insensitive
	then # Remote
 		yes | sudo ufw allow ssh
	else # Local
		yes | sudo ufw allow from $localnet to any port ssh
	fi
	sudo ufw logging on
	yes | sudo ufw enable
}

# Update firmware - Only applies to model 4/5 TODO
update_firmware()
{
	if [[ $pimodelnum = "4" ]] || [ $pimodelnum = "5" ]; then # Model has firmware
		printf "Model has firmware\n"
		updfirm=$(sudo rpi-eeprom-update | grep BOOTLOADER | cut -d ":" -f 2 | tr -d '[:blank:]') # Check for updates
		printf "Update status: $updfirm\n"
 		if ! [ $updfirm = "uptodate" ]; then # Update available - TODO - test when updates are available
 			printf "Update available\n"
 			rpi-eeprom-update -a
    	 else
     		printf "Firmware is up to date\n"
     	fi
	else
		printf "No firmware\n"
	fi
}

get_subnet_cidr()
{
	wired="$(nmcli -t connection show --active | grep ethernet | cut -f 4 -d ":")"
	wifi="$(nmcli -t connection show --active | grep wireless | cut -f 4 -d ":")"
 	if [[ $wifi ]] && [[ $wired ]] # Multiple connections
	then
		read -p "Use ethernet or wifi for setup? (e/w): " inp
		if [[ ${inp,} = "e" ]]
		then
			dev=$wired
		elif [[ ${inp,} = "w" ]]
		then
			dev=$wifi
		else
			printf "invalid option"
		fi
	else # Single connection
		dev="$wifi$wired" 
	fi
 	export localnet=$(nmcli -t device show $dev | grep "ROUTE\[1\]" | cut -f 2 -d "=" | tr -d '[:blank:]' | sed "s/,nh//")
	printf "Device = $dev | localnet = $localnet\n"
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

