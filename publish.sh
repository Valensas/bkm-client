#!/bin/bash
set -eu

tag=$1
folderPath="./bkm/swagger"

for file in "$folderPath"/*; do
    fileName=$(basename "$file")
    service=$(echo "$fileName" | grep -o "^[^-]*")
    cd "generated/${service}"
    
    echo "Publishing ${service}, version:${tag}"
    ./gradlew "-Pversion=$tag" publishToCentralPortal

    cd -
done