# SDM setup functions

init_sdm()
{
	declare -gA arrSDMconf
 	export instdir="/usr/local/sdm" # Default installation directory (target for custom.conf)
	if [[ $(command -v sdm) ]]
 	then
 		read_sdm_config  		
	fi
}

install_sdm_local()
{
    	# Default setup - install to /usr/local/sdm
     	# TODO - select install location
    	#instdir="/usr/local/sdm" # Default installation directory (target for custom.conf)
	#curl -L https://raw.githubusercontent.com/gitbls/sdm/master/EZsdmInstaller | bash
  	# Create directories for images
   	defdir="$usrpath/share$pinum/sdm/images"
  	read -rp "Path to image directory (press enter for default = $defdir): " userdir
	imgdir=${userdir:="$defdir"} # TODO
 	#imgdir="/home/multipi/share1/sdm/images"
  	mkdir -p $imgdir/current
  	mkdir -p $imgdir/latest
   	mkdir -p $imgdir/archive
	chown -R $usrname:$usrname $imgdir
  	# Create custom.conf in installation directory
   	read -rp "WiFi country : " wfcountry
 	read -rp "WiFi SSID : " wfssid
  	read -rp "WiFi Password : " wfpwd
   	printf "# Custom configuration\n# --------------------\n\
imgdirectory = $imgdir\n\
wificountry = $wfcountry\n\
wifissid = $wfssid\n\
wifipassword = $wfpwd\n\
# End of custom config\n" > $instdir/custom.conf
}

read_sdm_config()
{
	if [[ ${command -v sdm} ]]
 	then
		while read line; do
	  		[ "${line:0:1}" = "#" ] && continue # Ignore comment lines works
	  		key=${line%% *} # Works
			value=${line#* } # TODO
			value=${value#= } # TODO
			arrSDMconf[$key]="$value"
		done < $instdir/custom.conf
  	fi
}

show_sdm_config()
{
	#read_sdm_config
	printf "SDM Config\n----------\n\
Image directory: ${arrSDMconf[imgdirectory]}\n\
WiFi Country: ${arrSDMconf[wificountry]}\n\
WiFi SSID: ${arrSDMconf[wifissid]}\n\
WiFi Password: ${arrSDMconf[wifipassword]}\n"
read -p "Press enter to contine"
}

edit_sdm_config()
{
	read -p "Function not yet available, press enter to contine"
}

download_latest_os_images()
{
	imgdir=${arrSDMconf[imgdirectory]}
	# Latest images
	verlatest=$(curl -s https://downloads.raspberrypi.org/operating-systems-categories.json | grep "releaseDate" | head -n 1 | cut -d '"' -f 4)
	url64lite=https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-$verlatest/$verlatest-raspios-bookworm-arm64-lite.img.xz
	url64desk=https://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-$verlatest/$verlatest-raspios-bookworm-arm64.img.xz
	url32lite=https://downloads.raspberrypi.com/raspios_lite_armhf/images/raspios_lite_armhf-$verlatest/$verlatest-raspios-bookworm-armhf-lite.img.xz
	url32desk=https://downloads.raspberrypi.com/raspios_armhf/images/raspios_armhf-$verlatest/$verlatest-raspios-bookworm-armhf.img.xz
	# Replace uncustomized latest images
  	rm -rf $imgdir/latest/*.img
	# Download latest images and extract
 	printf "Downloading latest images"
	wget -P $imgdir/latest $url64lite
 	wget -P $imgdir/latest $url64desk
  	wget -P $imgdir/latest $url32lite
   	wget -P $imgdir/latest $url32desk
    	printf "Downloads done, extracting images"
	unxz $imgdir/latest/*.xz
	chown $usrname:$usrname $imgdir/latest/*.img
	read -p "Downloads for $verlatest to $imgdir/latest complete, press enter to continue" input
}

modify_sdm_image()
{
	imgdir=${arrSDMconf[imgdirectory]}
	read -p "Use Latest or Current image? (L/C): " userdir
	if [[ ${userdir,} = "l" ]]
 	then
  		dirlist="latest" # Latest	
	elif [[ ${userdir,} = "c" ]]
 	then
  		dirlist="current" # Current
	else
 		printf "Invalid option"	
	fi	
 	readarray -t arrImg < <(find $imgdir/$dirlist -type f | awk -F "/" '{print $NF}')
  	printf "Images\n-----\n"
	PS3="Select image: "
	COLUMNS=1
	select img in "${arrImg[@]}" "Quit"
	do
  		case $img in
    		*.img)
      			#echo "Image $img selected"
	 		if [[ ${dirlist} = "latest" ]] # Copy to /current for modification
    			then
      				imginp=$imgdir/$dirlist/$img
	  			imgmod=$imgdir/current/$img
      				printf "copying image $imginp to $imgmod\n"
      				curl -o $imgmod FILE://$imginp
      				chown $usrname:$usrname $imgmod
	  			chmod 777 $imgmod
      				read -p "Copy done, press enter to continue"
	  		fi
     			imgmod=$imgdir/current/$img
			# Set username/password
			read -p "Password for $usrname: " usrpass
			read -p "Use WiFi or Ethernet? (w/e): " usrcon
   			if [[ ${usrcon,} = "w" ]]
      			then
	 			printf "WiFi selected" # wifi setup
     				sdm --customize --plugin user:"adduser=$usrname|password=$usrpass" --plugin user:"deluser=pi" --plugin network:"ifname=wlan0|wifissid=${arrSDMconf[wifissid]}|wifipassword=${arrSDMconf[wifipassword]}|wificountry=${arrSDMconf[wificountry]}" --plugin L10n:host --plugin disables:piwiz --extend --expand-root --regen-ssh-host-keys --restart $imgmod
     			elif [[ ${usrcon,} = "e" ]]
			then
   				printf "Ethernet selected" # eth setup
       				sdm --customize --plugin user:"adduser=$usrname|password=$usrpass" --plugin user:"deluser=pi" --plugin L10n:host --plugin disables:piwiz --extend --expand-root --regen-ssh-host-keys --restart $imgmod
       			else
	  			printf "Invalid option"
      				return 1
      			fi
      			;;
    		"Quit")
      			echo "Quit selected"
      			break
      			;;
    		*)
      			echo "Invalid option"
      			;;
  		esac
	done
  	# Set username/password
	#read -p "Password for $usrname: " usrpass
 	#sdm --customize --plugin user:"adduser=$usrname|password=$usrpass" --plugin user:"deluser=pi" --plugin network:"noipv6" --plugin L10n:host --plugin disables:piwiz --extend --expand-root --regen-ssh-host-keys --restart $imgmod
	#sdm --customize --plugin user:"adduser=$usrname|password=$usrpass" --plugin user:"deluser=pi" --plugin network:"ifname=wlan0|wifissid=${arrSDMconf[wifissid]}|wifipassword=${arrSDMconf[wifipassword]}|wificountry=${arrSDMconf[wificountry]}" --plugin network:"noipv6" --plugin L10n:host --plugin disables:piwiz --extend --expand-root --regen-ssh-host-keys --restart $imgmod
	read -p "Modification finished, press enter to continue"
}

burn_sdm_image()
{
	imgdir=${arrSDMconf[imgdirectory]}
	# Select image
 	readarray -t arrImg < <(find $imgdir/current -type f | awk -F "/" '{print $NF}')
  	printf "Images\n-----\n"
	PS3="Select image: "
	COLUMNS=1
	select img in "${arrImg[@]}" "Quit"
	do
  		case $img in
    		*.img)
     			imgburn=$imgdir/current/$img
			printf "Drives\n------\n"
			lsblk | cut -f 1 -d " " | sed "s/[^[:alnum:]]//g" # gives sd* mmcblk* nvme*
   			read -p "Select drive: " inpdrv
      			drvtarget=$inpdrv
	 		read -p "Hostname: " inphost
    			read -p "Burn $imgburn to $inpdrv with hostname $inphost"
    			sdm --burn /dev/$drvtarget --hostname $inphost --expand-root $imgburn
       			read -p "Burn complete"
      			;;
    		"Quit")
      			echo "Quit selected"
      			break
      			;;
    		*)
      			echo "Invalid option"
      			;;
  		esac
	done
 	read -p "Burn finished, press enter to contine"
}
