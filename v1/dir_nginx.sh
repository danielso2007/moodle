# docker container exec $(docker ps --filter name=moodle-nginx -q) ls -l /
docker exec -ti moodle-nginx-1 /bin/bash