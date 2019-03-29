#!/bin/sh

# this script rewrites git commits email and author name to new email and author name
# edit "old@email" to the email address you want to change, and "new@email" and "new name"
# to the new email / name you want the commits to have
# then force push, after checking that the commits are all still good (they should be, but double check!)
# this is intended to be used if a commit was pushed with a private email instead of a public one (e.g. a personal email rather than a noreply or business email).  I can't stop you, but please don't use this for nefarious purposes.

echo "Edit the email and author name sections before running"
exit 1

# pull changes that might have happened
git pull

# replace link123451-?noreply
git filter-branch --env-filter 'if [ "$GIT_AUTHOR_EMAIL" = "old@email"  ]; then
GIT_AUTHOR_EMAIL="new@email";
GIT_AUTHOR_NAME="new name";
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL";
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"; fi' -- --all

# drop originals from before change
git for-each-ref --format="%(refname)" refs/original/ | xargs -n 1 git update-ref -d

echo;
echo "Run git push --force if everything is good"
