select * from contracts 
where lower(name) like '%oracle%'
or lower(supplier) like '%oracle%'

-- oracle socialna poistovna

select * from contracts
where to_tsvector(name) @@ to_tsquery('oracle');


select to_tsvector(name), to_tsquery('oracle') from contracts where id = 88872
select to_tsvector('oracle oracle why you so expensive?'), to_tsquery('oracle')

select ts_debug('oracle oracle why you so expensive?')

select to_tsvector('simple', 'oracle oracle why you so expensive?'), to_tsquery('simple', 'oracle')

select * from contracts
where to_tsvector('simple', name) @@ to_tsquery('oracle'); -- no results

select * from contracts
where to_tsvector('simple', name) @@ to_tsquery('simple', 'oracle');

select * from contracts
where to_tsvector('simple', name || ' ' || department || ' ' || customer || ' ' || supplier) @@ to_tsquery('simple', 'oracle');

create index index_contracts_ft on contracts using gin(to_tsvector('simple', name || ' ' || department || ' ' || customer || ' ' || supplier))

select to_tsquery('simple', 'oracle & socialna')

select * from contracts
where to_tsvector('simple', name || ' ' || department || ' ' || customer || ' ' || supplier) @@ to_tsquery('simple', 'oracle & sociálna & poisťovňa');

create extension unaccent;

SELECT unaccent('unaccent', 'ľaľa tu beží teľa');

drop index index_contracts_ft;


create text search configuration sk(copy = simple);
alter text search configuration sk alter mapping for word with unaccent, simple;

select to_tsvector('sk', 'ľaľa tu beží teľa')

create index index_contracts_ft on contracts using gin(to_tsvector('sk', name || ' ' || department || ' ' || customer || ' ' || supplier))

select * from contracts
where to_tsvector('sk', name || ' ' || department || ' ' || customer || ' ' || supplier) @@ to_tsquery('sk', 'oracle & socialna & poistovna');


select ts_rank_cd(to_tsvector('sk', name || ' ' || department || ' ' || customer || ' ' || supplier), to_tsquery('sk', 'oracle')) rank, * from contracts
where to_tsvector('sk', name || ' ' || department || ' ' || customer || ' ' || supplier) @@ to_tsquery('sk', 'oracle')
order by rank desc;
