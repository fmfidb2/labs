FROM postgres:9.4

ENV POSTGRES_DB pdt
ENV POSTGRES_HOST_AUTH_METHOD trust

ADD recursive_data.sql /docker-entrypoint-initdb.d/
