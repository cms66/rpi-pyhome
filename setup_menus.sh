# Declare menus - Brak option 0 will show at end of menu

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
)

