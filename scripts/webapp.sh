#This is a startup-script that will install an example application on the provisioned server
#!/bin/bash
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install nginx -y
cd /etc/nginx/sites-available
sudo cp /tmp/logs.nginx.io ./
cd .. && cd sites-enabled
sudo rm -f default
sudo ln -s ../sites-available/logs.nginx.io
sudo service nginx reload
sudo apt-get install apt-transport-https openjdk-8-jre-headless uuid-runtime pwgen -y
sudo apt update -y
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/oss-6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
sudo apt update
sudo apt -y install elasticsearch-oss
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo su <<EOF
cd /etc/elasticsearch
rm -f /etc/elasticsearch/elasticsearch.yml
cp /tmp/elasticsearch.yml ./
sudo systemctl restart elasticsearch.service
#Mongo DB
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl daemon-reload
sudo systemctl enable mongod.service
sudo systemctl restart mongod.service
#Graylog
wget https://packages.graylog2.org/repo/packages/graylog-3.1-repository_latest.deb
sudo dpkg -i graylog-3.1-repository_latest.deb
sudo apt update
sudo apt -y install graylog-server
cd /etc/graylog/server/
rm -f server.conf
cp /tmp/server.conf ./
sudo systemctl enable graylog-server.service
sudo systemctl start graylog-server.service
EOF
