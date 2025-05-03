-- Author: Gustavo Queiroz
-- Date: 2025-04-30
-- Project: Oracle
-- Description : 6. Create a package with procedure or function that can be invoked by store
--    or all stores to save the item_loc_soh to a new table that will contain
--    the same information plus the stock value per item/loc (unit_cost*stock_on_hand)

CREATE OR REPLACE PACKAGE STOCK_SNAPSHOT AS
  FUNCTION SNAPSHOT_SOH(p_loc IN NUMBER DEFAULT NULL) RETURN NUMBER;
END STOCK_SNAPSHOT;
/

CREATE OR REPLACE PACKAGE BODY STOCK_SNAPSHOT AS

  FUNCTION SNAPSHOT_SOH(p_loc IN NUMBER DEFAULT NULL) RETURN NUMBER IS
  BEGIN

   IF p_loc IS NULL THEN
      INSERT INTO ITEM_LOC_SOH_EOD (
        ITEM, LOC, DEPT, UNIT_COST, STOCK_ON_HAND, STOCK_VALUE, CREATE_DATETIME
      )
      SELECT
        ITEM,
        LOC,
        DEPT,
        UNIT_COST,
        STOCK_ON_HAND,
        UNIT_COST*STOCK_ON_HAND,
        SYSTIMESTAMP
      FROM ITEM_LOC_SOH;
    ELSE
        INSERT INTO ITEM_LOC_SOH_EOD (
        ITEM, LOC, DEPT, UNIT_COST, STOCK_ON_HAND, STOCK_VALUE, CREATE_DATETIME
      )
      SELECT
        ITEM,
        LOC,
        DEPT,
        UNIT_COST,
        STOCK_ON_HAND,
        UNIT_COST*STOCK_ON_HAND,
        SYSTIMESTAMP
      FROM ITEM_LOC_SOH
      WHERE LOC = p_loc ;

    END IF;
    COMMIT;
    RETURN 1;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END SNAPSHOT_SOH;

END STOCK_SNAPSHOT;
/
