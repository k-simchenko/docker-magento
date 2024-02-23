#!/bin/sh
docker-compose up -d
docker-compose exec --user root php7.4 service ssh start
docker-compose exec --user root php7.4 git config --global --add safe.directory "*"
