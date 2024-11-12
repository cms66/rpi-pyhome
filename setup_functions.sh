# Simple/generic functions

show_menu()
{
	arg2=$2[@]
	arrFull=("${!arg2}")
 	arrMenuPrompts=()
  	arrMenuActions=()
	for i in "${arrFull[@]}" # Populate Prompt/Action arrays from Full array
	do
		arrMenuPrompts+=("$(echo $i | cut -f 1 -d '#')")
		arrMenuActions+=("$(echo $i | cut -f 2 -d '#')")
	done
	while true
	do
		# show menu - title from arg 1
		clear
		printf "$1\n";printf -- '=%.0s' $(seq 1 ${#1});printf "\n" # Print underlined title
  		i=0 # index 0 will be shown at end of menu
		for opt in "${arrMenuPrompts[@]}"
		do
			if [[ $i -gt 0 ]]
			then
				printf "%s\n" "$i - $opt" #= ${arrMenuActions[$i]}"
			fi
			((i=i+1))
		done
		printf "%s\n" "${#arrMenuPrompts[@]} - ${arrMenuPrompts[0]}" #= ${arrMenuActions[0]}"
		# Get user input
		read -p "Select option: " inp
		# Process input
		if [[ ${#inp} -eq 0 ]]
		then # user pressed enter
			read -p "No option selected, press enter to continue"
		else
			if [[ "$inp" =~ ^[0-9]+$ ]] && [[ "$inp" -ge 1 ]] && [[ "$inp" -le ${#arrMenuPrompts[@]} ]]
			then # integer in menu range
				if [[ "$inp" -lt ${#arrMenuPrompts[@]} ]] # input 1 to array length -1
				then
					${arrMenuActions[$inp]}
     					read -p "Done - ${arrMenuPrompts[$inp]}"
				else # last menu item = Break
					${arrMenuActions[0]}
				fi
			else
				read -p "Invalid option $inp, press enter to continue"
			fi
		fi
	done	
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
	#read -p "Press enter to return to menu" input
}

# Pull git updates and return to working directory
git_pull_setup()
{
	cd /home/$usrname/.pisetup/$repo
	git pull https://github.com/cms66/$repo
	cd $OLDPWD
	#read -p "Finished setup update, press enter to return to menu" input
}

# Update system
update_system()
{
	# TODO - Check for firmware update if model 4/5
	apt-get -y update
	apt-get -y upgrade
 	update_firmware
	#read -p "Finished System update, press enter to return to menu" input
}

setup_nfs_server()
{
	#apt-get -y install nfs-kernel-server
	#ufw allow from $localnet to any port nfs
 	check_package_status nfs-kernel-server y
	#read -p "NFS Server setup done, press any key to return to menu" input
}

check_package_status() # Takes package name and install (if needed) as arguments
{
	if [[ "$(dpkg -l | grep $1 | cut --fields 1 -d " ")" == "" ]] # Not installed
	then
		if [[ $2 == "y" ]] # Do install
		then
			#printf "$(apt-get install y $1\n"
			printf "installing $1\n"
			apt-get install -y -q $1
		else
			printf "$1 not installed - not installing"
		fi
	else
		printf "$1 already installed\n"
	fi
}
