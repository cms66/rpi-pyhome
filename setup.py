# First boot - Base setup
# wget https://raw.githubusercontent.com/cms66/rpi-pyhome/main/setup.py; sudo python ./setup.py
# Assumes
# - rpi imager or SDM used to configure
#    - user/password
#    - hostname

# Imports
import subprocess, sys, os

# Run commands
print("Python setup")
try:
    subprocess.run(["wget", "https://raw.githubusercontent.com/cms66/rpi-pyhome/main/base_setup2.sh"])
    #subprocess.run(["sudo", "bash", "./base_setup.sh"])
    subprocess.run(["sudo", "rm", "-f", "./base_setup.sh"]) # Delete bash script
    usropt=input("Base seup done, press p to poweroff or any other key to reboot: ").lower()
    os.remove(__file__) # Delete python script
    if usropt == 'p':
        print ("Poweroff selected")
        #subprocess.call(["shutdown", "-s", "now"])
    else:
        print ("Reboot selected")
        #subprocess.call(["shutdown", "-r", "now"])
except Exception as e:
    print("The error is: ",e)
