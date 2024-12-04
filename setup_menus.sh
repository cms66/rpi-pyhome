# Declare menus - Option 0 used for menu title

declare -a mnuMainFull=(
"Setup - Main menu#"
"Hardware#show_menu mnuHardwareFull"
"NFS#show_menu mnuNFSFull"
"OpenMPI#show_menu mnuOpenMPIFull"
"OpenCV#show_menu mnuOpenCVFull"
"SDM#show_menu mnuSDMFull"
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
"Install - OpenMPI - Local#install_openmpi_local"
"Install - OpenMPI -Server#install_server"
"Install - OpenMPI - Client#install_openmpi_client"
"Install - Munge - Local#install_munge_local"
"Back#break 2"
)
declare -a mnuOpenCVFull=(
"Setup - OpenCV menu#"
"Install - local#install_opencv_local"
"Install - server#install_server"
"Install - client#install_opencv_client"
"Back#break 2"
)
declare -a mnuSDMFull=(
"Setup - SDM menu#init_sdm"
"Install - local#install_sdm_local"
"Install - server#install_server"
"Download latest images#download_latest_os_images"
"Modify image#modify_sdm_image"
"Burn image#burn_sdm_image"
"Edit configuration#edit_sdm_config"
"Show configuration#show_sdm_config"
"Back#break 2"
)
