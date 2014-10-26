#!/bin/bash
#============#
#This is the cheat sheet for the OSM Extracts Guide.
#This cheat sheet is designed to streamline installation without including explanation of each step.
#Use the full guide found at https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-osmextracts-1.0.md
#if you wish to walk through the installation.
#============#
#Important!  This is not designed as a single bash script.  You'll still need to execute lines one by one.
#============#
#Step 1
apt-get update
apt-get install -y curl vim git unzip
apt-get install -y postgresql-client-common postgresql-client-9.1
apt-get install -y libgeos-dev libproj-dev
cd /opt
git clone https://github.com/state-hiu/cybergis-scripts.git cybergis-scripts.git
cp cybergis-scripts.git/profile/cybergis-scripts.sh /etc/profile.d/

#Step 2
cybergis-script-env.sh geogig install

#Step 3
cybergis-script-env.sh client install
