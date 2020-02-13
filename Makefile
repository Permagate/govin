PGHOST ?= localhost
PGPORT ?= 54320
PGDATABASE ?= govin_db
PGUSER ?= govin_db_user
PGPASSWORD ?= govin_db_password

PREREQUISITES = docker-compose psql zstd wget tar sleep mkdir rm

.PHONY: setup
setup: check-prerequisites teardown dirs dump docker-compose-up import

.PHONY: teardown
teardown: clean docker-compose-down

.PHONY: check-prerequisites
check-prerequisites:
	@for exec in $(PREREQUISITES); \
	do \
		echo Checking if $$exec is executable...; \
		which $$exec && true || exit 1 \
	; done

.PHONY: dirs
dirs:
	mkdir -p tmp/vndb-db-latest

.PHONY: clean
clean:
	rm -rf tmp

.PHONY: docker-compose-up
docker-compose-up:
	docker-compose up -d
	sleep 3 # Wait until the database is ready to connect to

.PHONY: docker-compose-down
docker-compose-down:
	docker-compose down

tmp/vndb-db-latest.tar.zst:
	wget -O $@ https://dl.vndb.org/dump/vndb-db-latest.tar.zst

.PHONY: dump
dump: tmp/vndb-db-latest.tar.zst
	tar -I zstd --overwrite -xvf tmp/vndb-db-latest.tar.zst -C tmp/vndb-db-latest

.PHONY: import
import:
	cd tmp/vndb-db-latest && \
		PGHOST=$(PGHOST) PGPORT=$(PGPORT) PGDATABASE=$(PGDATABASE) PGUSER=$(PGUSER) PGPASSWORD=$(PGPASSWORD) psql -f import.sql
