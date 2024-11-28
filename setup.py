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
import subprocess, sys, os

# Run commands
print("Python setup")
subprocess.run(["wget", "https://raw.githubusercontent.com/cms66/rpi-pyhome/main/base_setup.sh"])
#subprocess.run(["sudo", "bash", "./base_setup.sh"])
subprocess.run(["sudo", "rm", "-f", "./base_setup.sh"])
usropt=input("Base seup done, press p to poweroff or any other key to reboot: ").lower()
os.remove(__file__)
if usropt == 'p':
    print ("Poweroff selected")
    subprocess.call(["shutdown", "-s", "now"])
else:
    print ("Reboot selected")
    subprocess.call(["shutdown", "-r", "now"])

