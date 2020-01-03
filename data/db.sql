CREATE DATABASE nsedb;
		CREATE DATABASE
		postgres=# CREATE ROLE nseuser WITH LOGIN ENCRYPTED PASSWORD 'INSERT_PWD' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION VALID UNTIL 'infinity';
		CREATE ROLE
		postgres=# GRANT ALL ON DATABASE nsedb TO nseuser;
		GRANT

		nsedb=# ALTER DATABASE nsedb OWNER TO nseuser;
		ALTER DATABASE

		nsedb=# GRANT SELECT ON ALL TABLES IN SCHEMA public TO nseuser;
		GRANT
		nsedb=# GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO nseuser;
		GRANT


		GRANT ALL ON ALL TABLES IN SCHEMA public TO nseuser;


Create Table:
		create table eqnse (
		SYMBOL character varying (150),
		SERIES	character varying (15),
		OPEN decimal,
		HIGH decimal,
		LOW decimal,
		CLOSE decimal,
		LAST decimal,
		PREVCLOSE decimal,
		TOTTRDQTY decimal,
		TOTTRDVAL decimal,
		MKTDATE date,
		TOTALTRADES decimal,
		ISIN character varying (40),
		CONSTRAINT ISIN_DATE PRIMARY KEY(MKTDATE,SERIES,ISIN)
		);


		create table priceslope (
		EQNAME character varying (300),
		SLOPE decimal
		);

		create table volumeslope (
		EQNAME character varying (300),
		SLOPE decimal
		);


nsedb=# \d
		                  List of relations
		 Schema |         Name          |   Type   |  Owner
		--------+-----------------------+----------+----------
		 public | eqnse                 | table    | postgres
		 public | eqnse_close_seq       | sequence | postgres
		 public | eqnse_high_seq        | sequence | postgres
		 public | eqnse_last_seq        | sequence | postgres
		 public | eqnse_low_seq         | sequence | postgres
		 public | eqnse_open_seq        | sequence | postgres
		 public | eqnse_prevclose_seq   | sequence | postgres
		 public | eqnse_totaltrades_seq | sequence | postgres
		 public | eqnse_tottrdqty_seq   | sequence | postgres
		 public | eqnse_tottrdval_seq   | sequence | postgres
		(10 rows)

nsedb=# \dt
		         List of relations
		 Schema | Name  | Type  |  Owner
		--------+-------+-------+----------
		 public | eqnse | table | postgres
		(1 row)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Importing CSV files:
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Actual Execution:
	nsedb=# \copy eqnse FROM '/var/lib/postgresql/data/01Jan-13Apr.csv' DELIMITER ',' CSV


Examples:
	\copy eqnse FROM '/var/lib/postgresql/data/01Jan-13Apr.csv' DELIMITER ',' CSV
	\copy zip_codes(ZIP,CITY,STATE) FROM '/path/to/csv/ZIP_CODES.txt' DELIMITER ',' CSV
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Queries:
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select distinct ISIN||SERIES as EQNAME, MKTDATE from eqnse where MKTDATE BETWEEN '2018-02-01' and '2018-02-05' order by MKTDATE;

select ISIN||SERIES as EQNAME, HIGH, TOTTRDQTY, MKTDATE from eqnse where MKTDATE BETWEEN '2018-02-01' and '2018-02-05' order by MKTDATE;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------