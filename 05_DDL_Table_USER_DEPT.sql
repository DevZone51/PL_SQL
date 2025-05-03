--- 01 - USERS Table
CREATE TABLE users(
  username varchar2(50) not null,
  firstname varchar2(45) not null,
  lastname varchar2(45) not null
);
--
ALTER TABLE users
ADD CONSTRAINT pk_users PRIMARY KEY (username);


-- 02 - DEPT TABLE
CREATE TABLE DEPT(
  dept number(4) not null,
  dept_name varchar2(45) not null
);

ALTER TABLE DEPT
ADD CONSTRAINT pk_dept PRIMARY KEY (dept);

CREATE INDEX idx_dept_name ON dept (dept_name);

-- 02 - USER_DEPT table
CREATE TABLE user_dept(
  username varchar2(50) not null,
  dept number(4) not null,
  create_date DATE not null
);

ALTER TABLE user_dept
ADD CONSTRAINT pk_user_dept PRIMARY KEY (username,dept);

ALTER TABLE user_dept
ADD CONSTRAINT fk_ud_user FOREIGN KEY (username)
REFERENCES users(username);

ALTER TABLE user_dept
ADD CONSTRAINT fk_ud_dept FOREIGN KEY (dept)
REFERENCES dept(dept);


--05 - ITEM_LOC_SOH_EOD

create table item_loc_soh(
  item varchar2(25) not null,
  loc number(10) not null,
  dept number(4) not null,
  unit_cost number(20,4) not null,
  stock_on_hand number(12,4) not null,
  stock_value number(20,4) not null,
  create_datetime DATE
);
