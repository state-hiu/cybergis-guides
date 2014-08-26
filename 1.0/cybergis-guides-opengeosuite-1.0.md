OpenGeo Suite Guide, Version 1.0
================

| Guides: | [Vanilla GeoNode](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-vanillageonode-1.0.md) | [ROGUE GeoNode](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-roguegeonode-1.0.md) |  [OpenGeo Suite](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-opengeosuite-1.0.md) |
| ---- |  ---- | ---- | ---- |

#This Guide is still under development.  It should not be used, yet.

## Description

This guide provides instructions for installing and managing an OpenGeo Suite instance in a production environment.  You can find the basic installation guide at [http://suite.opengeo.org/opengeo-docs/installation/ubuntu/install.html](http://suite.opengeo.org/opengeo-docs/installation/ubuntu/install.html).  You can find more information about configuring the OpenGeo Suite for production at [http://suite.opengeo.org/opengeo-docs/sysadmin/production/performance.html](http://suite.opengeo.org/opengeo-docs/sysadmin/production/performance.html).

### Cheat Sheet
In case you've walked through the guide before and understand the installation process, there is a cheat sheet available for this guide at [https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-opengeosuite-cheatcheet-1.0.sh](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-opengeosuite-cheatcheet-1.0.sh).  The cheat sheet contains the same exact steps in the guide.  It is designed for quick access and copy/paste into a shell.  You still should execute commands line by line.  The cheat sheet is not "executable".

### CyberGIS
The Humanitarian Information Unit has been developing a sophisticated geographic computing infrastructure referred to as the CyberGIS. The CyberGIS provides highly available, scalable, reliable, and timely geospatial services capable of supporting multiple concurrent projects.  The CyberGIS relies on primarily open source projects, such as PostGIS, GeoServer, GDAL, GeoGit, OGR, and OpenLayers.  The name CyberGIS is dervied from the term geospatial cyberinfrastructure.

### Bugs

If you find any bugs in the OpenGeo Suite, please submit them as issues to the respective component's GitHub repository or to the OpenGeo Suite GitHub repository at [https://github.com/boundlessgeo/suite](https://github.com/boundlessgeo/suite).  If you find any bugs with the guide itself, please submit them to this repo at [https://github.com/state-hiu/cybergis-guides/issues](https://github.com/state-hiu/cybergis-guides/issues).

## Provision

Before you begin the installation process, you'll need to provision a virtual or physical machine.  If you are provisioning an instance using Amazon Web Services, we recommend you use the baseline Ubuntu 12.04 LTS AMI managed by Ubuntu/Canonical.  You can lookup the most recent ami code on this page: [https://cloud-images.ubuntu.com/releases/precise/release/](https://cloud-images.ubuntu.com/releases/precise/release/).  Generally speaking, you should use the 64-bit EBS-SSD AMI for ROGUE GeoNode.

## Installation

Launching an OpenGeo Suite instance only requires a few simple steps.  The installation process is relatively painless on a clean build and can be completed in less than 30 minutes, usually 15 minutes.

These instructions were written for deployment on the Ubuntu operating system, but may work on other Linux variants.  The OpenGeo Suite will not install on Ubuntu 14.04 yet as a few dependencies have not been upgraded yet.  We recommend using Ubuntu 12.04.

You'll want to complete all the below steps as the root (with login shell and enviornment).  Therefore, use `sudo su -` to become the root user.  Do not use `sudo su root`, as that may not provide the environment necessary.

You can **rerun** most steps, but not all, if a network connection drops, e.g., during installation of a Ruby GEM dependency.

Installation only requires 5 simple steps.  Most steps only require executing one command on the command line.

1. Install CyberGIS Scripts.  [[Jump]](#step-1)
2. Add OpenGeo Suite apt repo to sources [[Jump]](#step-2)
3. Install the OpenGeo Suite [[Jump]](#step-3)
4. Remove sensitive documents [[Jump]](#step-4)
5. Tune memory space.  [[Jump]](#step-5)

###Kown Issues

No known issues

###Step 1

The first step is install the CyberGIS scripts from the [cybergis-scripts](https://github.com/state-hiu/cybergis-scripts) repo.  As root (`sudo su -`) execute the following commands.

```
apt-get update
apt-get install -y curl vim git
cd /opt
git clone https://github.com/state-hiu/cybergis-scripts.git cybergis-scripts.git
cp cybergis-scripts.git/profile/cybergis-scripts.sh /etc/profile.d/
```

###Step 2

The second step is to download and configure the OpenGeo Suite apt repo.  The following code block will download and configure the OpenGeo Suite apt repo.

```
wget -qO - http://apt.opengeo.org/gpg.key | apt-key add -
echo "deb http://apt.opengeo.org/suite/v4/ubuntu/ precise main" > /etc/apt/sources.list.d/opengeo.list
apt-get update
```

You can check that you added the OpenGeo Suite apt repo to your sources correctly, by checking the sources list with:

```
cat /etc/apt/sources.list.d/opengeo.list | tail -n 4
```

and by checking the apt cache with the following command.

```
apt-cache search opengeo
```

###Step 3

Confirm you ran `apt-get update` so that the OpenGeo Suite apt repo is discovered.  To install the OpenGeo Suite, run the following command.

```
apt-get install opengeo
```

The default admin username/password will be admin/geoserver.  After the command has finished running, you should be able to log into GeoServer via the implicit url.  GeoServer will respond to the domain name or ip address automatically.

###Step 4

You should now remove sensitive documents that are left on disk after a fresh install.

You need to remove the master password file.  Before you remove this file, be sure to copy the password into secure storage (piece of paper,  usb stick, encrypted volume, etc.).  You are able to login with the master password as the `root` user with username `root` (this is different than the default `admin` user).

```
placeholder: remove master password file
```

###Step 5

You're still root right?  Now we need to configure GeoServer so that it has enough memory.  If you do not tune GeoServer, then your risk out of memory errors on large WMS requests.  You can tun GeoServer with the following command.  The `repo` paramter is the path to a git repo that is backing up the /etc/defaults directory, so that you can roll back to a previous version if necessary.  The `Xmx` parameter stands for the maximum JVM heap size.  See [http://docs.oracle.com/javase/6/docs/technotes/tools/windows/java.html](http://docs.oracle.com/javase/6/docs/technotes/tools/windows/java.html) for more details.  Other JVM options will be added automatically in align with the GeoServer performance documentation provided at [http://suite.opengeo.org/opengeo-docs/sysadmin/production/performance.html](http://suite.opengeo.org/opengeo-docs/sysadmin/production/performance.html).

```
cybergis-script-geoserver.sh prod tune <repo> <Xmx>
```

The git repo path should be encased in single quotes to ensure it is treated as a literal.  For example, the script below will configure the JVM so that GeoServer can use up to 12 gigabytes of memory for it's heap.

```
cybergis-script-geoserver.sh prod tune '/cybergis/misc/git/repo/etc_defaults' 12G
```

You'll also want to add swap space to the instance so GeoServer (Tomcat) can absorb high-memory WMS calls without crashing.  See the Ubuntu SwapFaq article for more information at [https://help.ubuntu.com/community/SwapFaq](https://help.ubuntu.com/community/SwapFaq).

```
cybergis-script-ec2.sh prod swap 64g /mnt/swap_64g.swap
```

You can confirm that the swap was added correctly, with `free -g`.  You should see the swap space on the `Swap` line.

To delete a swap file, run:

```
cybergis-script-ec2.sh prod delete_swap /mnt/swap_64g.swap
```

