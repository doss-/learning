#!/bin/bash

echo "*****************************"
echo "******* Testing Jar *********"
echo "*****************************"
#mvn test

WORKSPACE="/home/dos/git/learning/jenkins-course/jenkins-data/jenkins_home/workspace/pipeline-docker-maven"

docker run --rm -v $WORKSPACE/java-app:/app -v ~/jenkins-course/root/.m2/:/root/.m2/ -w /app maven:3-alpine "$@"
