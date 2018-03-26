#!/bin/bash

ext="dock"
for img in *.$ext; do
    docker load -i $img
done