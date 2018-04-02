#!/bin/bash

cd /home/seng468/Desktop/g21

ext="docker"
for img in *.$ext; do
    sudo docker load -i $img
done