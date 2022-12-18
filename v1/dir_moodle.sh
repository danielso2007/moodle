#docker container exec $(docker ps --filter name=moodle-moodle -q) ls -l /
docker exec -i -t moodle-moodle-1 /bin/bash