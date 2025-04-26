-- insert / commit each 10K registers and for each loop iteration ensures that do not exists item,loc on item_loc_soh
BEGIN
  FOR i IN 1..10 LOOP
    INSERT INTO item_loc_soh (item, loc, dept, unit_cost, stock_on_hand)
    SELECT item, loc, dept,
           (DBMS_RANDOM.value(5000, 50000)),
           ROUND(DBMS_RANDOM.value(1000, 100000))
    FROM item im, loc loc
    WHERE ROWNUM <= 10000
      AND NOT EXISTS ( SELECT 1
                         FROM ITEM_LOC_SOH ils
                        WHERE ils.item = im.item
                           AND ils.loc = loc.loc);  
    COMMIT;
  END LOOP;
END;
