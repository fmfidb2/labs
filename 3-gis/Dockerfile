FROM mdillon/postgis:9.4

ENV POSTGRES_DB gis

ADD osm_ba.sql.gz /docker-entrypoint-initdb.d/
RUN gunzip /docker-entrypoint-initdb.d/osm_ba.sql.gz
