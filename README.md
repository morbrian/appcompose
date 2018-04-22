# Development Workflow with Docker

This project sets up a suite of services representing a complete 3 tier web application running behind a TLS enabled proxy.

It is designed to create a production-like environment while easing the development process for a development team.

* Proxy - Nginx
* Database - PostgreSQL
* Backend Webserver - Tomcat
* Frontend Webserver - NodeJS (for develop

## Proxy

* Must be TLS enabled.
* Developers can build once locally, generating cert in the process.
* Use volume mounts if local system security constraints permit.
* Use Docker (Kitematic, etc...) to start stop.

Example of cert creation (for now we also included prepared self-signed cert)

        openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout localhost.key -out localhost.crt -subj "/C=US/ST=California/L=San Diego/O=sandbox/CN=localhost"

## Database

* Use crunchy container as baseline.
* Provide setup.sql to provide baseline database with schema.
* Assume this gets run once, and can handle multiple databases.
* Use volume mounts if local system security constraints permit.
* Use Docker (Kitematic, etc...) to start stop.

## Backend Webserver

* Pull from baseline container (uses Red Hat configured Tomcat)
* TODO: identify best way to pull war file into container.
    * docker build and COPY war each time?
    * can maven plugin help here?
* Local system security constraints general prevent direct access to the recently built target/war file.
* Typical start/stop procedure must include fresh war, perhaps implies a complete rebuild of container.
* Use Docker (Kitematic, etc...) to start stop.

## Frontend Webserver

* Assume development environment, nodejs server with auto-update.
* Container not required.
* Nginx must be able to redirect to this. 

## How to ignore environment files

In order to avoid accidental commit of the env files, configure git to locally
ignore these files in the cloned repository.

        git update-index --assume-unchanged *.env
        
If the need to commit these files ever arises, this can easily be undone with:

        git update-index --no-assume-unchanged *.env

## Docker Preparation

The compose file refers to several baseline containers that must be built ahead of time.

For example:

        # build proxy base from app-proxy folder
        docker build -t dev/proxy .
        
        # build webapp base, currently housed at src/main/docker subfolder of supported webapp
        cd src/main/docker
        docker build -t dev/backend .
        
        # also assumes webapp container with war file is already built
        # stored with webapp, next to pom.xml
        docker built -t app-backend .

## Docker Compose 

Requires docker version 17.06.0+ and docker-compose version 1.17+

Initial testing done with docker version 18.03.0-ce and docker-compose 1.21

Starting the container suite:

        docker-compose up
       
Updating a single container, using backend as example:

       docker compose stop backend
       docker-compose up -d --no-deps backend

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
