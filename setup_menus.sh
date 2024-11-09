# Declare menus

declare -A mnuMainActions;                               declare -a mnuMainPrompts;
mnuMainActions["Hardware"]="setup_hardware";             mnuMainPrompts+=("Hardware");
mnuMainActions["NFS"]="setup_nfs";                       mnuMainPrompts+=("NFS");
mnuMainActions["OpenMPI"]="setup_openmpi";               mnuMainPrompts+=("OpenMPI");
mnuMainActions["OpenCV"]="setup_opencv";                 mnuMainPrompts+=("OpenCV");
mnuMainActions["SDM"]="setup_sdm";                       mnuMainPrompts+=("SDM");
mnuMainActions["Update setup"]="git_pull_setup";         mnuMainPrompts+=("Update setup");
mnuMainActions["Update system"]="update_system";         mnuMainPrompts+=("Update system");
mnuMainActions["System summary"]="show_system_summary";  mnuMainPrompts+=("System summary");
mnuMainActions["Quit"]="break 2";                        mnuMainPrompts+=("Quit");

declare -A mnuHardwareActions;      declare -a mnuHardwarePrompts;
mnuHardwareActions["Camera - CSI"]="setup_camera_csi"; mnuHardwarePrompts+=("Camera - CSI");
mnuHardwareActions["Camera - USB"]="setup_camera_usb"; mnuHardwarePrompts+=("Camera - USB");
mnuHardwareActions["Back"]="break 2"; mnuHardwarePrompts+=("Back");
