#!/usr/bin/env bash

# @see https://qiita.com/mashumashu/items/f5b5ff62fef8af0859c5
function usage() {
cat <<_EOT_
Usage:
    $0 <command>

The commands are:
    new       create new article
    run       run local server
    deploy    push to repository and deploy
_EOT_
exit 1
}

#
new() {
  hugo new articles/`date +%Y%m%d%H%M%S`.md
}

#
run() {
  hugo -D server
}

#
deploy() {
  # If a command fails then the deploy stops
  set -e
  
  printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"
  
  # Build the project.
  hugo # if using a theme, replace with `hugo -t <YOURTHEME>`
  
  # Go To Public folder
  cd public
  
  # Add changes to git.
  git add .
  
  # Commit changes.
  msg="rebuilding site $(date)"
  if [ -n "$*" ]; then
  	msg="$*"
  fi
  git commit -m "$msg"
  
  # Push source and build repos.
  git push origin master
}

if [[ $# -lt 1 ]]; then 
  usage
fi

if [[ $1 = "new" ]]; then
  new
elif [[ $1 = "run" ]]; then
  run
elif [[ $1 = "deploy" ]]; then
  deploy
else
  usage
fi