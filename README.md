# Docker Deployment for Logiks Apps

This folder contains all the docker compose files that are needed to run a complete infrastructure for Logiks Apps.
This can be directly used in any docker environment.

### How to use
+ Unzip the folder
+ cd into the new folder
+ run './bin/install-app.sh' 

### To run the application
+ run 'docker-compose up -d --no-recreate'

#### To stop the instances
+ run 'docker-compose down'

#### To update the application, core and other plugins
+ run './bin/update-app.sh' 

### Other instruction
+ After checking the server is running and all conditions are met
+ Configure webData/config/* as per requirements
+ Configure the mysql, mongo, memcached as per requirements as below.

### Security Instruction
+ Please change the password for MySQL as per your requirements


HOST_MYSQL= 173.18.20.24

HOST_MONGO= mongodb://173.18.20.26:27017/test1

HOST_MEMCACHED= 173.18.20.28

PORT_MEMCACHED = 11211

MYSQL_USERID= root


Thank you

Bismay M
