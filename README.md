# NOTE
This is a copy of a repository existing outside of GitHub, for the original version, check here: https://git.nefald.fr/docker/geyser/-/tree/master/

# ![](https://git.nefald.fr/uploads/-/system/project/avatar/219/Geyser.png?width=48) Geyser (standalone) - Unofficial Docker image

[GeyserMC](https://geysermc.org/) allow clients from Minecraft Bedrock Edition to join your Minecraft Java server.
With this Docker image, you can launch a GeyserMC standalone server, to proxy your Minecraft Bedrock's players connection, to your Minecraft Java Edition server.


**This is an unofficial Docker Image developped by [Hiob](https://hiob.fr) for [Nefald Community](https://nefald.fr)**.


## Geyser: Documentation and setup
Always refer you to [GeyserMC documentation](https://github.com/GeyserMC/Geyser/wiki).

## Usage 
You can find support and updated documentation on our [Gitlab](https://git.nefald.fr/docker/geyser), also you can discuss and join us on our [Discord](https://nfald.fr/discord).

### Docker-compose
Here a sample of `docker-compose.yml` with **Geyser** and **Paper**:

```
version: '3.7'

services:
  Paper:
    image: nefald/paper:latest
    container_name: Paper
    restart: unless-stopped
    stdin_open: true
    tty: true

    ports:
      #Bluemap
      - 8100:8100/tcp
      - 8100:8100/udp 

      #Minecraft
      - 25565:25565/tcp
      - 25565:25565/udp

      #RCON
      - 25575:25575/tcp
      - 25575:25575/udp

    volumes:
      - '/path/to/local/folder:/data:rw'
      
    environment:
      - TZ=Europe/Paris

  Geyser:
    image: nefald/geyser:latest
    container_name: Geyser
    restart: unless-stopped
    stdin_open: true
    tty: true
    ports:
      - 19132:19132/tcp
      - 19132:19132/udp 
      
    volumes:
      - '/path/to/local/folder:/data:rw'
    environment:
      - OVERWRITE_CONFIG=false
      - BEDROCK_ADDRESS=0.0.0.0
      - BEDROCK_PORT=19132
      - BEDROCK_MOTD1=GeyserMC
      - BEDROCK_MOTD2="Minecraft server (GeyserMC)"
      - BEDROCK_SERVERNAME=ServerName
      - REMOTE_ADDRESS=PaperMC
      - REMOTE_PORT=25565      
      - REMOTE_AUTH_TYPE=floodgate    
```

### Environment variables
Please, refer to [GeyserMC wiki](https://github.com/GeyserMC/Geyser/wiki/Understanding-the-Config) for an update and complete understand of config. Environment variables are relate to config options.


| Variable  | Default  | Description  |
|---|---|---|
|**INIT_MEMORY**|1024M|Min memory allocated to GeyserMC.|
|**MAX_MEMORY**|1024M|Max memory allocated to GeyserMC.|
|**OVERWRITE_CONFIG**|false|Overwrite config file with Docker run (or docker-compose) variables?|
|**BEDROCK_ADDRESS**|0.0.0.0|The address of Geyser on the bedrock end.|
|**BEDROCK_PORT**|19132|The port Geyser will run on.|
|**BEDROCK_MOTD1**|GeyserMC|The first line of the MOTD for Geyser.|
|**BEDROCK_MOTD2**|Another GeyserMC forced host.|The second line of the MOTD for Geyser. Please keep in mind, this option will only work if Geyser is shown in the Friends tab!|
|**BEDROCK_SERVERNAME**|GeyserMC Server|The world name that is shown in the top-right area of the pause screen.|
|**BEDROCK_ENABLE_PROXY_PROTOCOL**|false|Whether to enable PROXY protocol or not for clients. You DO NOT WANT this feature unless you run UDP reverse proxy.|
|**REMOTE_ADDRESS:**|127.0.0.1|The address of the Minecraft: Java Edition server|
|**REMOTE_PORT**|25565|The port of the Minecraft: Java Edition server|
|**REMOTE_AUTH_TYPE**|online|The authentication type of the Minecraft: Java Edition server.|
|**REMOTE_ALLOW_PASS_AUTH**|true|Allow for password-based authentication methods through Geyser. Only useful in online mode.|
|**REMOTE_USE_PROXY_PROTOCOL**|false|Whether to enable PROXY/HAProxy protocol or not while connecting to the server.|
|**REMOTE_FORWARD_HOSTNAME**|false|Forwards the hostname/IP address that the Bedrock client used to connect over to the Java server.|
|**GEYSER_FLOODGATE_KEY_FILE**|key.pem|The key file path for Floodgate.|
|**GEYSER_COMMAND_SUGGESTIONS**|true|Bedrock clients freeze or crash when opening up the command prompt for the first time with a large amount of command suggestions.|
|**GEYSER_PASSTHROUGH_MOTD**|false|If the MOTD should be relayed from the remote server. Causes the motd1 and motd2 options in the bedrock section to no longer have a use.|
|**GEYSER_PASSTHROUGH_PROTOCOL_NAME**|false|Relay the protocol name (e.g. BungeeCord [X.X], Paper 1.X) - this is only really useful when using a custom protocol name! This will also show up on sites like MCSrvStatus. <mcsrvstat.us>|
|**GEYSER_PASSTHROUGH_PLAYER_COUNTS**|false|If the current and max player counts should be relayed from the remote server.|
|**GEYSER_PASSTHROUGH_LEGACY_PING**|false|If enabled, manually pings the server by impersonating a Minecraft client instead of using the server's API.|
|**GEYSER_PASSTHROUGH_INTERVAL**|3|How often the fake Minecraft client should attempt to ping the remote server to update information, in seconds.|
|**GEYSER_MAX_PLAYER**|100|The maximum amount of players shown when pinging the server.|
|**GEYSER_DEBUG**|false|If debug messages should be printed in console.|
|**GEYSER_GENERAL_THREAD_POOL**|32|The amount of threads Geyser will be able to use.|
|**GEYSER_ALLOW_THIRD_PARTY_CAPES**|true|If third party (Optifine, 5zig, LabyMod, etc.) capes should be displayed to the bedrock player.|
|**GEYSER_ALLOW_THIRD_PARTY_EARS**|false|If third party Deadmau5-style ears should be enabled. Currently only supports MinecraftCapes.|
|**GEYSER_SHOW_COOLDOWN**|title|Bedrock Edition currently does not have Java Edition 1.9+ combat mechanics. In order to get around this, Geyser sends a fake cooldown by sending a title message.|
|**GEYSER_SHOW_COORDINATES**|true|Bedrock Edition has an option to show coordinates in the top-left part of your screen.|
|**GEYSER_EMOTE_OFFHAND_WORKAROUND**|disabled|Since Java Edition 1.9, clients have had the ability to switch the item in their mainhand and offhand with a keybind. Bedrock Edition does not have this ability, so this config option makes up for it, If set, when a Bedrock player performs any emote, it will swap the offhand and mainhand items, just like the Java Edition keybind. Should be *disabled*, *no-emotes* or *emotes-and-offhand*.|
|**GEYSER_DEFAULT_LOCALE**|en_us|The default locale to send to players if their locale could not be found. Check [this page](https://github.com/GeyserMC/Geyser/wiki/FAQ#what-languages-does-geyser-support) to find the code corresponding to your language.|
|**GEYSER_CACHE_IMAGES**|0|Specify how many days images will be cached to disk to save downloading them from the internet. A value of 0 is disabled.|
|**GEYSER_ALLOW_CUSTOM_SKULLS**|true|Allows custom skulls to be displayed when placed. Keeping them enabled may cause a performance decrease on older/weaker devices.|
|**GEYSER_ADD_NON_BEDROCK_ITEMS**|true|Whether to add (at this time, only) the furnace minecart as a separate item in the game, which normally does not exist in Bedrock Edition.|
|**GEYSER_ABOVE_BEDROCK_NETHER_BUILDING**|false|Bedrock prevents building and displaying blocks above Y127 in the Nether - enabling this config option works around that by changing the Nether dimension ID to the End ID.|
|**GEYSER_FORCE_RESOURCE_PACKS**|true|Force clients to load all resource packs if there are any. If set to false, it allows the user to disconnect from the server if they don't want to download the resource packs.|
|**GEYSER_XBOX_ACHIEVEMENTS_ENABLED**|false|Allows Xbox achievements to be unlocked.|
|**GEYSER_METRICS_ENABLED**|false|If metrics should be enabled.|
|**GEYSER_METRICS_UUID**|generateduuid|UUID of server, don't change!|


## LICENSE 

This image is based on [rveachkc/geyser-docker](https://github.com/rveachkc/geyser-docker) (under [MIT LICENSE](https://git.nefald.fr/docker/geyser/-/blob/master/LICENSE)).


## Logo
Original logo was designed by [Georgiana Ionescu](https://thenounproject.com/icon/2018185/), releases under [CCBY](https://creativecommons.org/licenses/by/3.0/us/legalcode) license.
