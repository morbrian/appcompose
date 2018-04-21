#!/usr/bin/env bash

WORKSPACE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DBINIT=dbinit.sql

docker cp ${WORKSPACE}/${DBINIT} database:/backup/${DBINIT}
docker exec -it database bash -c "psql -Upostgres -f /backup/${DBINIT}"




