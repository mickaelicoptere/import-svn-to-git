#!/bin/bash
path="THE_PATH_WHERE_YOU_WANT_YOUR_SVN_REPOS_TO_BE_IMPORTED"
listPath="THE_PATH_OF_YOUR_LIST_THAT_CONTAINS_SVN_REPOS.csv"
gitlabToken="YOUR_TOKEN"

for repoUrl in `cat $listPath`
do
	repoName=`echo $repoUrl |awk -F/ '{print $4}'`
    echo "link : $repoUrl repository name : $repoName"
    mkdir $repoName && cd $repoName
    #svn checkout
    svn co $repoUrl .
    #create authors-transform.txt in current dir
    svn log -q | awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); print $2" = "$2" <"$2">"}' | sort -u > authors-transform.txt
    #Creates the repo via gitlab's api
    curl -H "Content-Type:application/json" http://git.yourgitlab/api/v3/projects?private_token=$gitlabToken -d "{ \"name\": \"$repoName\", \"visibility_level\" : \"20\"}"
    #TO MODIFY
    gitUrl="git@yourgit:username/$repoName.git"
    echo "project $repoName created"
    echo $gitUrl
    git svn clone $repoUrl --no-metadata -A authors-transform.txt .
    #creates .gitignore (kinda)
    git svn show-ignore > .gitignore
    git add .gitignore
	git commit -m 'Convert svn:ignore properties to .gitignore.'
	#import history to git from svn
	git for-each-ref --format='%(refname)' refs/heads/tags |
	cut -d / -f 4 |
	while read refgit 
	do
  		git tag "$ref" "refs/heads/tags/$ref";
  		git branch -D "tags/$ref";
	done
	#create remote repo
	git remote add origin $gitUrl
	git add .
	git commit -m "imported from svn"
	git push -u origin master
    #echo $repoName
    cd ../
done