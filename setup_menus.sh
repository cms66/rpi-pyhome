# Declare menus - Brake option 0 will show at end of menu
#declare -a arrMenuPrompts # Empty array for menu prompts
#declare -a arrMenuActions # Empty array for menu actions
declare -a mnuMainFull=(
"Quit#break 2"
"Hardware#setup_hardware"
"Update setup#git_pull_setup"
"Update system#update_system"
"System summary#show_system_summary"
)
declare -a mnuHardwareFull=(
"Back#break 2"
"Camera - CSI#setup_camera_csi"
"Camera - USB#setup_camera_usb"
"Sense Hat#setup_sense_hat"
)
declare -a mnuNFSFull=(
"Back#break 2"
"Install server#install_nfs_server"
"Add local export#add_nfs_local"
"Add remote mount#add_nfs_remote"
)
