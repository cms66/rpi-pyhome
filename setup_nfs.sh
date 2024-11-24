# NFS setup functions

install_nfs_server()
{
 	check_package_status nfs-kernel-server y
  	if ! [[ $(ufw status | grep 2049) ]] # Add firewall rule
   	then
    		get_subnet_cidr
    		yes | sudo ufw allow from $localnet to any port nfs
       	fi
	read -p "NFS Server setup done, press any key to continue" input
}

# Add local export
add_nfs_local()
{
	get_subnet_cidr
 	# Check server installed
  	if [[ $(check_package_status nfs-kernel-server | grep "not installed") ]]
   	then
    		install_nfs_server
     	fi
   	# Check mount type
    	read -p "System mount (default /usr/local) or Data share? (s/d) " inp
    	if [[ ${inp,} = "s" ]]
    	then # System mount (default /usr/local)
    		defdir="/usr/local"
    		read -p "Path of directory to be shared (press enter for default = $defdir): " userdir
		nfsdir=${userdir:="$defdir"}
		# Check mount exists
		if grep -F "$nfsdir" "/etc/exports"
		then
			read -p "export  exists"
		else
			echo "$nfsdir $localnet(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports
			exportfs -ra
			read -p "export $nfsdir created"
		fi
	elif [[ ${inp,} = "d" ]]
	then # Data mount (default /var/), option to populate with standard content
		defdir="/var"    	
		read -p "Path to directory for mounting share (press enter for default = $defdir): " userdir
		mntdir=${userdir:="$defdir"}
 		# Data share path/name (default /home/username/share name)
   		defname="share$pinum"
   		read -p "Name of share (press enter for default = $defname): " usershare
     		shrname=${usershare:="$defname"}
 		shrdir="$usrpath"
   		read -p "Data share path (press enter for default = $shrdir): " dirshare
     		shrpath=${dirshare:="$shrdir"}
       		read -p "Populate with standard content? (y/n): " addcontent
	 	if [[ ${addcontent,} = "y" ]]
		then # extract nfs-export
			tar -xvzf /home/$usrname/.pisetup/$repo/nfs-export.tgz -C $mntdir
		else
			mkdir $mntdir/nfs-export   			
		fi
  		chown -R $usrname:$usrname $mntdir/nfs-export/
    		mkdir $usrpath/$shrname
      		echo "$mntdir/nfs-export $localnet(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports
		echo "$mntdir/nfs-export $usrpath/$shrname    none	bind	0	0" >> /etc/fstab
		exportfs -ra
		mount -a
 		#read -p "NFS export added, press any key to return to menu" input
    else
    	read -p "invalid input"
    fi
}

# Add remote mount
add_nfs_remote()
{
	read -p "Remote node: " remnode
 	defdir="/var/nfs-export"
	read -p "Full path to remote directory (press enter for default = $defdir): " userdir
 	mntdir=${userdir:="$defdir"}
  	deflocal="$usrpath/share$(echo $remnode | cut -f 2 -d "-")"
  	read -p "Full path to local directory (press enter for default = $deflocal): " shruser
   	shrdir=${shruser:="$deflocal"}
	mkdir $shrdir
	chown $usrname:$usrname $shrdir
	echo "$remnode:$mntdir $shrdir    nfs defaults,user,exec,noauto,x-systemd.automount 0 0" >> /etc/fstab
	mount -a
	read -p "NFS remote mount done, press enter to return to menu" input
}
