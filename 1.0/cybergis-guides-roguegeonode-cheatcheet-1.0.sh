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

#Vagrant ONLY
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

locale-gen en_US.UTF-8
dpkg-reconfigure locales

#===================#
#Step 1
sudo su -
apt-get update
apt-get upgrade
apt-get install -y curl vim git
#apt-get install -y build-essential Only for Ubuntu 14.04
apt-get install -y postgresql-client-common postgresql-client-9.1
#apt-get install -y postgresql-client-common postgresql-client-9.3 Only for Ubuntu 14.04
apt-get install -y libgeos-dev libproj-dev
cd /opt
git clone https://github.com/state-hiu/cybergis-scripts.git cybergis-scripts.git
cp cybergis-scripts.git/profile/cybergis-scripts.sh /etc/profile.d/

source /etc/profile.d/cybergis-scripts.sh
#or
exit

#Step 2
sudo su -
cybergis-script-rogue.sh prod user

#Step 3
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
cybergis-script-rogue.sh prod rvm
cybergis-script-rogue.sh prod bundler

#Step 4

#Step 4a (RDS)
cybergis-script-postgis.sh prod install rds <host> 5432 postgres <password> template_postgis template0
#To confirm that PostGIS was set up correctly, try logging into the databse with the command below.
#PGPASSWORD='XXX' psql --host=XXX.rds.amazonaws.com --port=5432 --username postgres --d=template_postgis
cybergis-script-geoshape-configure.py
--env 'aws' \
--fqdn FQDN \
--banner \
--banner_text BANNER_TEXT \
--banner_color_text BANNER_COLOR_TEXT \
--banner_color_background BANNER_COLOR_BACKGROUND \
--db_host RDS_ENDPOINT \
--db_ip 'false' \
--db_port '5432' \
--db_pass RDS_PASSWORD \
--gs_data_url GS_DATA_URL  \
--gs_data_branch GS_DATA_BRANCH \

#Step 4b (Remote Database)

#Step 4c (Local Database / Standalone)
cybergis-script-geoshape-configure.py --fqdn FQDN

#Step 5
cybergis-script-rogue.sh prod gems
cybergis-script-rogue.sh prod provision
##
vim /etc/hosts/
vim /var/lib/geonode/rogue_geonode/rogue_geonode/local_settings.py
#Disable GZIP Compression if Needed
vim /var/lib/tomcat7/webapps/geoserver/WEB-INF/web.xml
vim /var/lib/geonode/rogue_geonode/geoserver_ext/src/main/webapp/WEB-INF/web.xml

#Step 6
cybergis-script-rogue.sh prod server [geonode|wms|tms] <name> <url>
