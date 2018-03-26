#!/bin/bash

IMAGES="rataudit ratauditdb rattransaction rattransactiondb redis rattrigger rattriggerdb"
ext="dock"
PWD=`pwd`
for image in $IMAGES; do
    docker save -o ./$image.$ext $image
    echo "Saved $image in $PWD"
done