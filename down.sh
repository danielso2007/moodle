#!/bin/bash
cd main
docker-compose down -v &
wait $!
cd ..
cd db
docker-compose down -v &
wait $!
cd ..
cd proxy
docker-compose down -v &
wait $!
docker network rm moodle_network_local &
wait $!