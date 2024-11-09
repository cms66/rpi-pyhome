# Declare menus

declare -A mnuMainActions;      declare -a mnuMainPrompts;
mnuMainActions["Hardware"]="setup_hardware"; mnuMainPrompts+=("Hardware");
mnuMainActions["Opt 2"]="Act 2"; mnuMainPrompts+=("Opt 2");
mnuMainActions["Opt 3"]="Act 3"; mnuMainPrompts+=("Opt 3");
mnuMainActions["Opt 4"]="Act 4"; mnuMainPrompts+=("Opt 4");
mnuMainActions["Opt 5"]="Act 5"; mnuMainPrompts+=("Opt 5");
mnuMainActions["Opt 6"]="Act 6"; mnuMainPrompts+=("Opt 6");
mnuMainActions["Quit"]="break 2"; mnuMainPrompts+=("Quit");

declare -A mnuHardwareActions;      declare -a mnuHardwarePrompts;
mnuHardwareActions["Camera"]="setup_camera"; mnuHardwarePrompts+=("Camera");
mnuHardwareActions["Opt 2"]="Act 2"; mnuHardwarePrompts+=("Opt 2");
mnuHardwareActions["Opt 3"]="Act 3"; mnuHardwarePrompts+=("Opt 3");
mnuHardwareActions["Opt 4"]="Act 4"; mnuHardwarePrompts+=("Opt 4");
mnuHardwareActions["Opt 5"]="Act 5"; mnuHardwarePrompts+=("Opt 5");
mnuHardwareActions["Back"]="break 2"; mnuHardwarePrompts+=("Back");
