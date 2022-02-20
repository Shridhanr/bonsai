#!/bin/bash

IMAGE_TAG=$1
SERVICE_NAME=$2
ENV=$3
IMAGE_PREFIX=$4

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
#ls $parent_path
#cat $parent_path/kubernetes.yml
# read the yml template from a file and substitute the string
template=`cat "$parent_path/deployment.yaml" | sed "s/{{IMAGE_TAG}}/$IMAGE_TAG/g" | sed "s/{{SERVICE_NAME}}/$SERVICE_NAME/g" | sed "s/{{ENV}}/$ENV/g" | sed "s/{{IMAGE_PREFIX}}/$IMAGE_PREFIX/g"`

# apply the yml with the substituted value
echo "$template" | kubectl apply -f -

service=`cat "$parent_path/service.yaml" | sed "s/{{SERVICE_NAME}}/$SERVICE_NAME/g"`

echo "$service" | kubectl apply -f -