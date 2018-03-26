#!/bin/bash

function getCmdString() {
    cmd='tell application "Terminal" to do script "'
    cmd+="$@"
    cmd+='" in selected tab of the front window'
    echo $cmd
}

function newtab() {
    ACTIVATE='tell application "Terminal" to activate'
    NEWTAB='tell application "System Events" to tell process "Terminal" to keystroke "t" using command down'
    CMD_1=$(getCmdString "cd $1")
    CMD_2=$(getCmdString "$2")
    osascript -e "$ACTIVATE" -e  "$NEWTAB" -e "$CMD_1" -e "$CMD_2"
}

# Everything is simpler if were in the root directory
cd ..

# Start all the services in the prescribed order (Cassandra first)
newtab "utilities/ratdatabase/setup_cassandra_image" "./run.sh"

# Build all the servers
DIRS="audit quoteserver transactionServer webserver workload-generator"
for D in $DIRS; do
    echo "Compiling $D"
    cd $D && go build
    cd ..
done 

# The DB should be started after 50 seconds, tables might not be initialised yet
sleep 50

newtab "cd audit" "./audit"
newtab "quoteserver" "./quoteserver"
newtab "cd webserver" "./webserver"

# Sleep a bit to wait for the servers to settle
sleep 5
newtab "cd transactionServer" "./run.sh"
newtab "cd workload-generator" "./run.sh"
