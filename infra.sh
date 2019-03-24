#!/bin/bash

#check whether we have universe enabled for htop 
uname --machine  # will return architecture
#match x86_x64 architecture
apt-cache policy | grep "archive\.ubuntu\.com.*xenial-updates\/universe.*amd64"
#match x86 architecture
apt-cache policy | grep "archive\.ubuntu\.com.*xenial-updates\/universe.*i386"
#if nothing found then need to add universe repo
add-apt-repository universe
#recheck if added, if not use long line
#which probably is in linux_cheatsheet but in master branch 
