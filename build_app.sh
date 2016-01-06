#!/bin/bash



# create a docker container for app 

echo "Building container ..."
docker build -t testapi . 
#image_id=$(docker images |grep testapi |awk '{print $3}')

echo "Saving image to tar file ..."
docker save testapi > testapi.tar
