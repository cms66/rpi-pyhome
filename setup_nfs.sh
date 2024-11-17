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
		defdir="/var/"    	
		read -p "Path to directory for mounting share (press enter for default = $defdir): " userdir
		mntdir=${userdir:="$defdir"}
 		# Data share path/name (default /home/username/share name)
 		shrdir="$usrpath"
 		read -p "Data share path (default /home/username/)"
 		read -p "Data share name (default /home/username/share name)"
 		#read -p "NFS export added, press any key to return to menu" input
    else
    	read -p "invalid input"
    fi
}

# Add remote mount
add_nfs_remote()
{
	read -p "Remote node (integer only): " nfsrem
	read -p "Full path to remote directory (press enter for default = /var/nfs-export): " userdir
	nfsdir=${userdir:="/var/nfs-export"}
	mkdir $usrpath/share$nfsrem
	chown $usrname:$usrname $usrpath/share$nfsrem
	echo "pinode-$nfsrem.local:$nfsdir $usrpath/share$nfsrem    nfs defaults,user,exec,noauto,x-systemd.automount 0 0" >> /etc/fstab
	mount -a
	read -p "NFS remote mount done, press enter to return to menu" input
}
