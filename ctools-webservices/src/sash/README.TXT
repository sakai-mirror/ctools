$HeadURL:$
$Id:$

This directory contains sash files for CTools.  

To use groovy files in sash:
- install and compile the sash 0.1.1 tags in a build.
- install html terminal in a site for a user with admin privilages.
- upload a groovy file to CTools (web dav can be very nice for
editing on a development host and then running on CTools).
- use the command 
groovy <stick in path to the groovy file>
The path to the groovy file is not obvious.  I've found it by
uploading to resources and using the tail end of the url that then
refers to the file.  E.g. the file referenced by
http://localhost:8080/access/content/group/1250fe63-f2f9-4f53-ae69-41f6a28217e0/hello.groovy
can be invoked via 
groovy /group/1250fe63-f2f9-4f53-ae69-41f6a28217e0/hello.groovy

The blog entry at http://unicon.net/node/969 is very helpful.
