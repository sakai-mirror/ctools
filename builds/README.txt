This directory contains scripts and configurations to build CTools
images for multiple instances and versions of the CTools installation
of Sakai.  The tools are designed to allow automatic building of
releases via CruiseControl or some other CI tool.

Issues:
- Customize for UMich needs.
- Repeatable and reliable and automatible.
- Deal with multiple versions at once (Test has different code than production).
- Deal with multiple instances (For the same code the required
properties files are different for test and production).
- Separate the concerns for running production and for building
releases.

To setup a build environment:
- check out the appropriate subdirectory (ctools_2-3 or ctools_2-4).
- go into the configs subdirectory.
- modify the contents of shared.properties as appropriate.  These
values are meant to be common to all builds for a particular major
release.
- go into an appropriate subdirectory.  Each sub-directory is designed
to hold the configuration for 1 release configuration.  The contents
may bet tweaked many times during the developement of the release, but
are frozen after the release to production.  Any later adjustments should be
considered a new release and done in a copy of the original directory.
- Adjust the project.properties file to configure the build, and
adjust build-patch.xml to choose which patches will be applied to the
build.  Sometimes this requires tweaking the ant build scripts in the
tools directory.

Need to have installed:
- sakai development env (java, maven etc)
- ant 1.6.5+
???

Produces:
- overlay for Tomcat with all required code and Sakai/CTools
configuration.
- directories of properties files for different instances of the same
release. 

The image overlay can then be installed into a new tomcat, and the
properties files can be put in the appropriate sakai directory.
Security information (passwords, keys) are added during installation.

-------------------------
$HeadURL$
$Id$
