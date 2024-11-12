# Declare menus

declare -a mnuMainFull=(
"Hardware#show_menu 'Hardware menu' mnuHardwareFull"
"Update setup#git_pull_setup"
"Update system#update_system"
"System summary#show_system_summary"
"Quit#break 2"
)
declare -a mnuHardwareFull=(
"Camera - CSI#setup_camera_csi"
"Camera - USB#setup_camera_usb"
"Back#break 2"
)

