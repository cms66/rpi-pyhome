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
cmdscript = ""

# Run command
#subprocess.run(command[0], shell = True, executable="/bin/bash")
print("Python setup")
#print(subprocess.run(["echo", "Geeks for geeks"], capture_output=True))
#print(subprocess.run(["sudo lsblk"], capture_output=True

