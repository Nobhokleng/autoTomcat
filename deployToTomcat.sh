#!/bin/bash

#############################################################################
##
##	Author: Hokleng Nob
##	Email: gmhokleng@gmail.com
##	Version: 1.1.2
##
##	The script auto deploy project to tomcat. Update all configuration
##	as per you need to run auto deploy project to tomcat on your server.
##
##############################################################################
###				Configuration				   ###
##############################################################################

CONFIGFILE=./settings.conf

source $CONFIGFILE

[[ $1 ]] && USER_NAME="$1" || USER_NAME="$USER_NAME_SI"
[[ $2 ]] && PASSWORD="$2" || PASSWORD="$PASSWORD_SI"
[[ $3 ]] && SERVER_HOST="$3" || SERVER_HOST="$HOST_SI"
[[ $4 ]] && TOMCAT_NAME="$4" || TOMCAT_NAME="$TOMCAT_NAME_SI"
[[ $5 ]] && PORT="$5" || PORT="$HTTP_PORT_SI"
[[ $6 ]] && TOMCAT_PATH="$6" || TOMCAT_PATH="$TOMCAT_PATH_SI"

# Get original file name

ORIGINAL_FILE_NAME=`ls $FILE_PATH | grep $FILE_EXTENSION`

##############################################################################

# Stop tomcat when deploy project on a server
[[ $1 ]] && echo "<<<<<Removing project from server>>>>>" || sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $USER_NAME@$SERVER_HOST "pkill -9 -f $TOMCAT_NAME"

# Remove exists old file
sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $USER_NAME@$SERVER_HOST "cd $TOMCAT_PATH/webapps && rm -rf $PROJECT_NAME $PROJECT_NAME$PROJECT_EXTENSION"

echo "<<<<<Copying War File To Server>>>>>"
sshpass -p $PASSWORD scp -o StrictHostKeyChecking=no $FILE_PATH/$ORIGINAL_FILE_NAME $USER_NAME@$SERVER_HOST:$TOMCAT_PATH/webapps/$PROJECT_NAME$PROJECT_EXTENSION

# Check tomcat is running or not if not then run tomcat
echo "<<<<<Checking Tomcat>>>>>"

# Get the process tomcat number are running of tomcat
isRunningTomcat=$(sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $USER_NAME@$SERVER_HOST "ps -ef | grep $TOMCAT_NAME | wc -l")
if [ $isRunningTomcat -le 2 ]; then
	sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $USER_NAME@$SERVER_HOST "cd $TOMCAT_PATH && ./bin/catalina.sh start"
fi

# Wait Untill Project is up
echo "<<<<<Project Is Starting Up>>>>>"
gnome-terminal --tab -- bash -c 'sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $USER_NAME@$SERVER_HOST "cd $TOMCAT_PATH && tail -f logs/catalina.out"; read line'
sleep 15s

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

	read -r press

	case $press in
	1)
		sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $USER_NAME@$SERVER_HOST "cd $TOMCAT_PATH && tail -n 200 logs/catalina.out"
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

##################################### END ########################################
