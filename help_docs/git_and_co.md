# Tips and Tricks to get the repo up and running... #

* To specify a different ssh key to use with git : git config core.sshCommand "ssh -i ~/.ssh/<ChosenKey> -F /dev/null"
* To attach the current repo if needed : 
** git remote add / set-url origin 
** git branch --set-upstream-to origin/master|main 
