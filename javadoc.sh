#!bin/sh

branch=$1
javadocs=$2
maven=$3

if [ $maven = true ]
then
  echo using maven, running mvn clean
  mvn -B clean
fi

if [ ! -d ".git" ]
then
  echo your workpath does not have a .git diectory!
  echo please clone a repository first.
  exit 1
fi

if [ ! -d $javadocs ]
then
  echo javadocs directory $javadocs does not exist!
  echo please make sure you have input right diectory of your javadocs folder
  exit 1
fi

git config --global pull.rebase false
git config --global user.name "Javadocs Generator Bot"
git config --global user.email "<>"
git branch -D $branch && echo Previous branch $branch successfully removed
git checkout --orphan $branch
for f in `ls -a`
do
   remove="true"
   for ele in $javadocs "." ".." ".git"
   do
      if [ $f = $ele ]
      then
remove="false"
      fi
   done
   if [ $remove = "true" ]
   then
     rm -rfv $f
   fi
done    
git fetch
git pull origin $branch && echo $branch successfully pulled
git rm -rf .
mv $javadocs/* .
git add *
git commit -am "update javadocs"
git push -u origin $branch
