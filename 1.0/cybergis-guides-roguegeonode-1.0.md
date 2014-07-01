ROGUE GeoNode Guide, Version 1.0
================

| Guides: | [Vanilla GeoNode](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-vanillageonode-1.0.md) | [ROGUE GeoNode](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-roguegeonode-1.0.md) |  [OpenGeo Suite](https://github.com/state-hiu/cybergis-guides/blob/master/1.0/cybergis-guides-opengeosuite-1.0.md) |
| ---- |  ---- | ---- | ---- |

#The Guide is undergoing changes to incorporate AWS RDS and separating the web and database servers.

## Description

This guide provides instructions for installing and managing a ROGUE GeoNode instance in a production environment.  You can find information about installing a vanilla GeoNode without the advanced data editing and sharing technology at [http://geonode.org/](http://geonode.org/).  You can find more information about ROGUE below and at [http://rogue.lmnsolutions.com/](http://rogue.lmnsolutions.com/).  Use the directions found at [http://rogue.lmnsolutions.com/](http://rogue.lmnsolutions.com/) for deploying a ROGUE GeoNode in a development environment.

If you find any bugs, in the vanilla GeoNode, please submit them as issues to the GeoNode GitHub repo at [https://github.com/GeoNode/geonode/issues](https://github.com/GeoNode/geonode/issues).  If you find bugs, in the ROGUE GeoNode, please submit them as tickets to the rogue_geonode GitHub repo at: [https://github.com/ROGUE-JCTD/rogue_geonode/issues](https://github.com/ROGUE-JCTD/rogue_geonode/issues).  If you find any bugs with the 
guide itself, please submit them to this repo at [https://github.com/state-hiu/cybergis-guides/issues](https://github.com/state-hiu/cybergis-guides/issues).

### CyberGIS
The Humanitarian Information Unit has been developing a sophisticated geographic computing infrastructure referred to as the CyberGIS. The CyberGIS provides highly available, scalable, reliable, and timely geospatial services capable of supporting multiple concurrent projects.  The CyberGIS relies on primarily open source projects, such as PostGIS, GeoServer, GDAL, GeoGit, OGR, and OpenLayers.  The name CyberGIS is dervied from the term geospatial cyberinfrastructure.

### ROGUE
The Rapid Opensource Geospatial User-Driven Enterprise (ROGUE) Joint Capabilities Technology Demonstration (JCTD) is a two-year research & development project developing the technology for distributed geographic data creation and synchronization in a disconnected environement.  See [http://rogue.lmnsolutions.com](http://rogue.lmnsolutions.com) for more information.  HIU is leveraging the technology developed through ROGUE to build out the CyberGIS into a robust globally distributed infrastruture.

## Installation

Launching a ROGUE GeoNode only requires a few simple steps.  The installation process is relatively painless on a clean build and can be completed in less than 30 minutes, usually 15 minutes.

These instructions were written for deployment on the Ubuntu operating system, but may work on other Linux variants.  ROGUE will not install on Ubuntu 14.04 yet as a few dependencies have not been upgraded yet.  We recommend using Ubuntu 12.04.

You'll want to complete all the below steps as the root (with login shell and enviornment).  Therefore, use `sudo su -` to become the root user.  Do not use `sudo su root`, as that will not provide the environment necessary.

You can **rerun** most steps, if a network connection drops, e.g., during installation of a Ruby GEM dependency.

Installation only requires 6 simple steps.  Most steps only require executing one command on the command line.  Steps 6 to 9 are optional, but help integration of GeoNode into existing geospatial workflows.

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

###Step 2

Log out completely and log back in.  Remember to become root again (`sudo su -`).  The CyberGIS scripts should now be in every user's path.  We now need to create an account to run GeoNode.  You don't execute any commands as the "rogue" user during installation.  Execute every command as root.

```
cybergis-script-init-rogue.sh prod user
```

###Step 3
You're still root right?  We now need to install RVM (Ruby Version Manager).  RVM is used to install Ruby GEM dependencies.  Chef also uses ruby to manage the integration of custom ROGUE components with a vanilla GeoNode.

```
cybergis-script-init-rogue.sh prod rvm
reboot
```

###Step 4
Make sure to reboot the server at this point to ensure the Ruby enviornment is set up properly.  **Do not just log out and log back in**.  Next, install the Ruby GEM dependencies.  The GEM dependencies that need to be installed at this point are Ruby, chef, solve, nokogiri, and berkshelf.  The following command will install them all.  Remember to become root again (`sudo su -`).  


```
cybergis-script-init-rogue.sh prod gems
```

###Step 5.

You have a lot of flexibility in deciding how to configure your PostGIS Database.  For basic installations where the database and web server are on the same instance, you can skip this step.  This guide will explain how to set up PostGIS in AWS RDS and how to initialize a PostGIS backend in a separate instance.

####Step 5a.
In step 5a, you can install PostGIS in AWS RDS.  To install PostGIS on a PostgreSQl AWS RDS Database take the following steps.  Assuming the DB security group has allowed access from the ROGUE GeoNode instance.  Connect to the database instance.

```
psql --host=XXX.rds.amazonaws.com --port=5432 --username postgres --password
```

From within psql execute the following (based on the direction found here: [http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.PostgreSQL.CommonDBATasks.html#Appendix.PostgreSQL.CommonDBATasks.PostGIS](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.PostgreSQL.CommonDBATasks.html#Appendix.PostgreSQL.CommonDBATasks.PostGIS)).

```
cybergis-script-postgis.sh prod install rds <host> 5432 postgres <password> template_postgis template0
```

####Step 5b.

In step 5b, you can install the PostGIS backend on a separate virutal machine or instance.

###Step 6

Next, install GeoNode and the custom components, such as MapLoom.  This step will take the most time to execute, at least 5 minutes... even on m3.xlarge AWS instances.  Chef will download and install all remaining dependencies before installing GeoNode itself.

Do **not** forget to include the fully qualified domain name (including subdomains) for the **fqdn** parameter, such as hiu-maps.net or example.com.  Do **not** include a port, protocol, or context path.

```
cybergis-script-init-rogue.sh prod geonode <fqdn>
```

After installation is complete, go to your GeoNode in a browser to confirm it installed properly.  The default user and password is admin and admin.  If installation was successful, continue to install baseline servers and remotes.

###Step 7

If you add external servers to the baseline, they'll, by default, appear in MapLoom, without requiring each user to add the url manually for each new map.  The following command will add the given server infromation to the settings.py file at the end of  `/var/lib/geonode/rogue_geonode/rogue_geonode/settings.py`.

To add a geonode server, include the protocol, domain, and port, for example `cybergis-script-init-rogue.sh prod server geonode ExampleName http://example.com`.  The included parameter will be appended with `/geoserver/wms` automatically.  To include other providers of WMS services use the wms flag instead, for example `cybergis-script-init-rogue.sh prod server wms ExampleName http://example.com/geoserver/wms`.  To include TMS services, such as HIU NextView High-Resolution Commercial Satellite Imagery services, provide the path to the capabilities document, for example, `cybergis-script-init-rogue.sh prod server tms ExampleName http://hiu-maps.net/hot/1.0.0`.

```
cybergis-script-init-rogue.sh prod server [geonode|wms|tms] <name> <url>
```
###Step 8

**Adding remotes from this script is currently broken.  Use MapLoom instead.  DO NOT EXECUTE**

You'll want to install remotes, next.  Remotes enable users to sync data among multiple ROGUE GeoNode instances.  You can add remotes using two commands.  The first command uses a url to the remote Geonode and remote repo name.  The second command uses a url to the repo directly.  The second command can be used once other implementations of the GeoGit Web API [http://geogit.org/docs/interaction/web-api.html](http://geogit.org/docs/interaction/web-api.html) are created.

To add a remote GeoNode use, 

```
cybergis-script-init-rogue.sh prod remote <user:password> <localRepoName> <localGeonodeURL> <remoteName> <remoteRepoName> <remoteGeoNodeURL> <remoteUser> <remotePassword>
```

To add a remote GeoGit repo (server agnostic),

```
cybergis-script-init-rogue.sh prod remote2 <user:password> <repoURL> <remoteName> <remoteURL> <remoteUser> <remotePassword>
```

You can confirm the remotes were added successfully, but executing the following command agains the GeoGit Web API.  You should see an xml output of all configured remotes. 

```
curl -u user:password 'http://example.com/geoserver/geogit/geonode:localRepoName/remote?list=true&verbose=true'
```

**Adding remotes from this script is currently broken.  Use MapLoom instead.  DO NOT EXECUTE**

###Step 9

To add Amazon Web Services (AWS) Simple Notification Services (SNS) post-commit hooks to repositories, you need to first install the python bindings for the AWS api tools and configure GeoNode's AWS settings.  The python binds for the AWS api tools is called Boto (see: [https://github.com/boto/boto](https://github.com/boto/boto)).  To install the bindings run:

```
cybergis-script-init-rogue.sh prod aws
```

To add the relevant settings to the GeoNode settings.py file, run the following command.  You'll most likely need to wrap the sns_topic string with double or single quotes to correctly pass the arguments.

```
cybergis-script-init-rogue.sh prod sns <aws_access_key_id> <aws_secret_access_key> <sns_topic>
```

You can test SNS with the following code block.  You need to use GeoNode's python interpreter to correctly load the GeoNode settings from the command line.

```
export DJANGO_SETTINGS_MODULE=rogue_geonode.settings
/var/lib/geonode/bin/python /opt/cybergis-scripts.git/lib/rogue/post_commit_hook.py <commit_message>
```

###Step 10
Cron jobs can be set up to sync local and remote GeoGit repos.  This can be very useful when syncing large datasets in primarily one direction.  For example, pushing a large amount of data to a field office at 6am before staff arrive at work.  The script will also help organizations receive updates to their layers from others without having to share their own propriety information.  The script will only sync when there are no conflicts.  Support for automated notifications when the sync fails using AWS SNS will be implemented soon.  You can sync at a standard hourly, daily, weekly, or monthly interval using the following command.  You need to add a remote via MapLoom or step 7 (once the script is fixed) before hand.

You can execute a push, pull, or two-way (duplex) cron job.  The three options for direction are: `push, pull, and duplex`.

```
cybergis-script-init-rogue.sh prod cron <direction> <user> <password> <localRepoName> <remoteName> <authorname> <authoremail> [hourly|daily|weekly|monthly]
```

You can also sync with a custom interval using standard crontab syntax.  See the relevant wikipedia article for more information [http://en.wikipedia.org/wiki/Cron](http://en.wikipedia.org/wiki/Cron).

```
cybergis-script-init-rogue.sh prod cron2 <direction> <user> <password> <localRepoName> <remoteName> <authorname> <authoremail> <frequency>
```

The frequency variable should be encased in single quotes to ensure it is treated as a literal.  For example, the script below will execute a GeoGit sync every 5 minutes.

```
cybergis-script-init-rogue.sh prod cron2 pull admin admin 'geonode:incidents_repo' 'AWS' dummy dummy@example.com '*/5 * * * *'
```

The sync commands are added to the file in the cron.d directory at `/etc/cron.d/geogit_sync`.  The concurrent commands execute in order of when they were added.  You can double check that the commands executed properly, manually adds sync commands, remove commands, ior otherwise edit existing commands.  Be careful to not create duplicate cron jobs, as you'll remove a great benfit of GeoGit--it effectively uses network bandwith.
