# FolderPoll
Polls the directory and notifies the changes via email and displays via webpage (http://localhost)

Dir is the Directory that needs to be polled.

The program checks to see if apache server is installed, if not it first installs and starts the apache server.

This file creates three .txt files. logfile1.txt which is created when the directory is polled for the first time. logfile2.txt is created when folder is polled after waitTime. The programs checks for differences among the two files and if there are any, sends and email to root with the differences in email body. Mails to the root can be found in /var/mail/root

The program polls the directory after every waitTime seconds. If change in diretory detected, email is sent to root as well as /var/www/html/index.html is also updated. 
