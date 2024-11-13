# Declare menus - Break option 0 will show at end of menu

declare -a mnuMainFull=(
"Setup - Main menu#"
"Hardware#show_menu mnuHardwareFull"
"NFS#setup_nfs"
"OpenMPI#setup_openmpi"
"OpenCV#setup_opencv"
"SDM#setup_sdm"
"Update setup#git_pull_setup"
"Update system#update_system"
"System summary#show_system_summary"
"Quit#break 2"
)
declare -a mnuHardwareFull=(
"Setup - Hardware menu#"
"Camera - CSI#setup_camera_csi"
"Camera - USB#setup_camera_usb"
"Sense Hat#setup_sense_hat"
"Back#break 2"
)
declare -a mnuNFSFull=(
"Setup - NFS menu#"
"Install server#install_nfs_server"
"Add local export#add_nfs_local"
"Add remote mount#add_nfs_remote"
"Back#break 2"
)
declare -a mnuOpenMPIFull=(
"Setup - OpenMPI menu#"
"Install - local#install_openmpi_local"
"Install - server#install_server"
"Back#break 2"
)
declare -a mnuOpenCVFull=(
"Setup - OpenCV menu#"
"Install - local#install_opencv_local"
"Install - server#install_server"
"Back#break 2"
)
declare -a mnuSDMFull=(
"Setup - SDM menu#"
"Install - local#install_sdm_local"
"Install - server#install_server"
"Back#break 2"
)
