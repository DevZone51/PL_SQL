CREATE OR REPLACE PACKAGE STOCK_SNAPSHOT_BULK  AS
  FUNCTION SNAPSHOT_SOH_BULK(p_loc IN NUMBER DEFAULT NULL) RETURN NUMBER;
END STOCK_SNAPSHOT_BULK;
/

CREATE OR REPLACE PACKAGE BODY STOCK_SNAPSHOT_BULK AS

  FUNCTION SNAPSHOT_SOH_BULK(p_loc IN NUMBER DEFAULT NULL) RETURN NUMBER IS
    TYPE t_snapshot_record IS RECORD (
      ITEM            ITEM_LOC_SOH.ITEM%TYPE,
      LOC             ITEM_LOC_SOH.LOC%TYPE,
      DEPT            ITEM_LOC_SOH.DEPT%TYPE,
      UNIT_COST       ITEM_LOC_SOH.UNIT_COST%TYPE,
      STOCK_ON_HAND   ITEM_LOC_SOH.STOCK_ON_HAND%TYPE,
      STOCK_VALUE     NUMBER,
      CREATE_DATETIME TIMESTAMP
    );

    TYPE t_snapshot_table IS TABLE OF t_snapshot_record INDEX BY PLS_INTEGER;

    v_data t_snapshot_table;

  BEGIN
    -- Bulk collect into PL/SQL table
    IF p_loc IS NULL THEN
      SELECT
        ITEM,
        LOC,
        DEPT,
        UNIT_COST,
        STOCK_ON_HAND,
        UNIT_COST * STOCK_ON_HAND AS STOCK_VALUE,
        SYSTIMESTAMP
      BULK COLLECT INTO v_data
      FROM ITEM_LOC_SOH;
    ELSE
      SELECT
        ITEM,
        LOC,
        DEPT,
        UNIT_COST,
        STOCK_ON_HAND,
        UNIT_COST * STOCK_ON_HAND AS STOCK_VALUE,
        SYSTIMESTAMP
      BULK COLLECT INTO v_data
      FROM ITEM_LOC_SOH
      WHERE LOC = p_loc;
    END IF;

    -- Bulk insert into target table
    FORALL i IN v_data.FIRST .. v_data.LAST
      INSERT INTO ITEM_LOC_SOH_EOD (
        ITEM, LOC, DEPT, UNIT_COST, STOCK_ON_HAND, STOCK_VALUE, CREATE_DATETIME
      )
      VALUES (
        v_data(i).ITEM,
        v_data(i).LOC,
        v_data(i).DEPT,
        v_data(i).UNIT_COST,
        v_data(i).STOCK_ON_HAND,
        v_data(i).STOCK_VALUE,
        v_data(i).CREATE_DATETIME
      );

    COMMIT;
    RETURN 1;

  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
      RETURN 0;
  END SNAPSHOT_SOH_BULK;

END STOCK_SNAPSHOT_BULK;
/
