#!/bin/bash

DATE=$(date +%H-%M-%S--%m-%d)
DUMP_NAME="db-$DATE.sql"

DB_HOST=$1
DB_PASSWORD=$2
DB_NAME=$3
AWS_PASS=$4
BUCKET_NAME=$5



mysqldump -u root -h $DB_HOST -p$DB_PASSWORD $DB_NAME > /tmp/$DUMP_NAME && \
export AWS_ACCESS_KEY_ID=AKIAW443RQ5CPPFEL2GZ && \
export AWS_SECRET_ACCESS_KEY=$AWS_PASS && \
echo "Uploading db backup" && \
aws s3 cp /tmp/$DUMP_NAME s3://$BUCKET_NAME/jenkins-stuff/$DUMP_NAME


