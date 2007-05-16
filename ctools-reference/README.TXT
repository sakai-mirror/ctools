This directory contains files important to a CTools installation that
don't have another home. 

UMichCM.xml - The UMich configuration of the 2.4 CourseManagement
provider. 

UMichGrades.xml - The UMich configuration of grading scales for
Gradebook. 

config - contains files to build configuration files for specific
instances of CTools. E.g. production, load, testctools, localhost.

error-pages - These are customized web server error pages for CTools.

favicon.ico - This is a web browser icon for CTools.

library - This generates ctlib, which contains CTools skins and
icons. 

web.xml.?????? - These files are tomcat conf/web.xml files.  That file
needs to be customized in order to deliver custom error pages.  These
files are not kept in the error-pages directory in case they need to
be customized for reasons having nothing to do with error pages.

------
$HeadURL$
$Id$
