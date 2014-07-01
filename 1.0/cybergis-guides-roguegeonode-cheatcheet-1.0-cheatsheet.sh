#!/bin/bash
##This is a cheat sheet for the ROGUE GeoNode Guide.

#Step 1
sudo su -
apt-get update
apt-get install -y curl vim git
cd /opt
git clone https://github.com/state-hiu/cybergis-scripts.git cybergis-scripts.git
cp cybergis-scripts.git/profile/cybergis-scripts.sh /etc/profile.d/
exit

#Step 2
sudo su -
cybergis-script-init-rogue.sh prod user

#Step 3
cybergis-script-init-rogue.sh prod rvm
reboot

#Step 4
sudo su -
cybergis-script-init-rogue.sh prod gems

#Step 5
#Initialize Database

#Step 6
sudo su -
cybergis-script-init-rogue.sh prod geonode <fqdn>
