# NFS setup functions

install_nfs_server()
{
	#apt-get -y install nfs-kernel-server
	#ufw allow from $localnet to any port nfs
 	check_package_status nfs-kernel-server y
	#read -p "NFS Server setup done, press any key to return to menu" input
}
