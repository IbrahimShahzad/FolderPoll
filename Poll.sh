#!/bin/sh
Dir='/home/ibi/Documents/Linux/Test_Folder'
mail='root@localhost' # /var/mail/root

#To check the difference between to log files after every 3 minutes.
file1='logfile1.txt' 
file2='logfile2.txt'
cfile='changfile.txt'

#lsof nPi | grep ":80 (LISTEN)" > Logger

#Checking to see if apache is already installed
dpkg --get-selections | grep apache
if [ $? -eq 0 ]
then
	echo "................................. Apache already installed "
else
	#Installing Apache (DEBIAN)
	echo "................................. Installing Apache2 "
	apt-get install apache2
	echo "................................. Apache Installed "
fi
sleep 2

#Checking to see if apache2 is running
ps cax | grep apache2
if [ $? -eq 0 ]
then
	echo "................................. Apache running"
else
	#Starting Apache service
	echo "................................. Starting Apache"
	service apache2 start
	echo "................................. DONE "
fi

sleep 2
while [ true ]
do
	#Program will poll Directory every $waitTime seconds
	waitTime=15
	if [ -e $file1 ]
	then
		#noting the directory contents in file2
		ls -la $Dir > $file2
		
		#Deleting the Top 3 Lines.
		#Total, . , ..
		sed -i '1,3d' $file2
		#color only for displaying in terminal
		#Common lines suppressed and only changes saved in change.txt		
		diff $file1 $file2 -a --color --suppress-common-lines	> $cfile
		
		#Old file updated. New file will be checked against this file
		#after 'waitTime'
		ls -la $Dir > $file1
		sed -i '1,3d' $file1
		#The Difference between the files is saved in change.txt.
		#If there is no change the file size will be zero.		
		if [ -s $cfile ]
		then
			echo Change detected. Sending mail
			echo "Change Detected" >> change.txt			
			echo "<: entry removed >: entry added" >> $cfile
			#mail sent using mailutils -- dpkg-reconfigure postfix			 			
			cat $cfile | mail -s "${Dir} Updated" root@localhost
			echo "Mail Sent"

			#Make sure there is an index.html present in the main directory
			input="./index.html"
			
			#writing the index.html file
			{
				echo "<HEAD>"
				echo "<TITLE> FOLDER POLL  </TITLE>"
				echo "</HEAD>"
				echo "<BODY>"
				echo "<H1> DIR: ${Dir} </H1>"
				while IFS= read -r var
				do
  					echo "<P> $var </P>"
				done < "$cfile"
				echo "</BODY>"
				echo "</HTML>"


			} > $input  

			#copy to be accessed by Localhost
			cp index.html /var/www/html/index.html
			echo ".................................. Webpage updated!"
			sleep 5 
		fi		
		echo \>\>
		
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


