#!/bin/bash

echo "*********************"
echo "** Pushing image ****"
echo "*********************"

IMAGE="maven-project"

echo "** Logging in *******"
docker login -u doss -p $PASS

echo "** Tagging image ****"
docker tag $IMAGE:$BUILD_TAG doss/$IMAGE:$BUILD_TAG

echo "** Pushing image ****"
docker push doss/$IMAGE:$BUILD_TAG
