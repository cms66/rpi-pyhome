# The rpi-pyhome project
A Python based setup/management system for a home network of Raspberry Pi's with multiple sensors/cameras running as a cluster.

# Quick setup
## First RPi
 - Create with Raspberry Pi Imager, setting
   - Username
   - Password
   - Hostname
   - WiFi (if available, even if using wired connection)
 - Boot with SD card created with Raspberry Pi Imager

### First boot
- Login as created user and run 
```
wget https://raw.githubusercontent.com/cms66/rpi-pyhome/main/setup.py; sudo python ./setup.py
```
