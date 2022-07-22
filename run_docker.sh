#!/bin/bash

sudo yum update -y

sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo chkconfig docker on
sudo chmod a+rw /var/run/docker.sock
sudo yum install -y git
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod a+x /usr/local/bin/docker-compose

git clone https://github.com/agburov/full_pipeline.git
cd full_pipeline
chmod a+x run_docker.sh
docker build -t myapp:v1 -f app/Dockerfile .
docker run \
    --log-driver=awslogs \
    --log-opt awslogs-region=us-east-1 \
    --log-opt awslogs-group=Docker-Logs \
    --log-opt awslogs-create-group=true \
    -d -p 9000:80 myapp:v1
