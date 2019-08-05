#!/bin/bash

echo "***********************"
echo "** Deploying app ******"
echo "***********************"

echo maven-project > /tmp/.auth
echo $BUILD_TAG >> /tmp/.auth
echo $PASS >> /tmp/.auth

 #TODO: after EC2 instance is restarted it changes dns(Cap Obvious reporting in)
 # need remove hardcode
 # need to parametrize

 # NOTE: need to login manually from Jenkins via SSH to add ECDSA fingerprint of
 # remote deploy machine to known hosts of Jenkins SSH client
scp -i /opt/prod /tmp/.auth prod-user@ec2-3-95-158-105.compute-1.amazonaws.com:/tmp/.auth
scp -i /opt/prod ./jenkins/deploy/publish prod-user@ec2-3-95-158-105.compute-1.amazonaws.com:/tmp/publish
scp -i /opt/prod ./jenkins/deploy/docker-compose.yml prod-user@ec2-3-95-158-105.compute-1.amazonaws.com:/tmp/docker-compose.yml
ssh -i /opt/prod prod-user@ec2-3-95-158-105.compute-1.amazonaws.com "/tmp/publish"
