#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE ROLE nseuserrole WITH LOGIN ENCRYPTED PASSWORD 'changeit' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION VALID UNTIL 'infinity';
    CREATE USER nseuser WITH PASSWORD 'changeit';
    GRANT nseuserrole TO nseuser;
    CREATE DATABASE nsedb OWNER nseuser;
EOSQL


psql -v ON_ERROR_STOP=1 --username "nseuser" --dbname "nsedb" <<-EOSQL
    GRANT ALL PRIVILEGES ON DATABASE nsedb TO nseuserrole;
    GRANT ALL ON ALL TABLES IN SCHEMA public TO nseuserrole;
    GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO nseuserrole;
    CREATE TABLE eqnse ( SYMBOL character varying (150), SERIES	character varying (15), OPEN decimal, HIGH decimal, LOW decimal, CLOSE decimal, LAST decimal, PREVCLOSE decimal, TOTTRDQTY decimal, TOTTRDVAL decimal, MKTDATE date, TOTALTRADES decimal, ISIN character varying (40), CONSTRAINT ISIN_DATE PRIMARY KEY(MKTDATE,SERIES,ISIN) );
    CREATE TABLE priceslope (EQNAME character varying (300),SLOPE decimal);  		
    CREATE TABLE volumeslope (EQNAME character varying (300),SLOPE decimal);
    \copy eqnse FROM '/tmp/consolidated.csv' DELIMITER ',' CSV
EOSQL
