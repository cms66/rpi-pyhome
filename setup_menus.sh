# Declare menus

declare -A mnuMainActions;  declare -a mnuMainPrompts;
mnuMainActions["Hardware"]="setup_hardware"; mnuMainPrompts+=("Hardware");
mnuMainActions["Quit"]="break 2"; mnuMainPrompts+=("Quit");

declare -A mnuHardwareActions;      declare -a mnuHardwarePrompts;
mnuHardwareActions["Camera - CSI"]="setup_camera_csi"; mnuHardwarePrompts+=("Camera - CSI");
mnuHardwareActions["Camera - USB"]="setup_camera_usb"; mnuHardwarePrompts+=("Camera - USB");
mnuHardwareActions["Back"]="break 2"; mnuHardwarePrompts+=("Back");
