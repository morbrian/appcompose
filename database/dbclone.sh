#!/usr/bin/env bash

WORKSPACE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DBCLONE=dbclone.sql

echo "Clone database"
docker cp ${WORKSPACE}/${DBCLONE} database:/backup/${DBCLONE}
docker exec -it database bash -c "psql -Upostgres -f /backup/${DBCLONE}"

