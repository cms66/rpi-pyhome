# Simple/generic functions

show_system_summary()
{
	clear
	strtitle="System summary - $(hostname)"
	printf $strtitle;printf -- '=%.0s' $(seq 1 ${#strtitle})
	printf "\nRepo: $repo \n"
	printf "\nScript run from: $dirscr \n"
	printf "\nModel: $pimodel \n"
	printf "Revision: $pirev \n"
	printf "Architecture: $osarch \n"
	printf "Firmware: $(rpi-eeprom-update) \n"
	printf "\nMemory:\n$pimem \n"
	printf "\nStorage:\n$(lsblk) \n"
 	printf "\nDrive usage:\n$(df) \n"
	printf "Firewall "
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

# Update sytem
update_system()
{
	# TODO - Check for firmware update if model 4/5
	apt-get -y update
	apt-get -y upgrade
	read -p "Finished System update, press enter to return to menu" input
}


