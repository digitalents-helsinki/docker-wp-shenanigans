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
elif [[ "$1" == down ]]; then
  if [[ "$2" == volumes ]]; then
    # ./build.sh down volumes
    down_volumes_func
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
fi