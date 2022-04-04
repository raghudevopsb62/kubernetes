#!/bin/bash

NAMESPACE=default

helm repo add stable https://charts.helm.sh/stable
helm repo add bitnami https://charts.bitnami.com/bitnami

helm upgrade -i mysql stable/mysql --set mysqlPassword=password
helm upgrade -i rabbitmq bitnami/rabbitmq
helm upgrade -i redis bitnami/redis --set auth.enabled=false
helm upgrade -i mongodb bitnami/mongodb --set auth.enabled=false

kubectl run debug --image=centos:7 -- sleep 100000

kubectl exec debug -- yum install epel-release -y
kubectl exec debug -- curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo
kubectl exec debug -- yum install mongodb-org mariabd unzip -y
kubectl exec debug -- curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
kubectl exec debug -- curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
kubectl exec debug -- unzip -o /tmp/mongodb.zip
kubectl exec debug -- unzip -o /tmp/mysql.zip
kubectl exec debug -- mongo --host mongodb \</mongodb-main/catalogue.js
kubectl exec debug -- mongo --host mongodb \</mongodb-main/users.js
kubectl exec debug -- mysql -h mysql -uroot -ppassword \</mysql-main/shipping.sql

kubectl exec rabbitmq-0 -- rabbitmqctl add_user roboshop roboshop123
kubectl exec rabbitmq-0 -- rabbitmqctl set_user_tags roboshop administrator
kubectl exec rabbitmq-0 -- rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

