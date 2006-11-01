University of Michigan sql conversion from 2.2.0 to 2.2.1.

Original scripts copied after release of 2.2.1 from https://source.sakaiproject.org/svn/reference/tags/sakai_2-2-1/docs/conversion/sakai_2_2_0-2_2_1_oracle_conversion.sql. on 2006/08/17.

Current script is annotated version of original.  

The 2.1.2 -> 2.2.0 group permissions update failed since the update
query was wrong.  The file sakai_2-1-2_2-2-1-group-permissions.sql in
this directory contains a corrected version of the update sql and
should be run on any db that was converted from 2.1.2 and has not had
this run.

------------------------------
$HeadURL$
$Id$
