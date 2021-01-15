#!/bin/bash
export AUTOCV_HOST_PORT=7080
export SSL_CERTIFICATE=/home/xzhou/autocv/autocv_beijing/autocv_release-1.3/autocv/cert.crt
export SSL_CERTIFICATE_KEY=/home/xzhou/autocv/autocv_beijing/autocv_release-1.3/autocv/cert.key

export STORAGRE=/mnt/bigdata-cv-2019-1/autocv/storage
export LOGS=/mnt/bigdata-cv-2019-1/autocv/logs
export LEAPAI_FS=/mnt/bigdata-cv-2019-1/fs

# mysql setting
export MYSQL_DATABASE=autocv_xzhou3
export MYSQL_USER=autocv_user_xzhou3
export MYSQL_USER_PASSWORD=autocv_user_xzhou3_password
export MYSQL_HOST=10.127.3.197
export MYSQL_PORT=3306

# redis setting
export REDIS_HOST=10.127.3.197
export REDIS_PORT=6379
export REDIS_DB=14
export REDIS_PASSWORD=

# autocv setting
export SUPPORT_TYPE=ALL

# leapai setting
export LEAPAI_HOST=https://10.127.3.200
export AUTOCV_IMAGE_NAME=system/autocv:v1.3.2_deploy
export LEAPAI_AUTOCV_IFRAME_TYPE=independent
export LEAPAI_ONLINE_FRAMEWORK_NAME=AutoCV
export LEAPAI_ONLINE_FRAMEWORK_VERSION=OCR
export LEAPAI_ONLINE_FRAMEWORK_TENSORPACK=Tensorpack

docker run -d \
    --runtime=nvidia \
    --restart=always \
    --name autocv1.3.2_deploy_local \
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
    -e LEAPAI_ONLINE_FRAMEWORK_TENSORPACK=${LEAPAI_ONLINE_FRAMEWORK_TENSORPACK} \
    -p ${AUTOCV_HOST_PORT}:80 \
    -v ${STORAGRE}:/home/autocv/storage \
    -v ${LOGS}:/home/autocv/logs \
    -v ${LEAPAI_FS}:/home/fs \
    -v ${SSL_CERTIFICATE}:/etc/nginx/ssl/nginx.crt \
    -v ${SSL_CERTIFICATE_KEY}:/etc/nginx/ssl/nginx.key \
    autocv:v1.3.2_deploy
