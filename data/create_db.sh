#!/bin/sh

# for each file in sql directory, run the sql file
for sql_file in /data/sql/*.sql
do
    echo "Running $sql_file"
    /opt/mssql-tools18/bin/sqlcmd -S $DB_HOST,$DB_PORT -U $DB_UID -P $DB_PWD -C -i $sql_file
done
