# First boot - Base setup
# Assumes
# - rpi imager used to configure
#    - user/password
#    - hostname
#    - WiFi
# TODO
# - Check for first run/delete on success

# Imports
import subprocess, sys

# Variables
cmdinp = sys.argv[1:]
cmdscript = "sudo lsblk"

# Run command
# subprocess.run(command[0], shell = True, executable="/bin/bash")
sudo print("Python setup") # works
# print(subprocess.run(["echo", "Geeks for geeks"], capture_output=True)) # works
# subprocess.run(cmdinp[0], shell = True, executable="/bin/bash")
# subprocess.run(cmdscript[0], shell = True, executable="/bin/bash")
# sudo print(subprocess.run(["lsblk"], capture_output=True)) # works
print("Python setup done") # works
