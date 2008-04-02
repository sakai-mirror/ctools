Readme for CTools 2-3-0D to 2.4.0 database conversion.

TTD: (Things to do)
- Integrate CTools customizations.
- Test.
- Is conversion for 2.3.x in pilot different than for 2.3.0D in Production.

This directory holds scripts to convert the CTools databases from the
current values to the new 2.4.0 format.  It is subject to change.

2007/04/18 
- Using scripts from 2.4.0 QA TAG 010, add the content of
2_3_0-2_3_1 conversion to that for 2_3_1 -> 2_4_0 conversion.
- Customize for CTools.
- Add script to populate the term table for ctload.

Use the scripts from builds/ctools_2-4/tools/db-sql to generate sql suitable for inclusion.
mergeTemplateUpdates.pl will take 2 or 3 place tuples and generate input to:
generateRealmRoleFUnctionSQL2.pl.  See those files for details.

2007/05/18: 

The generateRealmRoleFunctionSQL2.pl script will now pass through any
line it doesn't understand.  Therefore you can embed add_to_tuple and
backfill commands in input file and the output those generate will
appear in the output stream after everything else in the file.  Also
the current input file is tracked (in comments) in the output stream,
so it is possible to use multiple input files and still not lose track
of where the input comes from.  The output from the add_to_tuple and
backfill commands is all printed at the end of processing, so you do
lose track of where those commands come from.


2007/07/16:

Need to add the initial data for citations.  How did it get left out of the CTools conversion?

$HeadURL$
$Id$


