# OpenMPI setup functions

install_openmpi_local()
{
	# From version 5 32 bit OS is not supported
	# Latest versions
	url32=https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.7.tar.gz
	url64=https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.6.tar.gz
	ver32="4.1.7"
	ver64="5.0.6"
	if [ $osarch = "64" ]
	then
		downlink=$url64
	 	instver=$ver64
	else
		downlink=$url32
		instver=$ver32
	fi
	cd $usrpath
	wget $downlink
	tar -xzf openmpi*.tar.gz
	cd openmpi-$instver
	./configure
	cores=$(nproc)
	make -j$cores all
	make install	
	ldconfig	
	cd $usrpath
	rm -rf openmpi*
	mpirun --version
	read -p "OpenMPI $instver - Local install finished, press enter to return to menu" input
}

install_openmpi_client()
{
	# TODO check server system folder (default /usr/local) is mounted
 	ldconfig
  	read -p "OpenMPI $instver - Client install finished, press enter to return to menu" input
}

install_munge_local()
{
	# Create System group and user
	# Check uid/guid/user available
	defid=991
	getent passwd $defid && mnguid=$? # 0 = uid exists
	getent group $defid && mnggid=$? # 0 = guid exists
	getent passwd munge && mngusr=$? # 0 = uid exists
	if [[ $mnguid ]] || [[ $mnggid ]] || [[ $mngusr ]]; then # uid/guid/user exists
		#printf "$mngusr\n$mnguid\n$mnggid\n"
		read -p "UID, GUID or user exists"
		#kill -INT $$ # Exit function
  		return
	else
		#read -p "UID and GUID available"
		groupadd -r -g $defid munge
		useradd -r -g munge -u $defid -d /var/lib/munge -s /sbin/nologin munge
		apt-get -y install libmunge-dev munge
	fi
    read -p "Munge install done"
}
