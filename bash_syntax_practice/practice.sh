#!/bin/bash

WD="practice_make_perfect"

function create_dir {
    mkdir $1
    log_msg  "D" "created $1 dir"
}

function list_dir {
    ls -la $1
}

function log_msg {
    verbosity=$1
    msg=$2
    case $verbosity in 
      "I")
        echo "[INFO]: $2"
        ;;
      "D")
        echo "[DEBUG]: $2"
        ;;
      "W")
        echo "[WARNING]: $2"
        ;;
      "E")
        echo "[ERROR]: $2"
        ;;
      *)
       echo -n "unknown Verbosity"
       ;;
      esac
}

if [ -d $WD ]; then
  log_msg "I" "Directory $WD exists."
  read -p "Delete?:" line 
  case $line in
    y | Y)
      rm -rf $WD
      ;;
    *)
      list_dir "$WD"
      ;;
  esac
fi

log_msg "W" "$WD does not exist!"
if [ -f "practice.config" ]; then
    log_msg  "I" "config exists, autocreating"
while IFS= read -r line; do
    create_dir "$line"
done < practice.config
    list_dir "$WD"
else
    log_msg "E" "cannot autocreate"
    exit 1
fi  


