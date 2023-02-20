FROM postgres:9.3

ENV POSTGRES_DB oz

ADD oz.sql.gz /docker-entrypoint-initdb.d/
RUN gunzip /docker-entrypoint-initdb.d/oz.sql.gz
