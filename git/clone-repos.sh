#!/bin/bash
# This script clones all your GitHub repos for the username specified.

echo "This script clones all your GitHub repos for the username specified."
read -r -p "Enter the GitHub username: " USER

# LIST=$(curl -is https://api.github.com/users/$USER/repos | grep clone_url | cut -d '"' -f4)
# LIST=$(curl -is https://api.github.com/users/$USER/repos | grep git_url | cut -d '"' -f4)
LIST=$(curl -is https://api.github.com/users/$USER/repos | grep ssh_url | cut -d '"' -f4)

# echo "$LIST"

TOTAL=$(echo "$LIST" | wc -l)

echo " "
echo "====================================================="
echo "Cloning Repos, Found:"$TOTAL
echo "====================================================="
echo " "

START=1
for (( COUNT=$START; COUNT<=$TOTAL; COUNT++ ))
do
  echo "====================================================="
  echo \#$COUNT
  pwd

  CURRENT=$(echo "$LIST" | nl | grep -w $COUNT | cut -f 2)

  git clone $CURRENT
done

echo "====================================================="
echo " "
echo "Completed!"
echo " "
