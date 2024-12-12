create_user_ssh_keys()
{
	# Create keys for user
	runuser -l  $usrname -c "ssh-keygen -f ~/.ssh/id_rsa -P \"\"" # Works including creates .ssh directory
	read -p "Server keys generated for $usrname, press enter to return to menu" input
}

modify_sshd()
{
	# Modify SSHD config to use created keys
	sed -i "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/g" /etc/ssh/sshd_config
	echo "HostKey $usrpath/.ssh/id_rsa" >> /etc/ssh/sshd_config
	service sshd restart # Works
	systemctl is-active sshd
	read -p "PubkeyAuthentication enabled, press enter to continue"
}

copy_user_ssh_keys()
{
	read -p "Remote node: " remnode
	read -p "copy to $usrname@$remnode, press enter to continue" # Confirms correct username/hostname
	#runuser -u  $usrname -- "ssh-copy-id $usrname@$remnode"
	#runuser -u  $usrname -- "ssh-copy-id -i $usrpath/.ssh/id_rsa.pub $usrname@$remnode"
	#ssh-copy-id $usrname@$remnode
	#runuser -l $usrname -c "sshpass –f $usrpath/.pisetup/pfile ssh-copy-id $usrname@$remnode"
	sudo -u $usrname -i bash -c 'ssh-copy-id -i /home/multipi/.ssh/id_rsa.pub $usrname@$remnode'
	read -p "Pub key shared with $remnode, press enter to continue"
}
