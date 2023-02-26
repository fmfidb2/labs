# Lab 2 - Multicolumn Indices, Joins & Aggregations

Grading: 2pt

## Setup

Use `fiitpdt/postgres` container for this lab. Instructions are included in the Lab #1.

If you want to try the queries from the lecure (optional), you will need another container.

```
docker run -p 5432:5432 fiitpdt/postgres-shakespeare
```

The database with example data is called `shakespeare`, username is `postgres`, password is blank (there is no password). To connect via `psql`, use:

```
psql -U postgres -h localhost -p 5432 -d shakespeare
```

## 1. See how `like` with a leading pattern is slow

Your users need to search documents (`documents` table) by supplier ICO (`supplier_ico` column).
They often remember the last few digits of the ICO they want to search, and thus
they want to be able to enter a `supplier_ico` suffix and find matching
documents. The length of the suffix which they use will vary, so you can't rely on it.

E.g., they enter 5733 and want to find documents for ICO 36565733.

You first come up with a naive query which uses `like` with a leading pattern, e.g. `supplier_ico like '%5733'`.

You quickly find out that is slow (go ahead, try it).

You try to add an index but find out that is makes no difference (go ahead, try it).

Think about it. Why didn't the index help?

(Make sure you create the index for `LIKE` using `text_pattern_ops`, see http://www.postgresql.org/docs/9.4/static/indexes-opclass.html for details.)


## 2. Try `like` with a trailing pattern

Given the index you created, try searching with a prefix string and a trailing pattern, e.g., `supplier_ico like '57%'`.
Make sure that the index was created with `text_pattern_ops` options or it won't be used.

Measure how long the query takes with index and without index.

Have a look at the query plan and notice the *Index Cond* part. How can you
interpret this condition? Try giving different inputs and observe how the like
query gets rewritten to a range query. You can run `explain` even with
nonsensical inputs, e.g. `supplier_ico like 'Ahoj%'` and you will still see how
the planner rewrites the like condition.

## 3. Make the suffix search fast

There is a trick that you can use to make the original suffix query fast. If
you reverse both the supplier_ico and the input, you can transform the slow
suffix search into fast prefix search.

Hint:
- Use a functional index
- Use `reverse` function - https://www.postgresql.org/docs/9.4/functions-string.html

## 4. Optional: Learn more about indexing `like '%x%'` queries

If you want to understand how to properly index `LIKE '%x%'` expressions (and the trade-offs), read

- http://www.depesz.com/2011/02/19/waiting-for-9-1-faster-likeilike/
- http://www.postgresql.org/docs/9.4/static/pgtrgm.html

## 5. Understand covering index

One of the scenarios that your application supports, is showing a list of
customers (`customer` column) for a specific department (`department` column).

You are using this query (the department name is entered by the user):

```sql
select customer from documents where
department = 'Rozhlas a televizia Slovenska';
```

Try building an index on the condition that you need (i.e., index on `deparment` column). Measure how fast is the query without and with this index.

Build a covering index on `department, customer`. Is the query faster now?
Make sure that the covering index is used and that you see an Index-only scan.

## 6. Optional: Try the queries from the lecture

Try the queries presented in the lecture and observe their plans.

- [`queries.sql`](queries.sql)
