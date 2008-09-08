Adding tools to site via groovy.

This approach uses groovy code to write a tool that will run through
sites that are missing a designated tool and will then add that tool.

Because of limitations in the groovy implementation in Sakai the tool
must be put in a single script.  To avoid having a lot of duplicated
code there is a small perl script that expands a template file to
include common code.  To build a script for a particular update task:

- checkout the code from the directory:
  https://source.sakaiproject.org/svn/ctools/trunk/ctools-webservices/src/sash/groovy 




To get around problems with sash, where it only can deal with a single
file, use constructGroovyScript.pl to glue scripts together into a
single one for a particular  task. 

Use a static class to hold the values for a particular run.  It always
has the same name right now, but that should change.  



