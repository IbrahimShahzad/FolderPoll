#!/bin/sh
Dir='/home/ibi/Documents/Linux/Test_Folder'
mail='root@localhost' # /var/mail/root

#check for logfile 1 (if exists do nothing else create)
#
#check the directory and update logfile2
#Highlight difference between logfile1 and logfile2
#if difference send email
#update the logfile1
#repeat after every 3 seconds

#To check the difference between to log files after every 3 minutes.
file1='logfile1.txt' 
file2='logfile2.txt'

while [ true ]
do
	waitTime=180
	if [ -e $file1 ]
	then
		#noting the directory contents in file2
		ls -la $Dir > $file2
		
		#Deleting the Top 3 Lines.
		#Total, . , ..
		sed -i '1,3d' $file2
		#color only for displaying in terminal
		#Common lines suppressed and only changes saved in change.txt		
		diff $file1 $file2 -a --color --suppress-common-lines	> change.txt
		
		#Old file updated. New file will be checked against this file
		#after 'waitTime'
		ls -la $Dir > $file1
		sed -i '1,3d' $file1
		#The Difference between the files is saved in change.txt.
		#If there is no change the file size will be zero.		
		if [ -s change.txt ]
		then
			echo Change detected. Sending mail
			echo "Change Detected" >> change.txt			
			echo "<: entry removed >: entry added" >> change.txt
			#mail sent using mailutils -- dpkg-reconfigure postfix			 			
			cat change.txt | mail -s "${Dir} Updated" root@localhost
			echo "Mail Sent"
			sleep 2 
		fi		
		echo \>\>
		#secs=$((5 * 60))
		
		#Wait
		while [ $waitTime -gt 0 ]
		do
		   	echo "next check in $waitTime seconds" #\033[0K\r"
		   	sleep 1
		   	waitTime=$((waitTime-1))	
			clear	
		done
		#sleep $waitTime
		
	else
		#If logfile doesnot exitst Create one.
		ls -la $Dir > $file1
		sed -i '1,3d' $file1		
		echo $file1 created		
		#sleep $waitTime
	fi	
done


