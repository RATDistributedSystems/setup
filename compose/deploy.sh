#!/bin/bash

set -e

ssh -t seng468@$1 "mkdir -p /home/seng468/Desktop/g21"
scp *.docker load.sh seng468@$1:/home/seng468/Desktop/g21/
ssh -t seng468@$1 "sudo ./load.sh"

