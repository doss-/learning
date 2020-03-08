#!/bin/bash

for (( i=1; i<=50; i++ )); do
  name=$(nl people.txt \
       | grep -w $i \
       | awk '{print $2}' \
       | awk -F ',' '{print $1}')
  lastname=$(nl people.txt \
       | grep -w $i \
       | awk '{print $2}' \
       | awk -F ',' '{print $2}')
  age=$(shuf -i 20-25 -n 1)

  mysql -u root -p1234 people \
  -e "insert into register values ($i, '$name', '$lastname', $age)"

  echo "${i}: $name $lastname $age Was correctly imported"
done
