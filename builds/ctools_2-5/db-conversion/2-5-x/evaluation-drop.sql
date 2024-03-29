drop table EVAL_ANSWER cascade constraints;
drop table EVAL_ASSIGN_GROUP cascade constraints;
drop table EVAL_ASSIGN_HIERARCHY cascade constraints;
drop table EVAL_CONFIG cascade constraints;
drop table EVAL_EMAIL_TEMPLATE cascade constraints;
drop table EVAL_EVALUATION cascade constraints;
drop table EVAL_GROUPNODES cascade constraints;
drop table EVAL_GROUPNODES_GROUPS cascade constraints;
drop table EVAL_ITEM cascade constraints;
drop table EVAL_ITEMGROUP cascade constraints;
drop table EVAL_RESPONSE cascade constraints;
drop table EVAL_SCALE cascade constraints;
drop table EVAL_SCALE_OPTIONS cascade constraints;
drop table EVAL_TEMPLATE cascade constraints;
drop table EVAL_TEMPLATEITEM cascade constraints;
drop table EVAL_ADHOC_EVALUATEES cascade constraints;
drop table EVAL_ADHOC_GROUP cascade constraints;
drop table EVAL_ADHOC_PARTICIPANTS cascade constraints;
drop table EVAL_ADHOC_USER cascade constraints;
drop table EVAL_LOCK cascade constraints;
drop table EVAL_TAGS cascade constraints;
drop table EVAL_TAGS_META cascade constraints;
drop table EVAL_TRANSLATION cascade constraints;
delete SCHEDULER_DELAYED_INVOCATION where COMPONENT = 'org.sakaiproject.evaluation.logic.externals.EvalScheduledInvocation';
purge recyclebin;
