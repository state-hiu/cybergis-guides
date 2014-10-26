OSM Extracts Guide, Version 1.0
================

| Guides: | [Vanilla GeoNode](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-vanillageonode-1.0.md) | [ROGUE GeoNode](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-roguegeonode-1.0.md) |  [OpenGeo Suite](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-opengeosuite-1.0.md) |   [OSM Extracts](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-osmextracts-1.0.md) |
| ---- |  ---- | ---- | ---- |  ---- |

## Description

This guide provides instructions for creating and managing OSM extracts via GeoServer/GeoGig.  First, this guide includes sections on provision, [installation](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-osmextracts-1.0.md#installation), and running GeoServer.  The guide then includes sections on initializing, updating, snapshotting, and animating extracts.

### Cheat Sheet
In case you've walked through the guide before and understand the installation process, there is a cheat sheet available for this guide at [https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-osmextracts-cheatcheet-1.0.sh](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-osmextracts-cheatsheet-1.0.sh).  The cheat sheet contains the same exact steps in the guide.  It is designed for quick access and copy/paste into a shell.  You still need to execute commands line by line.  The cheat sheet is not "executable".

### CyberGIS
The Humanitarian Information Unit has been developing a sophisticated geographic computing infrastructure referred to as the CyberGIS. The CyberGIS provides highly available, scalable, reliable, and timely geospatial services capable of supporting multiple concurrent projects.  The CyberGIS relies on primarily open source projects, such as PostGIS, GeoServer, GDAL, GeoGit, OGR, and OpenLayers.  The name CyberGIS is dervied from the term geospatial cyberinfrastructure.

### ROGUE
The Rapid Opensource Geospatial User-Driven Enterprise (ROGUE) Joint Capabilities Technology Demonstration (JCTD) is a two-year research & development project developing the technology for distributed geographic data creation and synchronization in a disconnected environement.  This new technology taken altogether is referred to as GeoSHAPE.  See [http://geoshape.org](http://geoshape.org) for more information.  HIU is leveraging the technology developed through ROGUE to build out the CyberGIS into a robust globally distributed infrastructure.

### Bugs

If you find any bugs in GeoGig please submit them as issues to the GeoGig GitHub repo at [https://github.com/boundlessgeo/geogig/issues](https://github.com/boundlessgeo/geogig/issues).  If you find any bugs in the GeoGig GeoServer Extension, please submit them as issues the GeoServer Extensions GitHub repo at [https://github.com/boundlessgeo/geoserver-exts/issues](https://github.com/boundlessgeo/geoserver-exts/issues).  If you find any bugs with the 
guide itself, please submit them to this repo at [https://github.com/state-hiu/cybergis-guides/issues](https://github.com/state-hiu/cybergis-guides/issues).

## Provision

Before you begin the installation process, you'll need to provision a virtual or physical machine.  If you are provisioning an instance using Amazon Web Services, we recommend you use the baseline Ubuntu 12.04 LTS AMI managed by Ubuntu/Canonical.  You can lookup the most recent ami code on this page: [https://cloud-images.ubuntu.com/releases/precise/release/](https://cloud-images.ubuntu.com/releases/precise/release/).  Generally speaking, you should use the 64-bit EBS-SSD AMI for vanilla GeoNode.

## Installation

Installation only requires 3 simple steps.  Most steps only require executing one command on the command line.

1. Install CyberGIS Scripts.  [[Jump]](#step-1)
2. Install "geogig" environment.  [[Jump]](#step-2)
3. Install "client" environment.  [[Jump]](#step-3)

###Kown Issues
No known issues

###Step 1

The first step is install the CyberGIS scripts from the [cybergis-scripts](https://github.com/state-hiu/cybergis-scripts) GitHub repo. As root (`sudo su -`) execute the following commands.

```
apt-get update
apt-get install -y curl vim git unzip
apt-get install -y postgresql-client-common postgresql-client-9.1
apt-get install -y libgeos-dev libproj-dev
cd /opt
git clone https://github.com/state-hiu/cybergis-scripts.git cybergis-scripts.git
cp cybergis-scripts.git/profile/cybergis-scripts.sh /etc/profile.d/
```

###Step 2

Install the "geogig" environment.  This will install cybergis-styles and cybergis-osm-mappings to `/opt`.

```
cybergis-script-env.sh geogig install
```

###Step 3

Install the "client" environment.  This will install Apache and cybergis-client-examples to `/opt`.

```
cybergis-script-env.sh client install
```

##Running GeoServer

To start GeoServer with the GeoGig extension, exectue the following:

```
cd ~/ws/gs/geoserver-2.6-RC1/
./bin/startup.sh
```

Or to launch it silently in the background, execute the following:

```
cd ~/ws/gs/geoserver-2.6-RC1/
./bin/startup.sh 2>&1 > /dev/null &
```

##Initializing Extracts

We now need to write the actual configuration files for what area and time period we want to extract.  For the sake of this Guide let's execute an extraction for Khulna, Bandladesh.

First, let's create a distinct folder to hold the scripts and configuration files for this extract project.

```
mkdir ~/ws/repo
mkdir ~/ws/repo/khulna
```

Next, let's create a tab-separated values file containing the basic info on what we want to extract.

```
touch ~/ws/repo/khulna/osm_extracts.tsv
```

Then add the followinng values to `~/ws/repo/khulna/osm_extracts.tsv` via VIM or your favorite editor.

```
id	datastore	extent	mapping
1	khulna_raw	bangladesh:khulna	
2	khulna_basic	bangladesh:khulna	basic:buildings_and_roads
```
Then, we need to create and execute the actual initialization script, such as the one below.

```
#!/bin/bash
#==========##========#
BIN=/opt/cybergis-scripts.git/bin
USER=admin
PASS=geoserver
GS='http://localhost:8080/geoserver/'
WS=osm-extracts
AN=hiu
AE='HIU_INFO@state.gov'
TO=360
RB=~/ws/repos/
#===================#
#Khulna
EXTENT='bangladesh:khulna'
#Khulna - Raw Nodes and Ways
RN=khulna_raw
REPO=$RB$RN
rm -fr $REPO
python $BIN/cybergis-script-geogig-osm-init.py  -v --path $REPO --name $RN --username $USER --password $PASS -gs $GS -ws $WS -to $TO --extent $EXTENT -an $AN -ae $AE --nodes --ways
#----------#
#Khulna - Basic
RN=khulna_basic
REPO=$RB$RN
MAPPING='basic:buildings_and_roads'
rm -fr $REPO
python $BIN/cybergis-script-geogig-osm-init.py  -v --path $REPO --name $RN --username $USER --password $PASS -gs $GS -ws $WS -to $TO --extent $EXTENT --mapping $MAPPING -an $AN -ae $AE
```
##Updating Extracts

You can update the extracts manually or via a cron job.  You should create a script wrapper for `cybergis-script-geogig-osm-sync.py`, so it easier to manage the multiple input values.  You can execute the script at whatever frequency desired.  Although the Overpass API is relatively performant, there is some latency.  Please be careful if you set up cron jobs for large areas.  Updates to the OSM extracts are transactional.  Therefore, it is exceptionally hard to corrupt extracts, but you might waste a lot of system resources if you update at a high frequency.  Only set the interval to less than 5 minutes if you've run some tests.

```
#!/bin/bash
#==========##========#
BIN=/opt/cybergis-scripts.git/bin
USER=admin
PASS=geoserver
GS='http://localhost:8080/geoserver/'
WS=osm-extracts
AN=hiu
AE='HIU_INFO@state.gov'
TO=360
#===================#
python  $BIN/cybergis-script-geogig-osm-sync.py false -v -gs $GS -ws $WS --username $USER --password $PASS -an $AN -ae $AE -to $TO --extracts osm_extracts.tsv
```

##Snapshotting Extracts

```
#!/bin/bash
#==========##========#
BIN=/opt/cybergis-scripts.git/bin
TIMESTAMP=$(date +%s)
#==#
GS_USER=admin
GS_PASS=geoserver
#==#
TEMP=~/temp/
#==#
GS='http://localhost:8080/geoserver/'
#==#
WFS=$GS"wfs"
HOST='<Database Host>'
DB=<Database Name>
DB_USER='postgres'
DB_PASS=<Database Password>
NS=osm-extracts
PRJ='EPSG:4326'
#==#
#For publishing
WS=<Workspace>
DS=<Data Store>
#===================#
#Khulna, Bangladesh / Raw
LG=khulna_raw_$TIMESTAMP
FTA=( "khulna_raw_node" "khulna_raw_way")
SNAPA=()
STYLESA=( "cybergis_basic_point_blue" "cybergis_basic_line_blue" )
for FT in "${FTA[@]}"
do
    SNAP=$FT"_"$TIMESTAMP
    SNAPA+=($SNAP)
    echo "-----------"
    echo "Snapshoting "$FT" as "$NS"_"$FT"_"$TIMESTAMP
    $BIN/cybergis-script-pull-wfs.sh $WFS $NS $FT $PRJ $HOST $DB $DB_USER $DB_PASS $SNAP $TEMP
    python $BIN/cybergis-script-geoserver-publish-layers.py -gs $GS -ws $WS -ds $DS -ft $SNAP --username $GS_USER --password $GS_PASS
done
LAYERS=$(printf ",%s" "${SNAPA[@]}")
LAYERS=$(echo $LAYERS | cut -c 2- )
STYLES=$(printf ",%s" "${STYLESA[@]}")
STYLES=$(echo $STYLES | cut -c 2- )
python $BIN/cybergis-script-geoserver-publish-layergroup.py -gs $GS -ws $WS -lg $LG --layers "$LAYERS" --styles "$STYLES" --username $GS_USER --password $GS_PASS
#===================#
#===================#
#Khulna, Bangladesh / Normal
LG=khulna_normal_$TIMESTAMP
FTA=( "khulna_basic_osm_buildings" "khulna_basic_osm_roads" )
SNAPA=()
STYLESA=( "cybergis_structure_buildings" "cybergis_basic_line_blue" )
for FT in "${FTA[@]}"
do
    SNAP=$FT"_"$TIMESTAMP
    SNAPA+=($SNAP)
    echo "-----------"
    echo "Snapshoting "$FT" as "$NS"_"$FT"_"$TIMESTAMP
    $BIN/cybergis-script-pull-wfs.sh $WFS $NS $FT $PRJ $HOST $DB $DB_USER $DB_PASS $SNAP $TEMP
    python $BIN/cybergis-script-geoserver-publish-layers.py -gs $GS -ws $WS -ds $DS -ft $SNAP --username $GS_USER --password $GS_PASS
done
LAYERS=$(printf ",%s" "${SNAPA[@]}")
LAYERS=$(echo $LAYERS | cut -c 2- )
STYLES=$(printf ",%s" "${STYLESA[@]}")
STYLES=$(echo $STYLES | cut -c 2- )
python $BIN/cybergis-script-geoserver-publish-layergroup.py -gs $GS -ws $WS -lg $LG --layers "$LAYERS" --styles "$STYLES" --username $GS_USER --password $GS_PASS
#===================#
```
##Animating Extracts

Go to cybergis client ("viewer") at `http://localhost/khulna/khulna.html`.  Get bbox, width, and height parameters from WMS layer.  Fill those in.

```
#!/bin/bash
#==========##========#
BIN=/opt/cybergis-scripts.git/bin
TIMESTAMP=$(date +%s)
#==#
GS_USER=admin
GS_PASS=geoserver
#==#
GS='http://localhost:8080/geoserver/'
#==#
PRJ='EPSG:4326'
#===================#
#Customize Layers, bbox, width, and height for each Animation
LAYERSA=( "A" "B" "C" )
LAYERS=$(printf ",%s" "${LAYERSA[@]}")
LAYERS=$(echo $LAYERS | cut -c 2- )
BBOX=<BBOX>
WIDTH=<WIDTH>
HEIGHT=<HEIGHT>
#==#
#===================#
python $BIN/cybergis-script-geoserver-animate.py -gs $GS --layers "$LAYERS" --bbox "$BBOX" --width "$WIDTH" --height "$HEIGHT" --username $GS_USER --password $GS_PASS --url
```
