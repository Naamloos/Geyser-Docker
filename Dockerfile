# FROM OpenJDK
ARG JAVA_VERSION=17
FROM openjdk:${JAVA_VERSION}-slim AS build

# MAINTAINED by Nefald community
LABEL maintainer="nefald <contact@nefald.fr>"
LABEL author="hiob <hello@hiob.fr>"

# Container general settings
VOLUME /data
EXPOSE 19132

# Build type
ARG BUILD_TYPE=lastSuccessfulBuild

# Java Start Options
ENV INIT_MEMORY "1024M"
ENV MAX_MEMORY "1024M"

# this will force a config rewrite every time.
ENV OVERWRITE_CONFIG "false"

# Bedrock server config
ENV BEDROCK_ADDRESS "0.0.0.0"
ENV BEDROCK_PORT "19132"
ENV BEDROCK_MOTD1 "GeyserMC"
ENV BEDROCK_MOTD2 "Another GeyserMC forced host."
ENV BEDROCK_SERVERNAME "GeyserMC Server"
ENV BEDROCK_ENABLE_PROXY_PROTOCOL "false"

# Remote Server Config (java server)
ENV REMOTE_ADDRESS "127.0.0.1"
ENV REMOTE_PORT "25565"
ENV REMOTE_AUTH_TYPE "online"
ENV REMOTE_ALLOW_PASS_AUTH "true"
ENV REMOTE_USE_PROXY_PROTOCOL "false"
ENV REMOTE_FORWARD_HOSTNAME "false"

# Ignore if not using floodgate
ENV GEYSER_FLOODGATE_KEY_FILE "key.pem"

# Geyser General Config
ENV GEYSER_COMMAND_SUGGESTIONS "true"
ENV GEYSER_PASSTHROUGH_MOTD "false"
ENV GEYSER_PASSTHROUGH_PROTOCOL_NAME "false"
ENV GEYSER_PASSTHROUGH_PLAYER_COUNTS "false"
ENV GEYSER_PASSTHROUGH_LEGACY_PING "false"
ENV GEYSER_PASSTHROUGH_INTERVAL "3"

ENV GEYSER_MAX_PLAYER "100"
ENV GEYSER_DEBUG "false"
ENV GEYSER_GENERAL_THREAD_POOL "32"
ENV GEYSER_ALLOW_THIRD_PARTY_CAPES "true"
ENV GEYSER_ALLOW_THIRD_PARTY_EARS "false"
ENV GEYSER_SHOW_COOLDOWN "title"
ENV GEYSER_SHOW_COORDINATES "true"
ENV GEYSER_EMOTE_OFFHAND_WORKAROUND "disabled"
ENV GEYSER_DEFAULT_LOCALE "en_us"
ENV GEYSER_CACHE_IMAGES "0"
ENV GEYSER_ALLOW_CUSTOM_SKULLS "true"
ENV GEYSER_ADD_NON_BEDROCK_ITEMS "true"
ENV GEYSER_ABOVE_BEDROCK_NETHER_BUILDING "false"
ENV GEYSER_FORCE_RESOURCE_PACKS "true"
ENV GEYSER_XBOX_ACHIEVEMENTS_ENABLED "false"

# Geyser Metrics Config
ENV GEYSER_METRICS_ENABLED "false"
ENV GEYSER_METRICS_UUID; "generateduuid"

RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*

ADD https://ci.nukkitx.com/job/GeyserMC/job/Geyser/job/master/$BUILD_TYPE/artifact/bootstrap/standalone/target/Geyser.jar /opt/Geyser.jar

COPY start.sh /usr/local/bin/start.sh
COPY config.yml.template /opt/config.yml.template

CMD /bin/bash /usr/local/bin/start.sh
