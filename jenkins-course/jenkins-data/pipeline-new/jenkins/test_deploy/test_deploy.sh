#!/bin/bash

scp -i /opt/prod ./jenkins/test_deploy/test_deployed prod-user@ec2-3-95-158-105.compute-1.amazonaws.com:/tmp/test_deployed
ssh -i /opt/prod prod-user@ec2-3-95-158-105.compute-1.amazonaws.com "/tmp/test_deployed"
