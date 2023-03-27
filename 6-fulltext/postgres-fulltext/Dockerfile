FROM postgres:9.4

ENV POSTGRES_DB oz
ENV POSTGRES_HOST_AUTH_METHOD trust

ADD fulltext_data.sql /docker-entrypoint-initdb.d/
