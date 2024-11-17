# SDM setup functions

install_sdm_local()
{
    # Default setup - install to /usr/local/sdm
    	instdir="/usr/local/sdm" # Default installation directory (target for custom.conf)
	curl -L https://raw.githubusercontent.com/gitbls/sdm/master/EZsdmInstaller | bash
  	# Create directories for images
   	# Assumes
    	# - NFS share already created
     	# - 
    
  	read -rp "Path to image directory (press enter for default = $usrpath/share$pinum/sdm/images/): " userdir </dev/tty
	$imgdir=${userdir:="$usrpath/share$pinum/sdm/images/"}
 	read -rp "WiFi country : " wfcountry </dev/tty
 	read -rp "WiFi SSID : " wfssid </dev/tty
  	read -rp "WiFi Password : " wfpwd </dev/tty
  	mkdir -p $imgdir/current
  	mkdir -p $imgdir/latest
   	mkdir -p $imgdir/archive
    	chown -R $usrname:$usrname $imgdir
 	#download_latest_images
  	# Create custom.conf in installation directory
   	printf "# Custom configuration\n# --------------------\n\
imgdirectory = $imgdir\n\
wificountry = $wfcountry\n\
wifissid = $wfssid\n\
wifipassword = $wfpwd\n\
# End of custom config\n" > $instdir/custom.conf
}

read_config()
{
	while read line; do
  		[ "${line:0:1}" = "#" ] && continue # Ignore comment lines works
  		key=${line%% *} # Works
		value=${line#* } # TODO
		value=${value#= } # TODO
		arrconf[$key]="$value"
	done < /usr/local/sdm/custom.conf
}
