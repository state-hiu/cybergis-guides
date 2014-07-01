#!/bin/bash
#============#
#This is the cheat sheet for the Vanilla GeoNode Guide.
#This cheat sheet is designed to streamline installation without including explanation of each step.
#Use the full guide found at https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-vanillageonode-1.0.md
#if you wish to walk through the installation.
#============#
#Important!  This is not designed as a single bash script.  You'll still need to execute lines one by one.
#============#

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
add-apt-repository ppa:geonode/release
apt-get update

#Step 3
apt-get install geonode

#Step 4
geonode createsuperuser

#Step 5
geonode-updateip <ip/domain>
