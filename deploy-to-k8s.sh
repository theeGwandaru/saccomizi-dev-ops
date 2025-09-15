#!/bin/sh

docker image build -t saccomizi/user-service ../UserService
docker image build -t saccomizi/account-management-service ../AccountManagementService
docker image build -t saccomizi/notification-service ../NotificationService

minikube start --cpus=4

echo "Enabling minikube metrics-server"
minikube addons enable metrics-server

echo "Enable ingress"
minikube addons enable ingress

echo "loading saccomizi/user-service image"
minikube image load saccomizi/user-service

echo "loading saccomizi/account-management-service image"
minikube image load saccomizi/account-management-service

echo "loading saccomizi/notification-service image"
minikube image load saccomizi/notification-service

echo "installing strimzi strimzi/strimzi-kafka-operator"
helm install strimzi strimzi/strimzi-kafka-operator

echo "Launching k8s deployments in the k8s directory"
kubectl apply -k ./k8s/

echo "starting minikube dashboard. It will automatically open a browser window."
minikube dashboard

# To get your node's ip address <node-ip-address>
# kubectl get node minikube -o=jsonpath='{range .status.addresses[*]}{.type}{"\t"}{.address}{"\n"}'

# To get kafka broker's port. The <node port>
# kubectl get service saccomizi-cluster-kafka-external-bootstrap -o=jsonpath='{.spec.ports[0].nodePort}{"\n"}'

# To view kafka messages for the deposit-account-topic
# First have a kafka installation and cd into it's directory
# /bin/kafka-console-consumer.sh --topic deposit-account-topic --from-beginning --bootstrap-server <node-ip-address>:<node port>
