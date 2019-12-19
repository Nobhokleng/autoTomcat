WELCOME TO AUTO DEPLOY PROJECT ON TOMCAT
You can use this script to auto deploy your project on tomcat automaticly on server and also support load balancer.

# Usage:
Extract file and copy or cut it into your project path or any local machine path as you want to place it:

$ cd /file-path

You will see two file one for auto deploy to server and anothor one for auto deploy to two server(load balancer):

# Configure setup for one server:
Edit autoDeployToTomcat.sh file and update all required values for your requirement.

# Configure setup for two servers:
Edit checkRunningTomcat.sh file and update all required values for your requirement.

# Execute script
Run the following commands step by step to execute this script.

$ cd /file-path

$ sudo chmod a+x autoDeployToTomcat.sh

$ ./autoDeployToTomcat.sh

# Congratulation you success deploy your project to tomcat.

#Note: For current version we not yet provide you to use cron to schedule your script. But for next version you can use it with cron job.

