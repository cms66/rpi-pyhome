# First boot - Base setup
# curl -L https://raw.githubusercontent.com/cms66/rpi-pyhome/main/setup.py | sudo python
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

# Run commands
print("Python setup")
print(subprocess.run(["echo", "Geeks for geeks"])) # works
#print(subprocess.run(["sudo", "fdisk", "-l"], capture_output=True)) # works
print(subprocess.run(["wget", "https://raw.githubusercontent.com/cms66/rpi-pyhome/main/setup_base.sh"]))
#print(subprocess.run(["chmod", "+x", "./setup_base.sh"]))
print(subprocess.run(["sudo", "./setup_base.sh"], capture_output=True, shell = True, executable="/bin/bash"))
print("Python setup done")
