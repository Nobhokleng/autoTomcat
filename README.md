WELCOME TO AUTO DEPLOY PROJECT TO TOMCAT
This script use to auto deploy your project to tomcat automaticly on server.

# Requirement:
You need to install sshpass on your local machine:
$ sudo apt-get install sshpass	//Ubuntu
$ sudo yum install sshpass	//Centos

# Usage:
$ cd /autoTomcat

There are two files deployToTomcat for deploy project to server and autoTomcat for auto deploy project with two servers:

# Configure credentail:
Edit setting.conf file and update all required values for your requirement.

# Execute script
Run the following commands step by step to execute this script.

$ cd /autoTomcat

$ sudo chmod a+x autoTomcat.sh
$ sudo chmod a+x deployToTomcat.sh

# Two Servers:
$ ./autoTomcat.sh

# Single Server:
$ ./deployToTomcat.sh

Congradulation your project is running on Server please enjoy!
