#!/bin/bash

# upload to a worker node(s) in the k8 cluster
# the intermediate machine to which the image is built is managed by 
# docker-machine but could be any docker instance provided the endpoint details are
# available

# uses docker save and load 
# ssh will be used to load and tag the container in the k8 cluster machine(s)

# values are hard-coded for convenience

# a private registry would probably be a much better solution 
# this is the intermediate approach for progress

image_path=$1
tar_image_name=$(basename $image_path)
image_name=$(echo $tar_image_name | cut -d . -f 1)

echo "Uploading $tar_image_name to worker nodes ..."

for machine in `cat <<HERE
    w1
    w2
HERE`
do

#machine="w1"
    echo "Copying to worker node $machine ..."
    scp -F ~/.ssh/config $image_path $machine:/home/core/

    echo "Loading container ..."
    ssh $machine "docker load -i /home/core/$tar_image_name"

    echo "Confirming image load ..."
    ssh $machine "docker images |grep $image_name"
done
#echo "Tagging container ..."
#ssh w2 "docker tag $image_id testapi"

