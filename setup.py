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

# Run commands
print("Python setup")
subprocess.run(["wget", "https://raw.githubusercontent.com/cms66/rpi-pyhome/main/base_setup.sh"])
#subprocess.run(["sudo", "bash", "./base_setup.sh"])
# TODO remove bash script
subprocess.run(["sudo", "rm", "-f", "./base_setup.sh"])
usropt = input ('Base seup done, press p to poweroff or any other key to reboot: ').lower()
if usropt == 'p':
   print('Poweroff')
   subprocess.run(["sudo", "poweroff"])
else:
   print('Reboot')
   subprocess.run(["sudo", "poweroff"])
