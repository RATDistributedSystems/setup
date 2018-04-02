#!/bin/bash

DIRS="audit quoteserver transactionServer workload-generator frontend"
for D in $DIRS; do
    cd ..
    cd "$D" && git pull
done 