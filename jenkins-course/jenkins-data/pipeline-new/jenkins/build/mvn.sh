#!/bin/bash

echo "*****************************"
echo "******* building Jar ********"
echo "*****************************"
#mvn -B -DskipTests clean package

echo "************pwd is $PWD"

# Absolute path to workspace, as per during docker-sock usage the $PWD 
#  will have another value
WORKSPACE="/home/dos/git/learning/jenkins-course/jenkins-data/jenkins_home/workspace/pipeline-docker-maven"

# BTW root directory is also mounted incorrectly(because maven downloaded
# all the stuff again when firstly was executed in Jenkins environment
docker run --rm -v $WORKSPACE/java-app:/app -v ~/jenkins-course/root/.m2/:/root/.m2/ -w /app maven:3-alpine "$@"
