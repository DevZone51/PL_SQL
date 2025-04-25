BEGIN
  FOR i IN 1..10 LOOP
    INSERT INTO item_loc_soh (item, loc, dept, unit_cost, stock_on_hand)
    SELECT item, loc, dept,
           (DBMS_RANDOM.value(5000, 50000)),
           ROUND(DBMS_RANDOM.value(1000, 100000))
    FROM item, loc
    WHERE ROWNUM <= 100000;  -- Inserir em lotes de 100.000 registros
    COMMIT;
  END LOOP;
END;
