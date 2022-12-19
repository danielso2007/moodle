#!/bin/bash
docker-compose logs moodle_db &
wait $!