# SDM setup functions

init_sdm()
{
	export instdir="/usr/local/sdm" # Default installation directory (target for custom.conf)
	declare -gA arrSDMconf
 	read_sdm_config
}

install_sdm_local()
{
    	# Default setup - install to /usr/local/sdm
     	# TODO - select install location
    	instdir="/usr/local/sdm" # Default installation directory (target for custom.conf)
	curl -L https://raw.githubusercontent.com/gitbls/sdm/master/EZsdmInstaller | bash
  	# Create directories for images
   	defdir="$usrpath/share$pinum/sdm/images"
  	read -rp "Path to image directory (press enter for default = $defdir): " userdir
	$imgdir=${userdir:="$defdir"}
 	read -rp "WiFi country : " wfcountry
 	read -rp "WiFi SSID : " wfssid
  	read -rp "WiFi Password : " wfpwd
  	mkdir -p $imgdir/current
  	mkdir -p $imgdir/latest
   	mkdir -p $imgdir/archive
	chown -R $usrname:$usrname $imgdir
  	# Create custom.conf in installation directory
   	printf "# Custom configuration\n# --------------------\n\
imgdirectory = $imgdir\n\
wificountry = $wfcountry\n\
wifissid = $wfssid\n\
wifipassword = $wfpwd\n\
# End of custom config\n" > $instdir/custom.conf
}

read_sdm_config()
{
	while read line; do
  		[ "${line:0:1}" = "#" ] && continue # Ignore comment lines works
  		key=${line%% *} # Works
		value=${line#* } # TODO
		value=${value#= } # TODO
		arrSDMconf[$key]="$value"
	done < $instdir/custom.conf
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
	wget -P $imgdir/latest $url64lite
 	wget -P $imgdir/latest $url64desk
  	wget -P $imgdir/latest $url32lite
   	wget -P $imgdir/latest $url32desk
	unxz $imgdir/latest/*.xz
	chown $usrname:$usrname $imgdir/latest/*.img
	read -p "Downloads for $verlatest to $imgdir/latest complete, press enter to continue" input
}

modify_sdm_image()
{
	imgdir=${arrSDMconf[imgdirectory]}
  	read -p "Use New (latest) or Current image? (n/c): " inp
   	#dirlist=""
	if [[ ${inp,} = "n" ]]
	then
		# Latest
  		dirlist="$imgdir/latest/"
    		printf "$(ls $dirlist)"
	elif [[ ${inp,} = "c" ]]
	then
		# Current
  		#dirlist="$imgdir/current/"
    		printf "$(ls "$imgdir/current/")"
	else
		printf "invalid option"
	fi
 	#printf "$(ls $dirlist)"
 	#imginp=$imgdir/latest/2024-11-19-raspios-bookworm-arm64-lite.img
  	# imgmod=$imgdir/latest/2024-07-04-raspios-bookworm-arm64.img
  	# Set target filename + copy to current 
   	#imgmod=$imgdir/current/2024-11-19_64lite.img
    	# imgout=$imgdir/current/2024-07-04_64desk.img
	#cp $imginp $imgmod
	# - current
 
  	# Set username/password
	#read -p "Password for $usrname: " usrpass
	#sdm --customize --plugin user:"adduser=$usrname|password=$usrpass" --plugin user:"deluser=pi" --plugin network:"ifname=wlan0|wifissid=${arrSDMconf[wifissid]}|wifipassword=${arrSDMconf[wifipassword]}|wificountry=${arrSDMconf[wificountry]}" --plugin network:"noipv6" --plugin L10n:host --plugin disables:piwiz --extend --expand-root --regen-ssh-host-keys --restart $imgmod
	read -p "Modification finished, press enter to contine"
}

burn_sdm_image()
{
	imgdir=${arrSDMconf[imgdirectory]}
	# Select image
 	imgburn=$imgdir/current/2024-11-19_64lite.img
  	#imgburn=$imgdir/current/2024-07-04_64desk.img
	# Create list for drive selection
 	lsblk | cut -f 1 -d " " | sed "s/[^[:alnum:]]//g" # gives sd* mmcblk* nvme*
  	read -p "Select drive: " inpdrv
 	drvtarget=$inpdrv
  	read -p "Hostname: " inphost
	sdm --burn /dev/$drvtarget --hostname $inphost --expand-root $imgburn
 	read -p "Burn finished, press enter to contine"
}
