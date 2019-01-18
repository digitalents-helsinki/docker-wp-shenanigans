#!/bin/bash
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Builds images and starts the containers specified in docker-compose.yaml file.
up_func() {
  echo -e "${BLUE}Building and starting containers...${NC}"
  docker-compose up -d --build
  docker-compose exec wordpress sh -c "chown -R www-data:www-data /var/www/html/*"
  echo -e "${GREEN}Done!${NC}"
}

# Stops and removes containers specified in docker-compose.yaml file.
down_func() {
  echo -e "${BLUE}Stopping and removing containers...${NC}"
  docker-compose down
  echo -e "${GREEN}Done!${NC}"
}

# Stops and removes both containers and volumes specified in docker-compose.yaml file.
down_volumes_func() {
  echo -e "${BLUE}Stopping and removing containers along with their respective volumes...${NC}"
  docker-compose down --volumes
  echo -e "${GREEN}Done!${NC}"
}

if [[ "$1" == up ]]; then
  # ./build.sh up
  up_func
  if [[ "$2" == linux ]]; then
    echo -e "${BLUE}Fixing Linux permissions${NC}"
    getent group www-data || groupadd www-data
    sudo chown -R $USER:www-data themes/ plugins/ sqldumps/ uploads/
  elif [[ "$2" == mac ]]; then
    echo -e "${GREEN}No extra steps needed, proceeding${NC}"
  fi
elif [[ "$1" == down ]]; then
  if [[ "$2" == volumes ]]; then
    # ./build.sh down volumes
    down_volumes_func
    sudo rm -r plugins/* themes/* uploads/*
  else
    # ./build.sh down 
    down_func
  fi
elif [[ "$1" == restart ]]; then
  if [[ "$2" == volumes ]]; then
    # ./build.sh restart volumes
    down_volumes_func
  else
    # ./build.sh restart
    down_func
  fi
  up_func
elif [[ "$1" == exportdb ]]; then
    DUMPDATE=$(date +%Y%m%d%H%M%S)
    echo -e "Creating Backup: wp_backup_${DUMPDATE}.sql"
    docker-compose exec db sh -c "mysqldump --all-databases > /backups/mysql/wordpress/wp_backup_${DUMPDATE}.sql -u root -p"
elif [[ "$1" == importdb ]]; then
    if [[ -z "$2" ]]; then
        echo -e "SQL-File was not specified. Try again."
    else
        echo -e "${BLUE}Trying to import database from $2${NC}"
        SQLFILE=$2
        docker-compose exec db sh -c "mysql -u root -p < /backups/mysql/wordpress/${SQLFILE}"
    fi
fi