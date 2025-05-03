#!/bin/ksh

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <TNS_ALIAS> <OUTPUT_DIR>"
  exit 1
fi

TNS_ALIAS="$1"
OUTPUT_DIR="$2"

mkdir -p "$OUTPUT_DIR"

# extract data for a specific location
extract_data_for_location() {
    local location=$1
    local output_file="${OUTPUT_DIR}/item_loc_soh_${location}.csv"

    sqlplus -S /@"${TNS_ALIAS}" <<EOF
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET TRIMSPOOL ON
SET COLSEP ','
SPOOL ${output_file}
SELECT ITEM, DEPT, UNIT_COST, STOCK_ON_HAND, (UNIT_COST * STOCK_ON_HAND) AS STOCK_VALUE
FROM ITEM_LOC_SOH
WHERE LOC = '${location}';
SPOOL OFF;
EOF
}

# list of distinct locations
locations=$(sqlplus -S /@"${TNS_ALIAS}" <<EOF
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SELECT DISTINCT LOC FROM ITEM_LOC_SOH;
EOF
)

# parallel extraction
for location in $locations; do
    extract_data_for_location "$location" &
done

wait

echo "Data extraction completed for all locations."

exit 0
