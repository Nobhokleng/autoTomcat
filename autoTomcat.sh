#!/bin/bash

#################################################################################
##
##	Author:	Hokleng Nob
##	Email: gmhokleng@gmail.com
##	Version: 1.1.1
##
##	The script check which server is running tomcat. Update configuration,
##	as per you need to check which server us running tomcat and than
##	execute autoTomcat script.
##
#################################################################################
###				Configuration				      ###
#################################################################################

CONFIGFILE=./settings.conf

source $CONFIGFILE

#################################################################################

# Get number of war file
IS_EXIST=$(find $FILE_PATH -name "$FILE_EXTENSION" 2>/dev/null | wc -l)

# Check if war file exist
if [ $IS_EXIST != 0 ]; then
	if [ $ENABLE_SII -eq 1 ]; then

		# Check Tomcat
		isRunningTomcat=$(sshpass -p $PASSWORD_SI ssh -o StrictHostKeyChecking=no $USER_NAME_SI@$HOST_SI "ps -ef | grep $TOMCAT_NAME_SI | wc -l")
		if [ $isRunningTomcat -gt 2 ]; then	
			source ./deployToTomcat.sh $USER_NAME_SII $PASSWORD_SII $HOST_SII $TOMCAT_NAME_SII $HTTP_PORT_SII $TOMCAT_PATH_SII
			sshpass -p $PASSWORD_SI ssh -o StrictHostKeyChecking=no $USER_NAME_SI@$HOST_SI "pkill -9 -f $TOMCAT_NAME_SI"
		else
			source ./deployToTomcat.sh $USER_NAME_SI $PASSWORD_SI $HOST_SI $TOMCAT_NAME_SI $HTTP_PORT_SI $TOMCAT_PATH_SI
			sshpass -p $PASSWORD_SII ssh -o StrictHostKeyChecking=no $USER_NAME_SII@$HOST_SII "pkill -9 -f $TOMCAT_NAME_SII"
		fi

	elif [ $ENABLE_SII -eq 0 ]; then
		source ./deployToTomcat.sh
	fi

else
	echo "<<<<<<<<<<<<War File Not Found!>>>>>>>>>>>"
fi
