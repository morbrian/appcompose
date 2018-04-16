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

## Docker Compose / Stack / Swarm

Docker compose supports compose file format 2.x and earlier.

Docker stack (built into docker) supports 3.x and later.

Docker stack is built in, but was inherity from docker swarm in the docker 1.12 release.

Getting started with Stack / Swarm:

        # first time using, machine won't be a swarm manager so must init
        docker swarm init
        # or if multiple interfaces / ips
        docker swarm init --advertise-addr 127.0.0.1
        
        # run the stac
        docker stack deploy -c docker-compose.yml SOME_NAME
        
        # list the stack
        docker stack ps SOME_NAME
