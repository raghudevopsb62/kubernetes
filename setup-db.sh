#!/bin/bash

NAMESPACE=dev

helm repo add stable https://charts.helm.sh/stable -n ${NAMESPACE}
helm repo add bitnami https://charts.bitnami.com/bitnami -n ${NAMESPACE}

helm upgrade -i mysql stable/mysql --set mysqlRootPassword=password -n ${NAMESPACE}
helm upgrade -i rabbitmq bitnami/rabbitmq -n ${NAMESPACE}
helm upgrade -i redis bitnami/redis --set auth.enabled=false -n ${NAMESPACE}
helm upgrade -i mongodb bitnami/mongodb --set auth.enabled=false -n ${NAMESPACE}

kubectl run debug -n ${NAMESPACE} --image=centos:7 -- sleep 100000

kubectl -n ${NAMESPACE} cp db-load.sh debug:/db-load.sh
kubectl -n ${NAMESPACE} exec debug -- bash /db-load.sh


kubectl -n ${NAMESPACE} exec rabbitmq-0 -- rabbitmqctl add_user roboshop roboshop123
kubectl -n ${NAMESPACE} exec rabbitmq-0 -- rabbitmqctl set_user_tags roboshop administrator
kubectl -n ${NAMESPACE} exec rabbitmq-0 -- rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

