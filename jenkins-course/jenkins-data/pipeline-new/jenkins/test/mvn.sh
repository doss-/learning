#!/bin/bash

echo "*****************************"
echo "******* Testing Jar *********"
echo "*****************************"
#mvn test

docker run --rm -v $PWD/java-app:/app -v ~/jenkins-course/root/.m2/:/root/.m2/ -w /app maven:3-alpine "$@"
