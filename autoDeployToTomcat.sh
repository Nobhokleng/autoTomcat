#!/bin/bash

#############################################################################
##
##	Author: Trendsoft Team
##	Email: trendsoftinnovation@gmail.com
##	Version: 1.0
##
##	The script auto deploy project to tomcat. Update all configuration
##	as per you need to run auto deploy project to tomcat on your server.
##
##############################################################################
###				Configuration				  
##############################################################################

USER_NAME=$1
PASSWORD=$2
SERVER_HOST=$3
TOMCAT_NAME=$4
PORT=$5

## Update your tomcat path in below file

TOMCAT_PATH='/opt/'$TOMCAT_NAME''
WARFILE_PATH='.'

#############################################################################

# Get file name that end with extension war

FULL_FILE=`ls $WARFILE_PATH | grep *.war`
BASE_FILE=$(basename -- "$FULL_FILE")
# Get only file name without extension
FILE_NAME="${BASE_FILE%.*}"

##############################################################################

# Get number of war file
IS_EXIST=`ls -l *.war 2>/dev/null | wc -l`

# Check if war file exist
if [ $IS_EXIST != 0 ]; then

	# Remove exists old file
	sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $USER_NAME@$SERVER_HOST "cd $TOMCAT_PATH/webapps && rm -rf $FILE_NAME $FULL_FILE"

	echo "<<<<<Copying War File To Server>>>>>"
	sshpass -p $PASSWORD scp -o StrictHostKeyChecking=no $FULL_FILE $USER_NAME@$SERVER_HOST:$TOMCAT_PATH/webapps
	
	# Check tomcat is running or not if not then run tomcat
	echo ".....Start checking tomcat....."
	# Get the process tomcat number are running of tomcat
	isRunningTomcat=$(sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $USER_NAME@$SERVER_HOST "ps -ef | grep $TOMCAT_NAME | wc -l")
	if [ $isRunningTomcat -le 2 ]; then
		sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $USER_NAME@$SERVER_HOST "cd $TOMCAT_PATH && ./bin/catalina.sh start"
	fi
	
	sleep 5s
	# Wait Untill Project is up
	echo "<<<<<Project Is Running>>>>>"
	
	# Get http status
	STATUS=$(curl -s -o /dev/null -w '%{http_code}' $SERVER_HOST:$PORT)

	if [ $STATUS -eq 200 ]; 
	then
		echo "<<<<<Deployment Success>>>>>"
		notify-send 'Deployment' 'Success'

	else
		echo "<<<<<Deployment Failed With Status $STATUS>>>>>"
		sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $USER_NAME@$SERVER_HOST "pkill -9 -f $TOMCAT_NAME"
		notify-send 'Deployment' 'Failed'
		echo "Press '1' for view error log!"
		echo "Press '2' for redeploy again!"
		echo "Press any key for exit!"

		read press

		case $press in
		1)
			sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $USER_NAME@$SERVER_HOST "cd $TOMCAT_PATH && tail -n 500 logs/catalina.out"
			exit 1
			;;
		2)
			echo "This function not yet complete. Please do it by yourself!"
			#./checkRunningTomcat.sh
			exit 1
			;;
		*)
			echo "Exit!"
			exit 1
			;;
		esac
	fi
else
	echo "<<<<<<<<<<War File Not Found>>>>>>>>>>"
fi

##################################### END ########################################
