-- 2. Your suggestion for table data management and data access considering the application usage, for example, partition...

-- Create a partition by loc and subpartitions by dept . This will improve:
-- a) Performance : Queries by LOC, DEPT will be faster because will access only specific partitions .
-- b) Concurrency: Partitioning will reduce contention and avoid that high concurrency compete for the same data Block
-- c) Maintenability: Partitioning keep maitenance easier . You can move, exclude data from a partition without impacting the entire tabLike

-- Considering that ITEM_LOC_SOH is already populated by the provided initial script, the approach would be:


-- A.1 ) Create new partitioned table (_PART)



CREATE TABLE item_loc_soh_part
  (
     ITEM VARCHAR2(25) NOT NULL ENABLE,
     LOC  NUMBER(10,0) NOT NULL ENABLE,
     DEPT NUMBER(4,0) NOT NULL ENABLE,
     UNIT_COST NUMBER(20,4) NOT NULL ENABLE,
     STOCK_ON_HAND NUMBER(12,4) NOT NULL ENABLE
  )
PARTITION BY RANGE (loc)
  INTERVAL (1)
  SUBPARTITION BY HASH (dept)
  SUBPARTITIONS 8
(
  PARTITION loc_001 VALUES LESS THAN (2),
  PARTITION loc_002 VALUES LESS THAN (3),
  PARTITION loc_003 VALUES LESS THAN (4)
)
;



-- A.2 Move the data from item_loc_soh to item_loc_part
 INSERT /*+ APPEND */ INTO ITEM_LOC_SOH_PART
   SELECT * FROM ITEM_LOC_SOH WHERE ROWNUM;

--A.3 Verify if data were moved properly
SELECT COUNT(*) FROM item_loc_soh;
SELECT COUNT(*) FROM item_loc_soh_part;

--A.4. Drop old / Rename new tabLike
DROP TABLE item_loc_soh;
ALTER TABLE item_loc_soh_part RENAME TO item_loc_soh;

--A.5 recriate indexes, constraints previousvly defined
