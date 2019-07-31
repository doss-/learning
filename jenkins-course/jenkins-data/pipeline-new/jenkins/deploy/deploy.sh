#!/bin/bash

echo "***********************"
echo "** Deploying app ******"
echo "***********************"

echo maven-project > /tmp/.auth
echo $BUILD_TAG >> /tmp/.auth
echo $PASS >> /tmp/.auth

scp -i /opt/prod /tmp/.auth prod-user@ec2-34-226-148-52.compute-1.amazonaws.com:/tmp/.auth
scp -i /opt/prod ./jenkins/deploy/publish prod-user@ec2-34-226-148-52.compute-1.amazonaws.com:/tmp/publish
ssh -i prod prod-user@ec2-34-226-148-52.compute-1.amazonaws.com "/tmp/publish"
