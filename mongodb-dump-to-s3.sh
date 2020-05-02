#!/bin/bash

# MongoDb credentials - replace with your infos
USER_MONGO=user
PASS_MONGO=pass
HOST_MONGO=host
PORT_MONGO=27017
AUTH_MONGO=dbauth
#DB_MONGO="dbname"  - #if you want a specif dump database use --db= 

#Path to generate backup
PATH="/var/lib/mongo/backup"

#Add timestamp to the folder/file name
TIMESTAMP=`date "+%Y-%m-%d-%H"`

#Bucket information 
BUCKET="bucket" #replace with your bucket name

# Creating backup
/usr/bin/mongodump --host $HOST_MONGO --port $PORT_MONGO -u $USER_MONGO --password $PASS_MONGO --authenticationDatabase $AUTH_MONGO -o $PATH/mongodb-$TIMESTAMP 

#Backup folder compression
/usr/bin/tar -czvf $PATH/mongodb-$TIMESTAMP.tar.gz $PATH/mongodb-$TIMESTAMP

# Upload to bucket
/usr/bin/aws s3 cp --sse AES256 $PATH/mongodb-$TIMESTAMP.tar.gz s3://$BUCKET/

#Delete local files
/usr/bin/rm -rf $PATH/mongodb-*

