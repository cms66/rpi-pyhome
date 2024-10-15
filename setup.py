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
#cmdinp = sys.argv[1:]
#cmdscript = "sudo lsblk"
#curl -L https://raw.githubusercontent.com/cms66/rpi-pyhome/main/setup.py | sudo python
# Run commands
print("Python setup") # works
# subprocess.run(command[0], shell = True, executable="/bin/bash")
# print(subprocess.run(["echo", "Geeks for geeks"], capture_output=True)) # works
# subprocess.run(cmdinp[0], shell = True, executable="/bin/bash")
# subprocess.run(cmdscript[0], shell = True, executable="/bin/bash")
# print(subprocess.run(["fdisk", "-l"], capture_output=True)) # not a block device?
# print(subprocess.run(["sudo", "fdisk", "-l"], capture_output=True)) # works
print(subprocess.run(["sudo", "fdisk", "-l"], capture_output=True)) # works
# print(subprocess.run(["sudo", "sh", "test.sh"], shell = True, executable="/bin/bash"))
#print(subprocess.run(["curl", "-L", "https://raw.githubusercontent.com/cms66/rpi-pyhome/main/setup_base.sh", "|", "sudo", "bash"], shell = True, executable="/usr/bin/bash"))
# print(subprocess.run(["sudo", "lsblk", "-l"], shell = True, executable="/bin/bash"))
print("Python setup done") # works
