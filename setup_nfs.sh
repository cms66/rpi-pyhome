# NFS setup functions

install_nfs_server()
{
 	check_package_status nfs-kernel-server y
  	if ! [[ $(ufw status | grep 2049) ]] # Add firewall rule
   	then
    		#read -p "Firewall rule needed"
    		ufw allow from $localnet to any port nfs
       	fi
	read -p "NFS Server setup done, press any key to return to menu" input
}

# Add local export
add_nfs_local()
{
 	# Check server installed
  	if ! [[ $(check_package_status nfs-kernel-server | grep "not installed") ]]
   	then
    		read -p "NFS server not installed, press any key to return to menu" input
    	fi	
  	# check export exists
   	# Add export
    	read -p "NFS export added, press any key to return to menu" input
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
