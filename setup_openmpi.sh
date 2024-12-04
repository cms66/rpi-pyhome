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
	#groupadd -r -g 991 munge
 	#useradd -r -g munge -u 991 -d /var/lib/munge -s /sbin/nologin munge
  	# Install from Git
   	git clone https://github.com/dun/munge.git
	cd munge
 	./bootstrap
  	./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --runstatedir=/run
   	make
    	make check
	make install
 	# Security
 	chown munge:munge /etc/munge
  	chmod 0700 /etc/munge
 	chown munge:munge /var/lib/munge
  	chmod 0700 /var/lib/munge
 	chown munge:munge /var/log/munge
  	chmod 0700 /var/log/munge
 	chown munge:munge /run/munge
  	chmod 0755 /run/munge
   	# Run munge at startup
   	systemctl enable munge.service
	# Create or copy key
 	sudo -u munge /usr/sbin/mungekey --verbose
 	#cp $usrpath/share1/munge.key /etc/munge/
  	#sudo -u munge /usr/sbin/mungekey --verbose
  	#chown munge:munge /etc/munge/munge.key
	#sudo -u munge /usr/sbin/mungekey --verbose
 	read -p "Munge - Local install done, press enter to return to menu" input
}
