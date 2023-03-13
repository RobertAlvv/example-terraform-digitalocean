#!/bin/bash

sudo apt-get update -y
sudo apt install git -y
git clone https://github.com/RobertAlvv/docker-compose-django-postgresql.git

cd docker-compose-django-postgresql

docker-compose up -d --build
docker-container ls

sudo ufw allow 1339
sudo ufw allow 5432
sudo ufw allow 8000

curl ifconfig.me