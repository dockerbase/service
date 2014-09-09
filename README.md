## Docker Base: Service


This repository contains **Dockerbase** of **Service** - a base service container for other services - for [Docker](https://www.docker.com/)'s [Dockerbase build](https://registry.hub.docker.com/u/dockerbase/service/) published on the public [Docker Hub Registry](https://registry.hub.docker.com/).


### Depends on:

* [ubuntu:14.04](https://registry.hub.docker.com/u/library/ubuntu/)


### Installation

1. Install [Docker](https://docs.docker.com/installation/).

2. Download [Dockerbase build](https://registry.hub.docker.com/u/dockerbase/service/) from public [Docker Hub Registry](https://registry.hub.docker.com/): `docker pull dockerbase/service`


### Usage

    docker pull dockerbase/service

    run:
        docker run --restart=always -t --cidfile cidfile -d dockerbase/service /sbin/runit

    start:
        docker start `cat cidfile`

    stop:
        docker stop -t 10 `cat cidfile`
