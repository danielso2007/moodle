#!/bin/bash
cd main
docker-compose stop &
wait $!
cd ..
cd db
docker-compose stop &
wait $!
cd ..
cd proxy
docker-compose stop &
wait $!