# FolderPoll
Polls the directory and notifies the changes

Dir is the Directory that needs to be polled.

This file creates three .txt files. logfile1.txt which is created when the directory is polled for the first time. logfile2.txt is created when folder is polled after waitTime. The programs checks for differences among the two files and if there are any, sends and email to root with the differences in email body. Mails to the root can be found in /var/mail/root

The program polls the directory after every waitTime seconds.
