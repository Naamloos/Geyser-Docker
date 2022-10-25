#! /bin/bash

CONFIG_FILE=/data/config.yml

cd /data

if [ ! -f $CONFIG_FILE ] || [ "$OVERWRITE_CONFIG" == "true" ]
then
    envsubst < /opt/config.yml.template > /data/config.yml
fi

java -Xms$INIT_MEMORY -Xmx$MAX_MEMORY -XX:+UnlockDiagnosticVMOptions -XX:-UseAESCTRIntrinsics -jar /opt/Geyser.jar
