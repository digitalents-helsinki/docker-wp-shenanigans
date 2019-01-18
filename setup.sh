#!/bin/bash

docker-compose up -d --build
docker-compose exec wordpress sh -c "chown -R www-data:www-data /var/www/html/*"
if [ $1 == "linux" ]
then
    echo "Checking if www-data group already exists and if not -> let's make some to satisfy docker shite"
    getent group www-data || groupadd www-data
fi
sudo chown -R $USER:www-data themes/ plugins/ sqldumps/ uploads/