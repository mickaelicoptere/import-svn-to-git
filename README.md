# ugly bash script that converts svn repos to git repos

## How it works : 
It uses a .csv where each line is : svn://issasvnserver/issarepo/
it'll then converts these svn repos to git repos and even creates an empty repo if you have a gitlab server using your personnal access token 

at the top of the file you have : 
`path="THE_PATH_WHERE_YOU_WANT_YOUR_SVN_REPOS_TO_BE_IMPORTED"
listPath="THE_PATH_OF_YOUR_LIST_THAT_CONTAINS_SVN_REPOS.csv"
gitlabToken="YOUR_TOKEN"`

it's kinda self explanatory, replace these variables as it suits you...

## special thanks to john albin 
The commands used by john albin on his website were a huuuge help to make this script a reality [source](https://john.albin.net/git/convert-subversion-to-git)

Enjoy
