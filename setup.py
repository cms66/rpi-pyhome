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
# print(subprocess.run(["wget", "https://raw.githubusercontent.com/cms66/rpi-pyhome/main/setup_base.sh"]))
subprocess.run(["wget", "https://raw.githubusercontent.com/cms66/rpi-pyhome/main/setup_base.sh"])
print(subprocess.call(["sudo", "bash", "./setup_base.sh"]))
print("Python setup done")
