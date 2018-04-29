# appcompose

This project provides a simple docker-compose example of running a basic 3 tier web application 
with separate frontend, backend and database containers behind a proxy.

It is designed to mimic a production-like environment while easing the development process for a development team.

* proxy - Nginx
* simplewar - Simple content deployed as war to Tomcat (path /)
* jdbcwar - Application with database acesss  deployed as war to Tomcat (path /jdbcwar)
* database - PostgreSQL

## proxy

Example of cert creation (for now we also included prepared self-signed cert)

        openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout localhost.key -out localhost.crt -subj "/C=US/ST=California/L=San Diego/O=sandbox/CN=localhost"

Clone and build the base container for the proxy:

        git clone https://github.com/morbrian/vagrant-nginx.git 
        cd vagrant-nginx
        docker build -t morbrian/nginxbase .

Build the final proxy with local customizations from this appcompose repository:

        docker build -t dev/proxy proxy

After the initial build, the most effective way to update with changes from appcompose is:

        # If the base container is changed, then that must be built and updated first with the build from vagrant-nginx.
        docker rm -f proxy && docker build --force-rm -t dev/proxy proxy && docker-compose up -d --force-recreate proxy 


## simplewar

Clone and build the simple war to a clean directory:

        git clone https://github.com/morbrian/simplewar.git 
        cd simplewar
        mvn clean package docker:build

After the initial build, the most effective way to update is:

        docker rm -f simplewar && docker build --force-rm -t dev/simplewar simplewar && docker-compose up -d --force-recreate simplewar

        
## jdbcwar

Clone and build the jdbc war to a clean directory:

        git clone https://github.com/morbrian/jdbcwar.git 
        cd jdbcwar
        mvn clean package docker:build

After the initial build, the most effective way to update is:

        docker rm -f jdbcwar && docker build --force-rm -t dev/jdbcwar jdbcwar && docker-compose up -d --force-recreate jdbcwar

 
## environment 

Update the environment variables under the `./env` folder. Recommend changing passwords, otherwise defaults are ok.

In order to avoid accidental commit of the env files, configure git to locally
ignore these files in the cloned repository.

        git update-index --assume-unchanged env/*.env
        
If the need to commit these files ever arises, this can easily be undone with:

        git update-index --no-assume-unchanged env/*.env


## docker-compose 

Requires docker version 17.06.0+ and docker-compose version 1.17+

Initial testing done with docker version 18.03.0-ce and docker-compose 1.21

Starting the container suite:

        docker-compose up
       
Updating a single container, using proxy as example:

       docker rm -f proxy && docker build --force-rm -t dev/proxy proxy && docker-compose up -d --force-recreate proxy


## database

Uses crunchydata container as baseline.

After compose starts services, optionally initalize a testdb with data.

        # create a baseline database (testbaseline)
        bash database/dbinit.sh
  
        # clone the testbaseline to a new databasde called 'testdb'
        bash database/dbclone.sh

Later, only `dbclone.sh` is required and will drop `testdb`, creating a fresh unmodified copy from `testbaseline`.

## verify installation

Running docker-compose will show logs output the screen.

In another terminal, verify the expected containers are running:

        docker ps --format={{.Names}}

        # expected output
        database
        simplewar
        jdbcwar
        proxy

Verify containers are accessible as expected:

        # verify webapps are accessible through proxy
        # expect response code 200 and content of index.html from each war.
        curl -v -k https://localhost:443/jdbcwar
        curl -v -k https://localhost:443/

        # verify database is directly accessible
        # expect list of data in table
        docker exec -it database bash -c "psql -Upostgres -dtestdb -c 'select * from sample;'"

## container management

The docker containers are initialized with long-lasting volumes the first time compose starts.

Most of the time it will be desirable to accept this initial configuration and avoid 
starting over with emtpy volumes, however on occasions when a clean slate is needed
the following commands will help.

The example commands below remove all related containers and volumes,
however it is also possible to just delete a targeted subset of the containers.

        docker rm database pgadmin backend proxy bench
        docker volume rm appcompose_pgadmin appcompose_pgdata appcompose_testdata
        
## pgadmin4

Connect to pgadmin4 at: http://localhost:5050        

Use login information as specified in pgadmin.env at initialization time.

Create a new connection.

Right click *Servers* choose *Create Server*

General Tab:

  * Name: compose-app

Connection Tab:

  * Host: database
  * Username: configured in database.env (postgres is the root user)
  * Password: configured in database.env 
  
## Docker Stack

Docker stack/swarm supports a number of useful options such as config files
and scaling, however it is more difficult to use for development purposes.

The steps below are mainly notes, and are no longer tested with the included compose file.

Getting started with Stack / Swarm:

        # first time using, machine won't be a swarm manager so must init
        docker swarm init
        # or if multiple interfaces / ips
        docker swarm init --advertise-addr 127.0.0.1
        
        # run the stac
        docker stack deploy -c docker-compose.yml SOME_NAME
        
        # list the stack
        docker stack ps SOME_NAME
