#!/bin/bash

# build an image from Dockerfile
docker build -t revive-adserver .

docker run -d --name revive-adviser -p 80:80 revive-adviser
echo "=========================="
echo "===== Wait a moment ======"
echo "=========================="
sleep 4s
# prepare a directory for mounting mysql data
export MOUNTING=$HOME/revive-adserver-data
sudo mkdir -p $MOUNTING

# mounting the previous directory to sql data 
docker run \
--detach \
--name=revive-adserver-sql \
--env="MYSQL_ROOT_PASSWORD=gpt123" \
--publish 6606:3306 \
--volume=/root/docker/revive-adserver-sql/conf.d:/etc/mysql/conf.d \
--volume=$MOUNTING:/var/lib/mysql \
mysql

echo "=========================="
echo "===== Done!! ======"
echo "=========================="
# docker run -d --name mysql-server -p 3306:3306 -e "MYSQL_ROOT_PASSWORD=gcp!@#" mysql