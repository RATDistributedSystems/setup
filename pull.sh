#!/bin/bash

DIRS="audit quoteserver transactionServer webserver workload-generator triggerserver frontend"
for D in $DIRS; do
    cd ..
    cd "$D" && git pull
done 