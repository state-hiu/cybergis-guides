ROGUE GeoNode Guide, Version 1.0
================

| Specifications: | [ROGUE GeoNode](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-roguegeonode-1.0.md) | 
| ---- |  ---- |

## Description

This guide provides instructions for installing and managing a ROGUE GeoNode instance.

## Installation

Launching a ROGUE GeoNode only requires a few stimple steps.  The installation process is relatively painless on a clean build and can be completed in less than 30 minutes, usually 15 minutes.

These instructions were written for deployment on the Ubuntu operating system, but may work on other Linux variants.  ROGUE will not install on Ubuntu 14.04 yet as a few dependencies have not been upgraded yet.  We recommend using Ubuntu 12.04.

You'll want to complete all the below steps as the root (with login shell and enviornment).  Therefore, use `sudo su -` to become the root user.  Do not use `sudo su root`, as that will not provide the environment necessary.

You can **rerun** most steps, if a network connection drops, e.g., during installation of a Ruby GEM dependency.

Installation only requires 6 simple steps.  Most steps only require executing one command on the command line.

1. Install CyberGIS Scripts
2. Create ROGUE user account.
3. Install RVM (Ruby Version Manager)
4. Install Ruby GEM dependencies
5. Install GeoNode
6. Add external servers to baseline (GeoNodes, WMS, and TMS)
6. Add GeoGit remotes to baseline (other ROGUE GeoNodes)


The first step is install the CyberGIS scripts from the [cybergis-scripts](https://github.com/state-hiu/cybergis-scripts) repo.

```
apt-get update
apt-get install -y curl vim git
cd /opt
git clone https://github.com/state-hiu/cybergis-scripts.git cybergis-scripts.git
cp cybergis-scripts.git/profile/cybergis-scripts.sh /etc/profile.d/
```

Log out completely and log back in.  Remember to become root again (`sudo su -`).  The CyberGIS scripts should now be in every user's path.  We now need to create an account to run GeoNode.

```
cybergis-script-init-rogue.sh prod user
```

We now need to install RVM (Ruby Version Manager).  RVM is used to install Ruby GEM dependencies.  Chef also uses ruby to manage the integration of custom ROGUE components with a vanilla GeoNode.

```
cybergis-script-init-rogue.sh prod rvm
reboot
```

Make sure to reboot the server at this point to ensure the Ruby enviornment is set up properly.  **Do not just log out and log back in**.  Next, install the Ruby GEM dependencies.  The GEM dependencies that need to be installed at this point are Ruby, chef, solve, nokogiri, and berkshelf.  The following command will install them all.


```
cybergis-script-init-rogue.sh prod gems
```

Next, install GeoNode and the custom components, such as MapLoom.  This step will take the most time to execute, at least 5 minutes... even on m3.xlarge AWS instances.  Chef will download and install all remaining dependencies before install GeoNode itself.

Do **not** forget to include the fully qualified domain name (including subdomains) for the **fqdn** parameter, such as hiu-maps.net or example.com.  Do **not** include a port, protocol, or context path.

```
cybergis-script-init-rogue.sh prod geonode <fqdn>
```

After installation is complete, go to your GeoNode in a browser to confirm it installed properly.  The default user and password is admin and admin.  If installation was successful, continue to install baseline servers and remotes.

If you add external servers to the baseline, they'll, by default, appear in MapLoom, without requiring each user to add the url manually for each new map.  The following command will add the given server infromation to the settings.py file at the end of  `/var/lib/geonode/rogue_geonode/rogue_geonode/settings.py`.

To add a geonode server, include the protocol, domain, and port, for example `cybergis-script-init-rogue.sh prod server geonode http://example.com`.  The included parameter will be appended with `/geoserver/wms` automatically.  To include other providers of WMS services use the wms flag instead, for example `cybergis-script-init-rogue.sh prod server wms http://example.com/geoserver/wms`.  To include TMS services, such as HIU NextView High-Resolution Commercial Satellite Imagery services, provide the path to the capabilities document, for example, `cybergis-script-init-rogue.sh prod server tmns http://hiu-maps.net/hot/1.0.0`.

```
cybergis-script-init-rogue.sh $INIT_ENV $INIT_CMD [geonode|wms|tms] <name> <url>
```


