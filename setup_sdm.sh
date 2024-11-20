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
    #instdir="/usr/local/sdm" # Default installation directory (target for custom.conf)
	#curl -L https://raw.githubusercontent.com/gitbls/sdm/master/EZsdmInstaller | bash
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
${arrSDMconf[imgdirectory]}\n\
${arrSDMconf[wificountry]}\n\
${arrSDMconf[wifissid]}\n\
${arrSDMconf[wifipassword]}\n"
read -p "Press enter to contine" n
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
    read -rp "Downloads for $verlatest to $imgdir/latest complete, press enter to continue" input
}

modify_sdm_image()
{
 	read -p "Function not yet available, press any key to continue"
}

burn_sdm_image()
{
	read -p "Function not yet available, press any key to continue"
}
