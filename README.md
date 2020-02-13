# Govin

Easily import vndb dump data into local dockerized postgres.

## Prerequisites

* docker
* postgres-client
* [zstd](https://github.com/facebook/zstd)
* wget, tar, sleep, mkdir, rm (commonly installed in most linux distributions already)

## Dump database content from VNDB

Run `make`. This will download https://dl.vndb.org/dump/vndb-db-latest.tar.zst, create a docker container based on `postgres:11` image, then import the data from the downloaded archive into the database.

To connect to the database, here are the parameters:

```
PGHOST=localhost
PGPORT=54320
PGUSER=govin_db_user
PGPASSWORD=govin_db_password
```

Note that running `make` again will recreate the database from scratch.
