-- =======================
-- Multicolumn indexes
-- use fiitpdt/postgres
-- =======================

create index index_documents_on_stp on documents(supplier, total_amount, published_on);

explain select * from documents where supplier = 'SPP';
explain select * from documents where supplier = 'SPP' and total_amount = 2000;
explain select * from documents where supplier = 'SPP' and total_amount = 2000 and published_on = now();

-- non-leading column

explain select * from documents where total_amount = 2000
explain select * from documents where total_amount = 2000 and published_on = now()

-- benchmark

select * from documents where total_amount = 2000 and published_on > '2012-01-01';

SET enable_indexscan = off;
SET enable_bitmapscan = off;

select * from documents where total_amount = 2000 and published_on > '2012-01-01';

-- http://www.postgresql.org/docs/9.3/static/indexes-multicolumn.html
-- A multicolumn B-tree index can be used with query conditions that involve any subset of the index's columns, 
-- but the index is most efficient when there are constraints on the leading (leftmost) columns. 
-- The exact rule is that equality constraints on leading columns, plus any inequality constraints on the first column 
-- that does not have an equality constraint, will be used to limit the portion of the index that is scanned. 
-- Constraints on columns to the right of these columns are checked in the index, so they save visits to the table proper, 
-- but they do not reduce the portion of the index that has to be scanned. For example, given an index on (a, b, c) 
-- and a query condition WHERE a = 5 AND b >= 42 AND c < 77, the index would have to be scanned from the first entry 
-- with a = 5 and b = 42 up through the last entry with a = 5. Index entries with c >= 77 would be skipped, 
-- but they'd still have to be scanned through. This index could in principle be used for queries that have constraints on b 
-- and/or c with no constraint on a — but the entire index would have to be scanned, so in most cases the planner would 
-- prefer a sequential table scan over using the index.

SET enable_indexscan = on;
SET enable_bitmapscan = on;

drop index index_documents_on_stp;

-- separate index per column

create index index_documents_on_supplier on documents(supplier);
create index index_documents_on_total_amount on documents(total_amount);
create index index_documents_on_published_on on documents(published_on);

explain select * from documents where supplier = 'SPP';
explain select * from documents where supplier = 'SPP' and total_amount = 2000;
explain select * from documents where supplier = 'SPP' or total_amount = 2000 and published_on > '2013-01-01';

-- covering index

create index index_documents_on_dc on
documents(department, customer);

vacuum analyze; -- update planner statistics

explain select customer from documents where
department = 'Rozhlas a televizia Slovenska';


-- =======================
-- Joins
-- use fiitpdt/postgres-shakespeare
-- =======================

-- nested loop:
set enable_hashjoin=off;

explain select * from character c
   join paragraph p on p.charid = c.charid;

-- hash join:

set enable_hashjoin=on;

explain select * from paragraph p
   join character c on p.charid = c.charid;

-- merge join

create index idx_paragraph_on_charid on paragraph(charid);

set enable_hashjoin=on;

explain select * from paragraph a
   join wordform b on a.paragraphid = b.wordformid

-- multi join
explain select *
   from character c
   join character_work cw on c.charid = cw.charid
   join work w on w.workid = cw.workid

-- left/right join

explain select * from paragraph p
   left join character c on p.charid = c.charid


-- =======================
-- Aggregations
-- use fiitpdt/postgres
-- =======================

-- hashaggregate
explain select department, count(*) from
documents group by department;

-- groupaggregate

create index index_documents_on_dc on documents(department, customer);

vacuum analyze; -- manually update planner statistics

explain select customer, count(*) from documents
where department = 'Rozhlas a televizia Slovenska' group by customer;
