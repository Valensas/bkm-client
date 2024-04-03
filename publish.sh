#!/bin/bash
set -eu

tag=$1
folderPath="./bkm/swagger"

for file in "$folderPath"/*; do
    fileName=$(basename "$file")
    service=$(echo "$fileName" | grep -o "^[^-]*")
    cd "generated/${service}"
    
    if grep -Eq "version\s+'${tag}'" ./build.gradle
      then
        echo "Publishing ${service}, version:${tag}"
        ./gradlew publish
      else
        echo "version '${tag}' must exist in the build.gradle file."
        exit 1
      fi

    cd -
done