# PL_SQL
Evaluation - PL/SQL 

The provided script below was executed in Workspace gugatestzone in https://apex.oracle.com/ :

-- ( script provided for the test )
insert into item_loc_soh (item, loc, dept, unit_cost, stock_on_hand)
select item, loc, dept, (DBMS_RANDOM.value(5000,50000)), round(DBMS_RANDOM.value(1000,100000))from item, loc;commit;
--
During the run, it raised the error ORA-01536 because tablespace exceeded the amount provided by the account created in apex.com ( please check image Error_DML_ITEM_LOC_SOH.png )

In order to fix this , the original script was replaced by the 01_DML_INSERT_ITEM_LOC_SOH_FIX.sql
