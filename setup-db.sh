#!/bin/bash

NAMESPACE=default

helm repo add stable https://charts.helm.sh/stable
helm repo add bitnami https://charts.bitnami.com/bitnami

helm upgrade -i mysql stable/mysql --set mysqlPassword=password
helm upgrade -i rabbitmq bitnami/rabbitmq
helm upgrade -i redis bitnami/redis --set auth.enabled=false
helm upgrade -i mongodb bitnami/mongodb --set auth.enabled=false

kubectl run debug --image=centos:7 -- sleep 100000

kubectl cp debug db-load.sh debug:/db-load.sh 
kubectl exec debug -- /db-load.sh


kubectl exec rabbitmq-0 -- rabbitmqctl add_user roboshop roboshop123
kubectl exec rabbitmq-0 -- rabbitmqctl set_user_tags roboshop administrator
kubectl exec rabbitmq-0 -- rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

