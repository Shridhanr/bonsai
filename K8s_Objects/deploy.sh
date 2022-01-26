#!/bin/bash

IMAGE_TAG=$1
SERVICE_NAME=bonsai-service

echo 'export PATH=/home/ubuntu/bin/aws-iam-authenticator:$PATH' >> ~/.bashrc
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
#ls $parent_path
#cat $parent_path/kubernetes.yml
# read the yml template from a file and substitute the string
template=`cat "$parent_path/deploymentservice.yml" | sed "s/{{IMAGE_TAG}}/$IMAGE_TAG/g" | sed "s/{{SERVICE_NAME}}/$SERVICE_NAME/g"`

# apply the yml with the substituted value
echo "$template" | kubectl apply -f -

#service=`cat "$parent_path/service.yaml" | sed "s/{{SERVICE_NAME}}/$SERVICE_NAME/g"`

#echo "$service" | kubectl apply -f -
