# Simple/generic functions

show_menu() # Takes title and array as arguments
{
	clear
	printf "$1\n";printf -- '=%.0s' $(seq 1 ${#1})\n # Print underlined title
	# Print numbered menu options
}

show_system_summary()
{
	clear
	strtitle="System summary - $(hostname)"
	printf "$strtitle\n";printf -- '=%.0s' $(seq 1 ${#strtitle})
	printf "\nRepo: $repo \n"
	printf "\nModel: $pimodel \n"
	printf "Revision: $pirev \n"
	printf "Architecture: $osarch \n"
	printf "Firmware: $(rpi-eeprom-update) \n"
	printf "\nMemory:\n$pimem \n"
	printf "\nStorage:\n$(lsblk) \n"
	printf "\nDrive usage:\n"
 	df -h
	printf "\nFirewall "
	ufw status
	read -p "Press enter to return to menu" input
}

# Pull git updates and return to working directory
git_pull_setup()
{
	cd /home/$usrname/.pisetup/$repo
	git pull https://github.com/cms66/$repo
	cd $OLDPWD
	read -p "Finished setup update, press enter to return to menu" input
}

# Update system
update_system()
{
	# TODO - Check for firmware update if model 4/5
	apt-get -y update
	apt-get -y upgrade
	read -p "Finished System update, press enter to return to menu" input
}

setup_nfs_server()
{
	apt-get -y install nfs-kernel-server
	ufw allow from $localnet to any port nfs
	read -p "NFS Server setup done, press any key to return to menu" input
}
