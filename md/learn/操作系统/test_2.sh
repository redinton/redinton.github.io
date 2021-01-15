#!/bin/bash
export AUTOCV_HOST_PORT=8447
export SSL_CERTIFICATE=/var/leapai/leapai/leapai_v2.1.0/cert/server.crt
export SSL_CERTIFICATE_KEY=/var/leapai/leapai/leapai_v2.1.0/cert/server.key

export STORAGRE=/mnt/deepnex31/autocv/storage
export LOGS=/mnt/deepnex31/autocv/logs
export LEAPAI_FS=/mnt/deepnex31/fs

# mysql setting
export MYSQL_DATABASE=autocv
export MYSQL_USER=autocv
export MYSQL_USER_PASSWORD=Autocv_123456
export MYSQL_HOST=10.122.36.156
export MYSQL_PORT=3306

# redis setting
export REDIS_HOST=10.122.36.156
export REDIS_PORT=6379
export REDIS_DB=8
export REDIS_PASSWORD=redis12345

# autocv setting
export SUPPORT_TYPE=ALL

# leapai setting
export LEAPAI_HOST=https://10.122.36.156
export AUTOCV_IMAGE_NAME=system/autocv:v1.1_deploy
export LEAPAI_AUTOCV_IFRAME_TYPE=dependent
export LEAPAI_ONLINE_FRAMEWORK_NAME=AutoCV
export LEAPAI_ONLINE_FRAMEWORK_VERSION=OCR

docker run -d \
    --runtime=nvidia \
    --restart=always \
    --name autocv1.1_deploy \
    -e MYSQL_DATABASE=${MYSQL_DATABASE} \
    -e MYSQL_USER=${MYSQL_USER} \
    -e MYSQL_USER_PASSWORD=${MYSQL_USER_PASSWORD} \
    -e MYSQL_HOST=${MYSQL_HOST} \
    -e MYSQL_PORT=${MYSQL_PORT} \
    -e REDIS_HOST=${REDIS_HOST} \
    -e REDIS_PORT=${REDIS_PORT} \
    -e REDIS_DB=${REDIS_DB} \
    -e REDIS_PASSWORD=${REDIS_PASSWORD} \
    -e SUPPORT_TYPE=${SUPPORT_TYPE} \
    -e LEAPAI_HOST=${LEAPAI_HOST} \
    -e AUTOCV_IMAGE_NAME=${AUTOCV_IMAGE_NAME} \
    -e LEAPAI_AUTOCV_IFRAME_TYPE=${LEAPAI_AUTOCV_IFRAME_TYPE} \
    -e LEAPAI_ONLINE_FRAMEWORK_NAME=${LEAPAI_ONLINE_FRAMEWORK_NAME} \
    -e LEAPAI_ONLINE_FRAMEWORK_VERSION=${LEAPAI_ONLINE_FRAMEWORK_VERSION} \
    -p ${AUTOCV_HOST_PORT}:80 \
    -v ${STORAGRE}:/home/autocv/storage \
    -v ${LOGS}:/home/autocv/logs \
    -v ${LEAPAI_FS}:/home/fs \
    -v ${SSL_CERTIFICATE}:/etc/nginx/ssl/nginx.crt \
    -v ${SSL_CERTIFICATE_KEY}:/etc/nginx/ssl/nginx.key \
    autocv:v1.1_deploy_update