#!/bin/bash
#============#
#This is the cheat sheet for the OpenGeo Suite Guide.
#This cheat sheet is designed to streamline installation without including explanation of each step.
#Use the full guide found at https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-opengeosuite-1.0.md
#if you wish to walk through the installation.
#============#
#Important!  This is not designed as a single bash script.  You'll still need to execute lines one by one.
#============#
#Step 1
apt-get update
apt-get install -y curl vim git
cd /opt
git clone https://github.com/state-hiu/cybergis-scripts.git cybergis-scripts.git
cp cybergis-scripts.git/profile/cybergis-scripts.sh /etc/profile.d/

#Step 2
wget -qO - http://apt.opengeo.org/gpg.key | apt-key add -
echo "deb http://apt.opengeo.org/suite/v4/ubuntu/ precise main" > /etc/apt/sources.list.d/opengeo.list
apt-get update

#Step 3
apt-get install opengeo

#Step 4

#Step 5
cybergis-script-geoserver.sh prod tune <repo> <Xmx>
#For example:
#cybergis-script-geoserver.sh prod tune '/cybergis/misc/git/repo/etc_defaults' 12G
cybergis-script-ec2.sh prod swap 64g /mnt/swap_64g.swap
