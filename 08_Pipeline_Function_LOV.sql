CREATE OR REPLACE TYPE loc_obj_type AS OBJECT (
  loc       NUMBER,
  loc_desc  VARCHAR2(25)
);

CREATE OR REPLACE TYPE loc_tab_type AS TABLE OF loc_obj_type;

CREATE OR REPLACE FUNCTION get_loc_lov
  RETURN loc_tab_type PIPELINED
IS
BEGIN
  FOR rec IN (SELECT loc, loc_desc FROM loc) LOOP
    PIPE ROW(loc_obj_type(rec.loc, rec.loc_desc));
  END LOOP;
  RETURN;
END get_loc_lov;

-- select loc || ' - ' || loc_desc, loc from loc
-- select loc || ' - ' || loc_desc, loc FROM TABLE(get_loc_lov());
