#!/bin/bash

DIRS="audit quoteserver transactionServer webserver workload-generator"
for D in $DIRS; do
    cd ..
    cd "$D" && git pull
done 