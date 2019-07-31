#!/bin/bash

echo "*****************************"
echo "******* building Jar ********"
echo "*****************************"
#mvn -B -DskipTests clean package

docker run --rm -v $PWD/java-app:/app -v ~/jenkins-course/root/.m2/:/root/.m2/ -w /app maven:3-alpine "$@"
