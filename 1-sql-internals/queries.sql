-- use explain to see query plan

explain select * from documents;

-- explain ommited from now on

select * from documents where supplier = 'SPP';
select * from documents where supplier = 'SPP' order by created_at desc;
select * from documents where supplier = 'SPP' order by created_at desc limit 10;

-- size on disk

SELECT relname, pg_size_pretty(pg_relation_size(oid)) AS "size" FROM pg_class where relname = 'documents';

-- rows per page

SELECT relname,round(reltuples / relpages) AS rows_per_page FROM pg_class WHERE relname='documents';

-- see low level stats after any query. Make sure to call pg_stat_reset() function to reset stats.

select pg_stat_reset();
select * from table_stats;

-- cost based optimizer costs

show seq_page_cost;
show random_page_cost;
show cpu_index_tuple_cost;

-- index size on disk

SELECT relname, pg_size_pretty(pg_relation_size(oid)) AS "size" FROM pg_class where relname = 'index_documents_on_type';

-- 3 queries, 3 query plans

create index index_documents_on_type on documents(type);
select * from documents where type = 'Egovsk::Appendix'; --index scan
select * from documents where type = 'Crz::Appendix'; -- bitmap idx scan & bitmap heap scan
select * from documents where type = 'Crz::Contract'; -- seq scan

select type, count(*)
from documents
group by type;

select type from documents where type = 'Egovsk::Appendix'; -- index only scan

--statisttics

select
tablename,attname,null_frac,avg_width,n_distinct,correlation,
most_common_vals,most_common_freqs,histogram_bounds
from pg_stats
where tablename='documents';

-- order by

select * from documents order by published_on asc;
select * from documents order by published_on desc;

create index index_documents_on_published_on on documents(published_on);

-- pipelined ordered by

drop index index_documents_on_published_on;

select * from documents order by published_on limit 10;

create index index_documents_on_published_on on documents(published_on);

select * from documents order by published_on limit 10;

-- modifications?

create index index_documents_on_supplier on documents(supplier);

select * from documents where supplier = 'SPP';
select * from documents where lower(supplier) = 'spp';

create index index_documents_on_lower_supplier on documents(lower(supplier));
