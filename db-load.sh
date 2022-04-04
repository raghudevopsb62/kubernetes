#!/bin/bash 

yum install epel-release -y
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo
yum install mongodb-org mariadb unzip -y
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
unzip -o /tmp/mongodb.zip
unzip -o /tmp/mysql.zip
mongo --host mongodb </mongodb-main/catalogue.js
mongo --host mongodb </mongodb-main/users.js
mysql -h mysql -uroot -pPASSWORD </mysql-main/shipping.sql
