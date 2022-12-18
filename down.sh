#!/bin/bash
docker network rm moodle_network_local &
wait $!
cd main
docker-compose down -v &
wait $!
cd ..
cd db
docker-compose down -v &
wait $!