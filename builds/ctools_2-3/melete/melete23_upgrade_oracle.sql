-- From Tony Atkins at Virgina Tech.

alter table melete_course_module add delete_flag number(1);
update melete_course_module set delete_flag=0;
alter table melete_section add delete_flag number(1);
update melete_section set delete_flag=0;
CREATE TABLE melete_user_preference (
  PREF_ID int(11) primary key NOT NULL default '0',
  USER_ID varchar2(99) default NULL,
  EDITOR_CHOICE varchar2(255) default NULL
);
