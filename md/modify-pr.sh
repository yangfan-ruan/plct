#!/bin/bash

SPEC_FILE="$(ls *.spec)"
BRANCH="issue-compile-with-openjdk11"
COMMIT_MESSAGE="update spec, compiling with openjdk11"

git add .

# first time
git commit -m "$COMMIT_MESSAGE" 
git push -u origin "$BRANCH" 

# one more time
# git commit --amend -m "$COMMIT_MESSAGE"
# git push --force-with-lease origin "$BRANCH"

echo "Changes to $SPEC_FILE have been pushed to $BRANCH."
