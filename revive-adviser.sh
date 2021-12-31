#!/bin/bash

# build an image from Dockerfile
sudo docker container rm -f revive-adserver-sql revive-adserver
sudo docker rmi revive-adserver --force

docker build -t revive-adserver .

docker run -d --name revive-adserver -p 8000:80 revive-adserver
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

# Install Certbot
# sudo apt install certbot python3-certbot-nginx
sudo cp nginx/ads.conf /etc/nginx/sites-available/ads.golpages-cambodia.conf
sudo ln -s /etc/nginx/sites-available/ads.golpages-cambodia.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
sleep 5s
sudo certbot --nginx -d ads.golpages-cambodia.com
sudo systemctl reload nginx

echo "=========================="
echo "===== Done!! ======"
echo "=========================="
# docker run -d --name mysql-server -p 3306:3306 -e "MYSQL_ROOT_PASSWORD=gcp!@#" mysql