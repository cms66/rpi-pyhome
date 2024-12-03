# OpenMPI setup functions

# From version 5 32 bit OS is not supported
# Latest versions
url32=https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.7.tar.gz
url64=https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.6.tar.gz
ver32="4.1.7"
ver64="5.0.6"
if [[ "$(uname -m | grep '64')" != "" ]]
then
	downlink=$url64
 	instver=$ver64
else
	downlink=$url32
	instver=$ver32
fi

install_openmpi_local()
{
	cd $usrpath
	#wget $downlink
	#tar -xzf openmpi*.tar.gz
	#cd openmpi-$instver
	#./configure
	#cores=$(nproc)
	#make -j$cores all
	#make install	
	#ldconfig	
	#cd $usrpath
	#rm -rf openmpi*
	#mpirun --version
	read -p "$osarch bit OpenMPI $instver - Local install finished, press enter to return to menu" input
}
