#!/bin/bash

# Copy new jar to the build directory
echo "*************************"
echo " Copying jar to build dir"
echo "*************************"
cp java-app/target/*.jar jenkins/build/

echo "*************************"
echo "** Building new Image ***"
echo "*************************"

cd jenkins/build/ && docker-compose -f docker-compose-build.yml build --no-cache
