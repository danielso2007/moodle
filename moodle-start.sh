#!/bin/bash
cd main
docker-compose up -d &
wait $!