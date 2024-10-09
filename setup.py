# First boot - Base setup
# Assumes
# - rpi imager or sdm used to configure user/hostname
# TODO

# Imports
import subprocess, sys

# Set command to run
command = sys.argv[1:]

# Run command
subprocess.run(command[0], shell = True, executable="/bin/bash")
