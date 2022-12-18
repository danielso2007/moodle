#!/bin/bash
cd db
docker-compose down -v &
wait $!