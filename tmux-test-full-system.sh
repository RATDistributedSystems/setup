#!/bin/bash

# Everything is simpler if were in the root directory
cd ..

# Start all the services in the prescribed order (Cassandra first)
tmux new-window -c "$PWD/utilities/ratdatabase/setup_cassandra_image" ./run.sh

# Build all the servers
DIRS="audit quoteserver transactionServer webserver workload-generator"
for D in $DIRS; do
    echo "Compiling $D"
    cd $D && go build
    cd ..
done 

# The DB should be started after 50 seconds, tables might not be initialised yet
sleep 50

tmux new-window -c "$PWD/audit" ./audit
tmux new-window -c "$PWD/quoteserver" ./quoteserver
tmux new-window -c "$PWD/webserver" ./webserver

# Sleep a bit to wait for the servers to settle
sleep 5
tmux new-window -c "$PWD/transactionServer" ./run.sh
tmux new-window -c "$PWD/workload-generator" ./run.sh
