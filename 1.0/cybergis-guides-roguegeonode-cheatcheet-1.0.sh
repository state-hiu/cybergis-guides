#!/bin/bash
#============#
#This is the cheat sheet for the ROGUE GeoNode Guide.
#This cheat sheet is designed to streamline installation without including explanation of each step.
#Use the full guide found at https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-roguegeonode-1.0.md
#if you wish to walk through the installation.
#============#
#Important!  This is not designed as a single bash script.  You'll still need to execute lines one by one.
#============#
#Provision Machine
#Provision (virtual) machine
#For AWS: Check https://cloud-images.ubuntu.com/releases/precise/release/

#Step 1
sudo su -
apt-get update
apt-get upgrade
apt-get install -y curl vim git
apt-get install -y postgresql-client-common postgresql-client-9.3
apt-get install -y libgeos-dev libproj-dev
cd /opt
git clone https://github.com/state-hiu/cybergis-scripts.git cybergis-scripts.git
cp cybergis-scripts.git/profile/cybergis-scripts.sh /etc/profile.d/
exit

#Step 2
sudo su -
cybergis-script-rogue.sh prod user

#Step 3
cybergis-script-rogue.sh prod rvm
cybergis-script-rogue.sh prod bundler

#Step 4
#If cybergis-script-init-rogue.sh prod [conf_standalone|conf_application] stalls, 
#then run the below line and then rerun.
source /usr/local/rvm/scripts/rvm; gem install dep-selector-libgecode -v '1.0.2'

#Step 4a (RDS)
cybergis-script-postgis.sh prod install rds <host> 5432 postgres <password> template_postgis template0
#To confirm that PostGIS was set up correctly, try logging into the databse with the command below.
#PGPASSWORD='XXX' psql --host=XXX.rds.amazonaws.com --port=5432 --username postgres --d=template_postgis
cybergis-script-rogue.sh prod conf_application <fqdn> <db_host> <db_ip> <db_port> <db_password> <gs_baseline>

#Step 4b (Remote Database)

#Step 4c (Local Database / Standalone)
cybergis-script-rogue.sh prod conf_standalone <fqdn> <gs_baseline>

#Step 5
cybergis-script-rogue.sh prod provision
vim /etc/hosts/
vim /var/lib/geonode/rogue_geonode/rogue_geonode/local_settings.py
#Disable GZIP Compression if Needed
vim /var/lib/tomcat7/webapps/geoserver/WEB-INF/web.xml
vim /var/lib/geonode/rogue_geonode/geoserver_ext/src/main/webapp/WEB-INF/web.xml

#Step 6
cybergis-script-rogue.sh prod server [geonode|wms|tms] <name> <url>
