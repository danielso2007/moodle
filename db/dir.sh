#!/bin/bash
docker container exec $(docker ps --filter name=moodle-moodle_db -q) ls -l /