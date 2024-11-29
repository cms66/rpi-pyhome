# Hardware setup functions

setup_camera_csi()
{
	read -p "Function not yet available, press enter to continue"
}

setup_camera_usb()
{
	read -p "Function not yet available, press enter to continue"
}

setup_sense_hat()
{
	read -p "Function not yet available, press enter to continue"
}

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
