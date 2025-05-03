CREATE OR REPLACE VIEW v_item_loc_soh AS
SELECT /*+ PARALLEL(item_loc_soh, 4) */
  item,
  loc,
  dept,
  ROUND(unit_cost, 2) AS unit_cost,
  stock_on_hand,
  ROUND(stock_on_hand * unit_cost, 2) AS stock_value
FROM
  item_loc_soh;
