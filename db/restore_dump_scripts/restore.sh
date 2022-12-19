#!/bin/bash
RED='\033[1;31m'
BLACK='\033[0;30m'
DARK_GRAY='\033[1;30m'
LIGHT_RED='\033[0;31m'
GREEN='\033[0;32m'
LIGHT_GREEN='\033[1;32m'
BROWN_ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
LIGHT_BLUE='\033[1;34m'
PURPLE='\033[0;35m'
LIGHT_PURPLE='\033[1;35m'
CYAN='\033[0;36m'
LIGHT_CYAN='\033[1;36m'
LIGHT_GRAY='\033[0;37m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
VALID=true
set -e

if [[ -z "$1" ]]; then
    echo -e "${RED}Usage:${NC} ${LIGHT_RED}./restore.sh [FILE]${NC}"
    exit 0
fi

docker exec -it db_moodle psql -U moodle -c "CREATE ROLE postgres WITH LOGIN SUPERUSER ENCRYPTED PASSWORD 'postgres'"

username="moodle"
senha="123456"
db="moodle"
port="5432"
host="localhost"
file="dump.dmp"
docker="db_moodle"
owner="moodle"
prefixfile="dump-"
file="${prefixfile}$(date +%Y%m%d).dmp"

# Senha do root quando executado localmente
# export PGPASSWORD=postgres

echo -e "${YELLOW}Database restore:${NC}"
echo -e "${YELLOW}Default docker:${NC} ${LIGHT_PURPLE}$docker${NC}"
echo -e "${YELLOW}Username:${NC} ${LIGHT_PURPLE}${username}${NC}"
echo -e "${YELLOW}Password:${NC} ${LIGHT_PURPLE}${senha}${NC}"

if [[ -z "$1" ]]; then
    echo -e "${RED}File default:${NC} ${LIGHT_PURPLE}$db${NC}"
else
    file=${prefixfile}$1.dmp
    echo -e "${YELLOW}File:${NC} ${LIGHT_PURPLE}${prefixfile}$1.dmp${NC}"
fi

# Copiar o arquivo de dump para entro do volume do docker.
echo -e "${YELLOW}Copying file to dump folder...${NC}"
echo -e "${BLUE}If there is an error copying the file, check the permission of the ./dump folder${NC}"
cp "$file" ../dump/"$file"

echo -e "${YELLOW}Port:${NC} ${LIGHT_PURPLE}${port}${NC}"
echo -e "${YELLOW}Host:${NC} ${LIGHT_PURPLE}${host}${NC}"
# echo -e "${YELLOW}Export PGPASSWORD:${NC} ${LIGHT_PURPLE}${PGPASSWORD}${NC}"
echo -e "${YELLOW}Disconnecting all users and DROP / CREATE from the pack:${NC} ${LIGHT_PURPLE}$db${NC}"

# Apagando os processo e banco de dados para criar um novo.
docker exec -i $docker psql -U postgres <<EOF
update pg_database set datallowconn = 'false' where datname = '$db';
SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '$db' AND pid <> pg_backend_pid();
DROP DATABASE IF EXISTS "$db";
CREATE DATABASE "$db" WITH OWNER ${owner} ENCODING 'UTF-8' TEMPLATE template0;
update pg_database set datallowconn = 'true' where datname = '$db';
EOF

# Restaura o dump do banco
echo -e "${YELLOW}Restoring database...${NC}"
docker exec -i $docker psql -q -U $username -d "$db" -f /opt/dump/"$file"
