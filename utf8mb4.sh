#!/bin/bash

# utf8mb4.sh [<charset> <collation>]
# changes MySQL/MariaDB charset and collation for civicrm database
# all tables prefixed with civicrm and all columns in those tables

DB="$CIVICRM_DATABASE"
CHARSET="$3"
COLL="$4"

[ -n "$DB" ] || exit 1
[ -n "$MYSQL_PASSWORD" ] || exit 1
[ -n "$CHARSET" ] || CHARSET="utf8mb4"
[ -n "$COLL" ] || COLL="utf8mb4_bin"

PW="--password=""$MYSQL_PASSWORD"

echo $DB
echo "ALTER DATABASE $DB CHARACTER SET $CHARSET COLLATE $COLL;" | mysql -u root -h vsql "$PW"
echo "USE $DB; SHOW TABLES LIKE 'civicrm_%';" | mysql -u root -h vsql -s "$PW" | (
    while read TABLE; do
        echo $DB.$TABLE
        echo "ALTER TABLE $TABLE CONVERT TO CHARACTER SET $CHARSET COLLATE $COLL;" | mysql -u root -h vsql "$PW" $DB
    done
)
