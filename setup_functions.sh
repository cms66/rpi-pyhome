# Simple/generic functions
show_menu()
# TODO remove number from last option
{
	declare -a arrMenuOptions=()
	declare -a arrMenuActions=()
	arg1=$1[@]
	arrFull=("${!arg1}")	
	for item in "${arrFull[@]}"; do # Populate Prompt/Action arrays from Full array
		arrMenuOptions+=("$(echo $item | cut -f 1 -d '#')")
		arrMenuActions+=("$(echo $item | cut -f 2 -d '#')")
	done
	while true; do # Print menu
		clear
		ind=0
		for opt in "${arrMenuOptions[@]}"; do
			if [[ $ind -eq 0 ]]
			then				
				underline "${arrMenuOptions[0]}" # Print underlined title
			else
				printf "%s\n" "$ind - $opt" # Print numbered menu option
			fi
			((ind=ind+1))
		done
		read -p "Select option: " inp
		# Process input
		if [[ ${#inp} -eq 0 ]]
		then # user pressed enter or space
			read -p "No option selected, press enter to continue"
		else
  			if [[ ${inp,} = "q" ]] || [[ ${inp,} = "b" ]] # Q/q or B/b selected - last menu item
     			then
				break 2
			else
				if [[ "$inp" =~ ^[0-9]+$ ]] && [[ "$inp" -ge 1 ]] && [[ "$inp" -lt ${#arrMenuOptions[@]} ]]
				then # integer in menu range
					${arrMenuActions[$inp]}
				else
					read -p "Invalid option $inp, press enter to continue"
     				fi
			fi
		fi	
	done
}

underline() # Print line with configurable underline character (defaults to "=")
{
	echo $1; for (( i=0; $i<${#1}; i=$i+1)); do printf "${2:-=}"; done; printf "\n";
}

show_system_summary()
{
	clear
	underline "System summary - $(hostname)" # Print underlined title
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
	read -p "Press enter to return to menu"
}

# Pull git updates and return to working directory
git_pull_setup()
{
	cd /home/$usrname/.pisetup/$repo
	git pull https://github.com/cms66/$repo
	cd $OLDPWD
	read -p "Finished setup update, press enter to return to menu"
}

# Update system
update_system()
{
	apt-get -y update
	apt-get -y upgrade
 	update_firmware
	read -p "Finished System update, press enter to return to menu"
}

check_package_status() # Takes package name and install (if needed) as arguments
{
	if [[ "$(dpkg -l | grep $1 | cut --fields 1 -d " ")" == "" ]] # Not installed
	then
		if [[ $2 = "y" ]] # Do install
		then
			apt-get install -y -q $1
   			read -p "$1 install done, press enter to continue"
		else
			read -p "$1 not installed - not installing, press enter to continue"
		fi
	else
		read -p "$1 already installed, press enter to continue"
	fi
}
