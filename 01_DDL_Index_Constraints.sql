-- *** 1. Primary key definition and any other constraint or index suggestion


-- A) ITEM_LOC_SOH table
-- A.1) Add composite primary key to ensure uniqueness
ALTER TABLE item_loc_soh
ADD CONSTRAINT pk_item_loc_soh PRIMARY KEY (item, loc);
-- A.2) Add Foreign Key to ITEM to ensure data integrity — stock can't exist for non-existing item on table item.
ALTER TABLE item_loc_soh
ADD CONSTRAINT fk_item FOREIGN KEY (item)
REFERENCES item(item);
-- A.3) Add Foreign Key to loc to ensure data integrity — stock record can't exist for non-existing location (loc).
ALTER TABLE item_loc_soh
ADD CONSTRAINT fk_loc FOREIGN KEY (loc)
REFERENCES loc(loc);
-- A.4) Add Foreign Key to loc to ensure data integrity
ALTER TABLE item_loc_soh
ADD CONSTRAINT fk_dept FOREIGN KEY (dept)
REFERENCES dept(dept);
-- A.5) ITEM_LOC_SOH: Index to speed up search by LOC
CREATE INDEX idx_item_loc_soh_loc ON item_loc_soh (loc);
-- A.6) Index to speed up search by DEPT
CREATE INDEX idx_item_loc_soh_dept ON item_loc_soh (dept);

-- B) ITEM table
-- B.1) Add Primary Key to  guarantees uniqueness.
ALTER TABLE item
ADD CONSTRAINT pk_item PRIMARY KEY (item);
-- B.2) Index to speed up search by dept
CREATE INDEX idx_item_dept ON item (dept);
-- B.3) Index to speed up search by item_desc
CREATE INDEX idx_item_item_desc ON item (item_desc);
-- B.4) Foreign Key to ensure data integrity - dept must exist on dept table
ALTER TABLE ITEM
  ADD CONSTRAINT FK_ITEM_DEPT FOREIGN KEY (DEPT)
  REFERENCES DEPT(DEPT);

-- C) LOC Table
-- C.1) Add Primary Key to  guarantees uniqueness.
ALTER TABLE loc
ADD CONSTRAINT pk_loc PRIMARY KEY (loc);
