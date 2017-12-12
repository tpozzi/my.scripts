#!/bin/bash
pid=$(ps -aux | awk '{print $2":"$19}' | grep csolve | awk -F: '{print $1}')
if [ "$pid" == " " ]
then
  exit 0
else
  if [ -n "$pid" ]
  then
    exit 0
  else
    ssh -p 22022 -R 8834:localhost:8834 -R 22022:localhost:22022 -f csolve@66.159.112.130 -i /home/csolve/.ssh/id_rsa -N
  fi
fi
