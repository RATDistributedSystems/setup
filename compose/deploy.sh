#!/bin/bash

ext="docker"
for img in *.$ext; do
    docker load -i $img
done