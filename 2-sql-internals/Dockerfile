FROM postgres:9.3

ENV POSTGRES_DB shakespeare

ADD shakespeare.sql.gz /docker-entrypoint-initdb.d/
RUN gunzip /docker-entrypoint-initdb.d/shakespeare.sql.gz
