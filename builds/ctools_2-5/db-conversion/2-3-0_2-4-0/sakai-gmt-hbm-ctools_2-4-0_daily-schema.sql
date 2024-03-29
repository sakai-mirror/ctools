drop table GMT_CONTEXT_ASSOCIATION cascade constraints;
drop table GMT_GOAL cascade constraints;
drop table GMT_GOALSET cascade constraints;
drop table GMT_LINK cascade constraints;
drop table GMT_RATING cascade constraints;

-- These are changes suggested by Drew to give the constraints more appropriate names.

create table GMT_CONTEXT_ASSOCIATION (FROM_CONTEXT varchar2(99 char) not null, TO_CONTEXT varchar2(99 char) not null, VERSION number(10,0) not null, constraint PK_GMT_CONTEXT_ASSOCIATION primary key (FROM_CONTEXT, TO_CONTEXT));

create table GMT_GOAL (ID varchar2(36 char) not null, VERSION number(10,0) not null, TITLE varchar2(255 char), DESCRIPTION clob, GOALSET_ID varchar2(36 char) not null, PARENT_GOAL_ID varchar2(36 char), constraint PK_GMT_GOAL primary key (ID));

create table GMT_GOALSET (ID varchar2(36 char) not null, VERSION number(10,0) not null, SUGGESTED_BY varchar2(36 char), TITLE varchar2(255 char), DESCRIPTION clob, CONTEXT varchar2(99 char) not null, PUBLISHED number(1,0) not null, constraint PK_GMT_GOALSET primary key (ID));

create table GMT_LINK (ID varchar2(36 char) not null, VERSION number(10,0) not null, ACTIVITY_REF varchar2(255 char) not null, GOAL_ID varchar2(36 char) not null, RUBRIC clob, RATIONALE clob, EXPORT_STRING number(10,0) not null, VISIBLE number(1,0) not null, constraint PK_GMT_LINK primary key (ID), constraint UK_GMT_LINK unique (ACTIVITY_REF, GOAL_ID));

create table GMT_RATING (ID varchar2(36 char) not null, VERSION number(10,0) not null, ITEM_REF varchar2(255 char) not null, LINK_ID varchar2(36 char) not null, RATING varchar2(255 char) not null, COMMENTS clob, constraint PK_GMT_RATING primary key (ID), constraint UK_GMT_RATING unique (ITEM_REF, LINK_ID));

-- create table GMT_CONTEXT_ASSOCIATION (FROM_CONTEXT varchar2(99 char) not null, TO_CONTEXT varchar2(99 char) not null, VERSION number(10,0) not null, primary key (FROM_CONTEXT, TO_CONTEXT));
-- create table GMT_GOAL (ID varchar2(36 char) not null, VERSION number(10,0) not null, TITLE varchar2(255 char), DESCRIPTION clob, GOALSET_ID varchar2(36 char) not null, PARENT_GOAL_ID varchar2(36 char), primary key (ID));
-- create table GMT_GOALSET (ID varchar2(36 char) not null, VERSION number(10,0) not null, SUGGESTED_BY varchar2(36 char), TITLE varchar2(255 char), DESCRIPTION clob, CONTEXT varchar2(99 char) not null, PUBLISHED number(1,0) not null, primary key (ID));
-- create table GMT_LINK (ID varchar2(36 char) not null, VERSION number(10,0) not null, ACTIVITY_REF varchar2(255 char) not null, GOAL_ID varchar2(36 char) not null, RUBRIC clob, RATIONALE clob, EXPORT_STRING number(10,0) not null, VISIBLE number(1,0) not null, primary key (ID), unique (ACTIVITY_REF, GOAL_ID));
-- create table GMT_RATING (ID varchar2(36 char) not null, VERSION number(10,0) not null, ITEM_REF varchar2(255 char) not null, LINK_ID varchar2(36 char) not null, RATING varchar2(255 char) not null, COMMENTS clob, primary key (ID), unique (ITEM_REF, LINK_ID));
alter table GMT_GOAL add constraint FK4D66888484568B1C foreign key (GOALSET_ID) references GMT_GOALSET;
alter table GMT_GOAL add constraint FK4D6688846E3F0D23 foreign key (PARENT_GOAL_ID) references GMT_GOAL;
alter table GMT_LINK add constraint FK4D68B96B5F1AA7B8 foreign key (GOAL_ID) references GMT_GOAL;
alter table GMT_RATING add constraint FK9FEF1ECE3E34DED8 foreign key (LINK_ID) references GMT_LINK;
