#!/bin/bash

ext="docker"
for img in *.$ext; do
    sudo docker load -i $img
done