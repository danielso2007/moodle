#!/bin/bash
cd db
docker-compose logs moodle_db &
wait $!