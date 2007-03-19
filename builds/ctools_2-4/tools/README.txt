Tools to aid in building a production CTools image.

TTD:
- make pilot vs regular distinction
(some things are the same over many instances)
- make instance distinction
(doing this)
- make the build destination distinction
(pick up the db driver from a different location)
- improve packaging / installation.

-------- PURPOSE 

This tools set has been built for OS X and will work there.  It will
probably work on most *nix systems.  It should not be hard to get it
to work on Windows, since most of it is done with Ant, but it has not
been tested there.

The scripts were created with Ant 1.6.5, and requires some features
only available in Ant 1.6.x.  It may even require Ant 1.6.5.

Installing tools like melete can require extra steps.  There is some
special purpose code below for Melete.  Some things (like having the
directories setup for Melete) require action outside of these scripts.

--------- FILES

* build.xml - ant file with targets to build an image for a ctools install
* ctools-config.properties - configure a particular build
* setupTest - example of how to use ssh port forwarding.

--------- CREATING A CTOOLS IMAGE

To make a ctools image:
- check out this directory
- set the values in ctools-config.properties appropriately
- run ant buildCtoolsImage

This will:
- create build and image directories
- checkout appropriate source from sakai and ctools
- delete unwanted source (e.g. sample providers)
- compile 
- add db driver
- make the image directory
- tar up the resulting image

--------- INSTALLING A CTOOLS IMAGE

You will still need to untar the image into the appropriate directory
and add configuration files, e.g. sakai.properties.

To untar the image file into a tomcat directory:
- Create tomcat installation directory and populate it with tomcat.  
- run tar --gunzip -f <imagename>.tar.gz -C <tomcat directory> -x




$ID$
$HeadURL$
