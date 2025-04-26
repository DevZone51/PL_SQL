# PL_SQL - Evaluation Test


The provided script for the test raised error Error ORA-01536 when executed in Workspace gugatestzone in https://apex.oracle.com/ :

insert into item_loc_soh (item, loc, dept, unit_cost, stock_on_hand)
select item, loc, dept, (DBMS_RANDOM.value(5000,50000)), round(DBMS_RANDOM.value(1000,100000))from item, loc;commit;
![Error_Apex_DML_ITEM_LOC_SOH](https://github.com/user-attachments/assets/f89ce7a9-d440-4ca4-97d5-0157b7aadbf3)

The error ORA-01536 was caused because tablespace exceeded the amount provided for the Worspace 

In order to fix this , the original script was replaced by to commit in chunks of 10K, 1K and 100 registers .

          BEGIN
            FOR i IN 1..10 LOOP
              INSERT INTO item_loc_soh (item, loc, dept, unit_cost, stock_on_hand)
              SELECT item, loc, dept, 
                     (DBMS_RANDOM.value(5000, 50000)), 
                     ROUND(DBMS_RANDOM.value(1000, 100000))
              FROM item, loc
              WHERE ROWNUM <= 100000;  
              COMMIT;
            END LOOP;
          END;

