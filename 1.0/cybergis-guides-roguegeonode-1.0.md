ROGUE GeoNode Guide, Version 1.0
================

| Specifications: | [ROGUE GeoNode](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-roguegeonode-1.0.md) | 
| ---- |  ---- |

## Description

This guide sections for executing commons tasks when managing a ROGUE GeoNode.

## Installation

Launching a ROGUE GeoNode only requiers a few simple .  The installation process is relatively painless on a clean build and can be completed in less than 30 minutes, usually 15 minutes.  You'll want to complete all the below steps as the root (with login shell and enviornment).  Therefore, use `sudo su -` to become the root user.  Do not use `sudo su root`, as that will not provide the environment necessary.

There are five steps to take.

1. Install CyberGIS Scripts
2. Create ROGUE user account.
3. Install RVM (Ruby Version Manager)
4. Install Ruby GEM dependencies
5. Install GeoNode
6. Join the network (add remotes)


The first step is install the CyberGIS scripts from the [cybergis-scripts](https://github.com/state-hiu/cybergis-scripts) repo.

```
apt-get update
apt-get install -y curl vim git
cd /opt
git clone https://github.com/state-hiu/cybergis-scripts.git cybergis-scripts.git
cp cybergis-scripts.git/profile/cybergis-scripts.sh /etc/profile.d/
```

Log out completely and log back in.  The CyberGIS scripts should now be in every user's path.  We now need to create an account to run GeoNode.

```
cybergis-script-init-rogue.sh prod user
```

We now need to install RVM (Ruby Version Manager).  RVM is used to install Ruby GEM dependencies.  Chef also uses ruby to manage the integration of custom ROGUE components with a vanilla GeoNode.

```
cybergis-script-init-rogue.sh prod rvm
#reboot
```

Make sure to reboot the server at this point
