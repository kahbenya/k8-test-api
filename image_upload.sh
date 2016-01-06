#!/bin/bash

# create a docker container and upload to a worker node(s) in the k8 cluster
# the intermediate machine to which the image is built is managed by 
# docker-machine but could be any docker instance provided the endpoint details are
# available

# uses docker save and load 
# ssh will be used to load and tag the container in the k8 cluster machine(s)

# values are hard-coded for convenience

# a private registry would probably be a much better solution 
# this is the intermediate approach for progress


echo "Building container ..."
docker build -t testapi . 
#image_id=$(docker images |grep testapi |awk '{print $3}')

echo "Saving image to tar file ..."
docker save testapi > testapi.tar

for machine in `cat <<HERE
    w1
    w2
HERE`
do

#machine="w1"
    echo "Copying to worker node $machine ..."
    scp -F ~/.ssh/config testapi.tar $machine:/tmp

    echo "Loading container ..."
    ssh $machine "docker load -i /tmp/testapi.tar"

    echo "Confirming image load ..."
    ssh $machine "docker images |grep testapi"
done
#echo "Tagging container ..."
#ssh w2 "docker tag $image_id testapi"

