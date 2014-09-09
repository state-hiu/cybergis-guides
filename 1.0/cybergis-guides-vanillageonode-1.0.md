Vanilla GeoNode Guide, Version 1.0
================

| Guides: | [Vanilla GeoNode](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-vanillageonode-1.0.md) | [ROGUE GeoNode](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-roguegeonode-1.0.md) |  [OpenGeo Suite](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-opengeosuite-1.0.md) |
| ---- |  ---- | ---- | ---- |

## Description

This guide provides instructions for installing and managing a vanilla GeoNode instance in a production environment.  You can find basic information about installing a vanilla GeoNode at [http://geonode.org/](http://geonode.org/).  Use the ROGUE GeoNode guide for deployment of a Rogue GeoNode in a production environment [https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-roguegeonode-1.0.md](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-roguegeonode-1.0.md).

### Cheat Sheet
In case you've walked through the guide before and understand the installation process, there is a cheat sheet available for this guide at [https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-vanillageonode-cheatcheet-1.0.sh](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-vanillageonode-cheatcheet-1.0.sh).  The cheat sheet contains the same exact steps in the guide.  It is designed for quick access and copy/paste into a shell.  You still need to execute commands line by line.  The cheat sheet is not "executable".

### CyberGIS
The Humanitarian Information Unit has been developing a sophisticated geographic computing infrastructure referred to as the CyberGIS. The CyberGIS provides highly available, scalable, reliable, and timely geospatial services capable of supporting multiple concurrent projects.  The CyberGIS relies on primarily open source projects, such as PostGIS, GeoServer, GDAL, GeoGit, OGR, and OpenLayers.  The name CyberGIS is dervied from the term geospatial cyberinfrastructure.

### ROGUE
The Rapid Opensource Geospatial User-Driven Enterprise (ROGUE) Joint Capabilities Technology Demonstration (JCTD) is a two-year research & development project developing the technology for distributed geographic data creation and synchronization in a disconnected environement.  This new technology taken altogether is referred to as GeoSHAPE.  See [http://geoshape.org](http://geoshape.org) for more information.  HIU is leveraging the technology developed through ROGUE to build out the CyberGIS into a robust globally distributed infrastruture.

### Bugs

If you find any bugs, in the vanilla GeoNode, please submit them as issues to the GeoNode GitHub repo at [https://github.com/GeoNode/geonode/issues](https://github.com/GeoNode/geonode/issues).  If you find any bugs with the 
guide itself, please submit them to this repo at [https://github.com/state-hiu/cybergis-guides/issues](https://github.com/state-hiu/cybergis-guides/issues).

## Provision

Before you begin the installation process, you'll need to provision a virtual or physical machine.  If you are provisioning an instance using Amazon Web Services, we recommend you use the baseline Ubuntu 12.04 LTS AMI managed by Ubuntu/Canonical.  You can lookup the most recent ami code on this page: [https://cloud-images.ubuntu.com/releases/precise/release/](https://cloud-images.ubuntu.com/releases/precise/release/).  Generally speaking, you should use the 64-bit EBS-SSD AMI for vanilla GeoNode.

## Installation

Launching a vanilla GeoNode only requires a few simple steps.  The installation process is very quick on a clean build and can be completed in less than 15 minutes.

These instructions were written for deployment on the Ubuntu operating system, but may work on other Linux variants.  GeoNode (Vanilla and ROGUE) will not install on Ubuntu 14.04 LTS yet as a few dependencies have not been upgraded yet.  We recommend using Ubuntu 12.04 LTS.

You'll want to complete all the following command line calls as root (with login shell and enviornment).  Therefore, use `sudo su -` to become the root user.  Do not use `sudo su root`, as that will not provide the environment necessary.

You can **rerun** most steps, if a network connection drops, e.g., during installation of a Ruby GEM dependency.

Installation only requires 5 simple steps.  Most steps only require executing one command on the command line.  Steps 7 to 9 are optional, but help integration of GeoNode into existing geospatial workflows.

1. Install CyberGIS Scripts.  [[Jump]](#step-1)
2. Add GeoNode apt repo to sources [[Jump]](#step-2)
3. Install Vanilla GeoNode [[Jump]](#step-3)
4. Create superuser [[Jump]](#step-4)
5. Update IP Address [[Jump]](#step-5)

###Kown Issues
No known issues

###Step 1

The first step is install the CyberGIS scripts from the [cybergis-scripts](https://github.com/state-hiu/cybergis-scripts) repo.

```
apt-get update
apt-get install -y curl vim git
cd /opt
git clone https://github.com/state-hiu/cybergis-scripts.git cybergis-scripts.git
cp cybergis-scripts.git/profile/cybergis-scripts.sh /etc/profile.d/
```

###Step 2

The second step is to install the GeoNode apt repository.

The following code block will download and configure the GeoNode apt repository.

```
add-apt-repository ppa:geonode/release
apt-get update
```

You can check that you added the GeoNode apt repo to your sources correctly, by checking the sources list with:

```
cat /etc/apt/sources.list | tail -n 4
```

and by checking the apt cache with the following command.

```
apt-cache search geonode
```

###Step 3

Make sure you've ran apt-get after adding the GeoNode apt repo.  To install vanilla GeoNode, just run the following command.

```
apt-get install geonode
```

###Step 4

By default, GeoNode does not create an admin account.  The following command will create an admin account.  We **strongly recommend** just using admin/admin and changing the password later.

```
geonode createsuperuser
```

###Step 5

To ehnace security, by default, GeoNode does not respond to any url.  To enable GeoNode to respond to its IP address or domain execute the following command.

```
geonode-updateip <ip/domain>
```
