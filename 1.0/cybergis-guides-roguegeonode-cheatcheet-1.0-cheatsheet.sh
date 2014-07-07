#!/bin/bash
#============#
#This is the cheat sheet for the ROGUE GeoNode Guide.
#This cheat sheet is designed to streamline installation without including explanation of each step.
#Use the full guide found at https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-roguegeonode-1.0.md
#if you wish to walk through the installation.
#============#
#Important!  This is not designed as a single bash script.  You'll still need to execute lines one by one.
#============#
#Step 1
#Provision (virtual) machine

#Step 2
sudo su -
apt-get update
apt-get install -y curl vim git
cd /opt
git clone https://github.com/state-hiu/cybergis-scripts.git cybergis-scripts.git
cp cybergis-scripts.git/profile/cybergis-scripts.sh /etc/profile.d/
exit

#Step 3
sudo su -
cybergis-script-init-rogue.sh prod user

#Step 4
cybergis-script-init-rogue.sh prod rvm
reboot

#Step 5
sudo su -
cybergis-script-init-rogue.sh prod gems

#Step 6a (RDS)
cybergis-script-postgis.sh prod install rds <host> 5432 postgres <password> template_postgis template0
cybergis-script-init-rogue.sh prod conf_application <fqdn> <db_host> <db_ip> <db_port> <db_password> <gs_baseline>

#Step 6b (Remote Database)

#Step 6c (Local Database)
