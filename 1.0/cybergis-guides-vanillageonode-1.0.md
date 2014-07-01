Vanilla GeoNode Guide, Version 1.0
================

| Guides: | [Vanilla GeoNode](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-vanillageonode-1.0.md) | [ROGUE GeoNode](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-roguegeonode-1.0.md) |  [OpenGeo Suite](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-opengeosuite-1.0.md) |
| ---- |  ---- | ---- | ---- |

#The Guide is still under development.

## Description

This guide provides instructions for installing and managing a vanilla GeoNode instance in a production environment.  You can find basic information about installing a vanilla GeoNode at [http://geonode.org/](http://geonode.org/).  Use the ROGUE GeoNode guide for deployment of a Rogue GeoNode in a production environment [https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-roguegeonode-1.0.md](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-roguegeonode-1.0.md).

If you find any bugs, in the vanilla GeoNode, please submit them as issues to the GeoNode GitHub repo at [https://github.com/GeoNode/geonode/issues](https://github.com/GeoNode/geonode/issues).  If you find any bugs with the 
guide itself, please submit them to this repo at [https://github.com/state-hiu/cybergis-guides/issues](https://github.com/state-hiu/cybergis-guides/issues).

### Cheat Sheet
In case you've walked through the guide before and understand the installation process, there is a cheat sheet available for this guide at [https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-vanillageonode-cheatcheet-1.0-cheatsheet.sh](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-vanillageonode-cheatcheet-1.0-cheatsheet.sh).  The cheat sheet contains the same exact steps in the guide.  It is designed for quick access and copy/paste into a shell.  You still need to execute commands line by line.  The cheat sheet is not "executable".

### CyberGIS
The Humanitarian Information Unit has been developing a sophisticated geographic computing infrastructure referred to as the CyberGIS. The CyberGIS provides highly available, scalable, reliable, and timely geospatial services capable of supporting multiple concurrent projects.  The CyberGIS relies on primarily open source projects, such as PostGIS, GeoServer, GDAL, GeoGit, OGR, and OpenLayers.  The name CyberGIS is dervied from the term geospatial cyberinfrastructure.

### ROGUE
The Rapid Opensource Geospatial User-Driven Enterprise (ROGUE) Joint Capabilities Technology Demonstration (JCTD) is a two-year research & development project developing the technology for distributed geographic data creation and synchronization in a disconnected environement.  See [http://rogue.lmnsolutions.com](http://rogue.lmnsolutions.com) for more information.  HIU is leveraging the technology developed through ROGUE to build out the CyberGIS into a robust globally distributed infrastruture.

## Installation

Launching a ROGUE GeoNode only requires a few simple steps.  The installation process is relatively painless on a clean build and can be completed in less than 30 minutes.

These instructions were written for deployment on the Ubuntu operating system, but may work on other Linux variants.  ROGUE will not install on Ubuntu 14.04 LTS yet as a few dependencies have not been upgraded yet.  We recommend using Ubuntu 12.04 LTS.

You'll want to complete all the following command line calls as root (with login shell and enviornment).  Therefore, use `sudo su -` to become the root user.  Do not use `sudo su root`, as that will not provide the environment necessary.

You can **rerun** most steps, if a network connection drops, e.g., during installation of a Ruby GEM dependency.

Installation only requires 6 simple steps.  Most steps only require executing one command on the command line.  Steps 7 to 9 are optional, but help integration of GeoNode into existing geospatial workflows.

1. Install CyberGIS Scripts.  [[Jump]](#step-1)
2. Create ROGUE user account.  [[Jump]](#step-2)
3. Install RVM (Ruby Version Manager).  [[Jump]](#step-3)
4. Install Ruby GEM dependencies.  [[Jump]](#step-4)
5. Initialize Database [[Jump]](#step-5)
6. Install GeoNode.  [[Jump]](#step-6)
7. Add external servers to baseline (GeoNodes, WMS, and TMS).  [[Jump]](#step-7)
8. Add GeoGit remotes to baseline (other ROGUE GeoNodes) (**CURRENTLY BROKEN DO NOT EXECUTE.  Use MapLoom instead**)
9. Add post-commit AWS SNS hooks to repos.  [[Jump]](#step-9)
10. Add GeoGit sync cron jobs.  [[Jump]](#step-10)


###Kown Issues
1.  This scipt is currently incompatible with the most recent GeoGit Web API implementation.  You can still add remotes manually through MapLoom.  **Do not execute step 6.**
2.  The SNS hooks are not added to any repository .geogit/hooks directories, since the Geoserver GeoGit hooks implementation is not executing properly.  However, step 7 does not break the installation and you'll be able to test AWS SNS from the command line.

###Step 1

The first step is install the CyberGIS scripts from the [cybergis-scripts](https://github.com/state-hiu/cybergis-scripts) repo.

```
apt-get update
apt-get install -y curl vim git
cd /opt
git clone https://github.com/state-hiu/cybergis-scripts.git cybergis-scripts.git
cp cybergis-scripts.git/profile/cybergis-scripts.sh /etc/profile.d/
```
