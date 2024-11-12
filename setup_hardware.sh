# Hardware setup functions

setup_hardware()
{
	show_menu "Setup - Hardware menu" mnuHardwareFull
}

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
