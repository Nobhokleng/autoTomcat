#!/bin/bash

#################################################################################
##
##	Author:	Trendsoft Team
##	Email: trendsoftinnovation@gmail.com
##	Version: 1.0
##
##	The script check which server is running tomcat. Update configuration,
##	as per you need to check which server us running tomcat and than
##	execute autoDeployToTomcat script.
##
#################################################################################
###				Configuration				      ###
#################################################################################

USER_NAME='root'
PASSWORD1='P@ssw0rd'
PASSWORD2='P@ssw0rd'
SERVER_HOST1='172.30.30.10'
SERVER_HOST2='172.30.30.11'
TOMCAT_NAME='tomcatTest'
PORT='8099'

#################################################################################

# Get number of war file
IS_EXIST=`ls -l *.war 2>/dev/null | wc -l`

# Check if war file exist
if [ $IS_EXIST != 0 ]; then

	# Check Tomcat
	isRunningTomcat=$(sshpass -p $PASSWORD1 ssh -o StrictHostKeyChecking=no $USER_NAME@$SERVER_HOST1 "ps -ef | grep $TOMCAT_NAME | wc -l")
	if [ $isRunningTomcat -gt 2 ];
	then	
		source ./autoDeployToTomcat.sh $USER_NAME $PASSWORD2 $SERVER_HOST2 $TOMCAT_NAME $PORT
		sshpass -p $PASSWORD1 ssh -o StrictHostKeyChecking=no $USER_NAME@$SERVER_HOST1 "pkill -9 -f $TOMCAT_NAME"
	else
		source ./autoDeployToTomcat.sh $USER_NAME $PASSWORD1 $SERVER_HOST1 $TOMCAT_NAME $PORT
		sshpass -p $PASSWORD2 ssh -o StrictHostKeyChecking=no $USER_NAME@$SERVER_HOST2 "pkill -9 -f $TOMCAT_NAME"

	fi
else
	echo "<<<<<<<<<<<<War File Not Found!>>>>>>>>>>>"
fi
