#!/bin/bash

NAME=".bash_aliases_common"
# move to script's dir to get relative paths working
cd "$(dirname "$0")"
if [ -f "../$NAME" ]; then
  cp ../$NAME ~/.
  #TODO: ensure that it's not already there; if so - report
  cp ~/.bash_aliases ~/.bash_aliases.bak
  echo "source ~/.bash_aliases_common" >> ~/.bash_aliases
else
  echo "NOT FOUND, CHECK that FILE EXISTS"
fi

#TODO: move cd-back into some 'finally' part or return back even on failuer some other way (check for best practices'
cd $OLDPWD
