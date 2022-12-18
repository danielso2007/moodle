#!/bin/bash
cd main
docker-compose down -v &
wait $!