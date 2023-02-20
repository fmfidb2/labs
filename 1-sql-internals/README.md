# Lab 1 - Query plans & indexing

**Grading**: 1pt

## Goals

- Install docker and run the provided container. Configure an SQL client of your choice and connect to the database.
- Try indexes and see for yourself how they can make a query faster
- Measure how much indexes slow down writes

## 1. Setup

Before you run the following command, make sure that another instance of PostgreSQL is not running and stop it if needed. Many Linux distribution include a preinstalled instance of PostgreSQL which is running by default.

If you get error like `Bind for 0.0.0.0:5432 failed: port is already allocated.` then there is another instance of PostgreSQL running and you need to stop it first. For example: `service postgresql stop`.


Start the container:

````
docker run -p 5432:5432 fiitpdt/postgres
````

This will initialize postgres and seed it with example data. It will take a while, but eventually, the output will stop with

````
LOG:  database system is ready to accept connections
LOG:  autovacuum launcher started
````

You can now connect to postgresql server running on localhost:5432 using your client of choice.
- (Free) A command line `psql` client. Connect via `psql -U postgres -h localhost -p 5432 -d oz`.
- (Free) PgAdmin https://www.pgadmin.org/
- (Paid, with academic license) Datagrip https://www.jetbrains.com/datagrip/ (apply for academic license here https://www.jetbrains.com/student/)

The database with example data is called `oz`, username is `postgres`, password is blank (there is no password).

## 2. Try how indexes make a query faster

- Write a simple query filtering on a single column (e.g. `supplier = ''`, or `department = ''`). Measure how long the query takes.
- Add an index for the column and measure how fast is the query now. What plan did the database use before & after index?
- Write a simple range query on a single column (e.g., `total_amount > 100000 and total_amount <= 999999999`). Measure how long the query takes.
- Add an index for the column and measure how fast is the query now. What plan did the database use before & after index?

Hints:
- Many clients report query duration. Alterntively, use `explain analyze select ...` to get a measurement.
- Don't trust a single measurement. Repeat measurements N times, remove outliers and use average/median.

## 3. Try how indexes slow down writes

- Drop all indexes on the `documents` table
- Benchmark how long does it take to insert a batch of N rows into the `documents` table.
- Create index on a single column in the `documents` table. Choose an arbitrary column.
- Benchmark how long does it take to insert a batch of N rows now. How much slower is the insert now?
- Repeat the benchmark with 2 indices and 3 indices.
- Now drop all indices and try if there's a difference in insert performance when you have a single index over low cardinality column vs. high cardinality column.

Hints:
- Based on your machine and the data you are inserting, you may need to tune the N (number of rows in batch) to get meaningful sensitivity.
- You can use the `insert into documents() (select from documents limit N)` pattern to quickly insert a batch of rows.
- Many clients report query duration. Alterntively, use `explain analyze insert into ...` to get a measurement.
- Don't trust a single measurement. Repeat measurements N times, remove outliers and use average/median.

## 4. Optional: Try the queries from the lecture

Try the queries presented in the lecture. There are some queries that were not presented in the lecture which can help you better understand database internals, e.g. the `table_stats` view.

- [`queries.sql`](queries.sql)
