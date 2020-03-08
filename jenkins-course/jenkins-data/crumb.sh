#!/bin/bash

crumb=$(curl -u "builder:1234" -s 'http://jenkins.local:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)')
#curl -u "builder:1234" -H "$crumb" -X POST http://jenkins.local:8080/job/ENV/build?delay=0sec

#curl -u "builder:1234" -H "$crumb" -X POST http://jenkins.local:8080/job/backup-to-aws/buildWithParameters?MYSQL_HOST=db_host&DATABASE_NAME=testdb&AWS_BUCKET_NAME=dos-deepdive

curl -u "builder:1234" -H "$crumb" -X POST http://jenkins.local:8080/job/ansible-users-from-db/buildWithParameters?AGE=25
