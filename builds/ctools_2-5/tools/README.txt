Tools to aid in building a production CTools image.

[Totally redone 2007/11/18]

In process of converting from ant to perl.  Currently functions that
used to require configuration outside of the properties / externals
files have been put in perl and configuration can be done in those
files.  The rest of the Ant files should be converted as time goes by.

TTD:

- Convert building of properties files to perl
- Get the code to remove files to read from a file.  E.g. need to
  delete sample files.

These tools create a CTools build.  This version has switched from
using an externals directory to using both a .externals and
.properties files to specify the build configuration.

$Id:$
$HeadURL$
