#!/usr/bin/env bash

WORKSPACE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DBINIT=dbinit.sql
POSTINIT=postinit.sql
DBDATA_FILE=testdata.dump
DBDATA=~/dumps/${DBDATA_FILE}
BASELINE=testbaseline

echo "Initialize Database"
docker cp ${WORKSPACE}/${DBINIT} database:/backup/${DBINIT}
docker exec -it database bash -c "psql -Upostgres -f /backup/${DBINIT}"

#
# uncomment to load sample data from dumpfile as part of in initialization
#
#echo "Loading ${BASELINE} from file ${DBDATA}"
#docker cp ${DBDATA} database:/backup/${DBDATA_FILE}
#docker exec -it database bash -c "pg_restore -Upostgres -d${BASELINE} /backup/${DBDATA_FILE}"

echo "Assign Priveleges to baseline Database"
docker cp ${WORKSPACE}/${POSTINIT} database:/backup/${POSTINIT}
docker exec -it database bash -c "psql -Upostgres -d${BASELINE} -f /backup/${POSTINIT}"

