#!/bin/bash
set -eu

tag="${1:-1.0.0}"
folderPath="./bkm/swagger"

for file in "$folderPath"/*; do
    echo "Processing file: $(basename "$file")"
    fileName=$(basename "$file")
    service=$(echo "$fileName" | grep -o "^[^-]*")
    echo "$service"
    rm -rf "generated/${service}"

    echo "Generating ${service} version: ${tag}"
    java -jar /opt/openapi-generator/modules/openapi-generator-cli/target/openapi-generator-cli.jar generate \
    -i "./bkm/swagger/$fileName"  \
    -o "generated/${service}" \
    -g kotlin \
    --library jvm-spring-restclient \
    --skip-validate-spec \
    -p serializationLibrary=jackson \
    -p enumPropertyNaming=PascalCase \
    -p useSpringBoot3=true \
    --global-property apiDocs=false,modelDocs=false,apiTests=false,modelTests=false \
    --skip-overwrite \
    --api-package "com.valensas.bkm.client.${service}" \
    --model-package "com.valensas.bkm.client.${service}" \
    --group-id com.valensas.bkm.client \
    --artifact-id "${service}" \
    --artifact-version "${tag}"

    echo "Copies from publish.gradle file are being transferred to build.gradle file."
    cat publish.gradle >> "generated/${service}/build.gradle"
    chmod +x "./generated/${service}/gradlew"
    
    cd "generated/${service}"
    ./gradlew build

    cd -
done
