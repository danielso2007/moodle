#!/bin/bash
docker network create --driver=bridge --subnet=15.28.0.0/16 --ip-range=15.28.5.0/24 --gateway=15.28.5.254 moodle_network_local &
wait $!
cd db
docker-compose up -d &
wait $!
cd ..
cd main
docker-compose up -d &
wait $!