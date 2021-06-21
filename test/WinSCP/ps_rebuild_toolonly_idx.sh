#/usr/bin/sh

export ORACLE_HOME=/u01/app/oracle/product/11.2.0/dbhome_1
export TWO_TASK=$1
export PS_HOME=/u01/app/psoft/pt854
export PS_CFG_HOME=/u01/app/psoft/config
export TUXDIR=/u01/app/middleware/tux1211
export LD_LIBRARY_PATH=/u01/app/psoft/pt854/bin:/u01/app/middleware/tux1211/lib:$LD_LIBRARY_PATH
export PATH=$ORACLE_HOME/bin:$TUXDIR/bin:$PS_HOME/bin:$PATH

rm -f /tmp/rebuild.sql
echo "set pagesize 0" >> /tmp/rebuild.sql
echo "set heading off" >> /tmp/rebuild.sql
echo "set feedback off" >> /tmp/rebuild.sql
echo "set term off" >> /tmp/rebuild.sql
echo "set term off" >> /tmp/rebuild.sql
echo "spool /tmp/rebuild.lst" >> /tmp/rebuild.sql
echo "WITH REC_CUR AS ( " >> /tmp/rebuild.sql
echo "SELECT RECNAME,REPLACE(SQLTABLENAME,' ',NULL) AS SQLTABLENAME " >> /tmp/rebuild.sql
echo "FROM   PSRECDEFN" >> /tmp/rebuild.sql
echo "WHERE RECTYPE=0 AND SQLTABLENAME<> ' ' )" >> /tmp/rebuild.sql
echo "select 'spool /tmp/reindex_' || TO_CHAR(SYSDATE,'YYYYMMDD') || '.log' from dual" >> /tmp/rebuild.sql
echo "UNION ALL" >> /tmp/rebuild.sql
echo "select 'ALTER INDEX SYSADM.' || IND.INDEX_NAME || ' REBUILD PARALLEL;' from REC_CUR " >> /tmp/rebuild.sql
echo "JOIN USER_TABLES TAB ON NVL(REC_CUR.SQLTABLENAME, 'PS_' || REC_CUR.RECNAME)=TAB.TABLE_NAME" >> /tmp/rebuild.sql
echo "JOIN USER_INDEXES IND ON TAB.TABLE_NAME=IND.TABLE_NAME AND IND.INDEX_TYPE='NORMAL'" >> /tmp/rebuild.sql 
echo "UNION ALL" >> /tmp/rebuild.sql
echo "SELECT 'REM ****Disable index parallel' from dual" >> /tmp/rebuild.sql
echo "UNION ALL" >> /tmp/rebuild.sql
echo "select 'ALTER INDEX SYSADM.' || IND.INDEX_NAME || ' NOPARALLEL;' from REC_CUR " >> /tmp/rebuild.sql
echo "JOIN USER_TABLES TAB ON NVL(REC_CUR.SQLTABLENAME, 'PS_' || REC_CUR.RECNAME)=TAB.TABLE_NAME" >> /tmp/rebuild.sql
echo "JOIN USER_INDEXES IND ON TAB.TABLE_NAME=IND.TABLE_NAME AND IND.INDEX_TYPE='NORMAL'" >> /tmp/rebuild.sql
echo "UNION ALL" >> /tmp/rebuild.sql
echo "select 'spool off' from dual;" >> /tmp/rebuild.sql
echo "spool off"  >> /tmp/rebuild.sql
echo "exit" >> /tmp/rebuild.sql

sqlplus sysadm/$2 @/tmp/rebuild.sql

#sqlplus /nolog << IDX
#conn sysadm/$2
#set echo on
#set feedback on
#@/tmp/rebuild.lst
#exit
#IDX
