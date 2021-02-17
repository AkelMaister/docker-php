# Quick reference:

Builded image available on [hub.docker.com](https://hub.docker.com/r/akel/php)

## Environment variables:

`BLACKFIRE_ENABLE` - set `true` for enable blackfire php probe

`BLACKFIRE_AGENT_URL` - set fqdn name or ip address of blackfire agent. Default: `127.0.0.1`. Applies only when the value of the variable `BLACKFIRE_ENABLE` is set to `true`.

`BLACKFIRE_AGENT_PORT` - set port of blackfire agent. Default: `8707`. Applies only when the value of the variable `BLACKFIRE_ENABLE` is set to `true`.

`BLACKFIRE_LOG_LEVEL` - set log level from `1` to `4`. Default: `1`. Applies only when the value of the variable `BLACKFIRE_ENABLE` is set to `true`.

`BLACKFIRE_LOG_FILE` - set log file for blackfire. Default `/dev/null`. Applies only when the value of the variable `BLACKFIRE_ENABLE` is set to `true`.

`ENV_SYMLINK_ENABLE` - set `true` if need to create symlink to env file. May be helpfull if you use vault injector with kubernetes.

`ENV_SYMLINK_SRC` - set source path for .env file. Default `/vault/secrets/env`. Applies only when the value of the variable `ENV_SYMLINK_ENABLE` is set to `true`.

`ENV_SYMLINK_DST` - set destination of .env file. Default `/app/.env`. Applies only when the value of the variable `ENV_SYMLINK_ENABLE` is set to `true`.

`PHP_CRONTABS_PATH` - set path to crontab include.

`PHP_COMMAND_RUN` - set `true` if need to run additional command. 

`PHP_COMMAND` - set full command to run. Applies only when the value of the variable `PHP_COMMAND_RUN` is set to `true`.

`SUPERVISORD_PATH` - set path to supervisord config. 

`PHP_INI_PATH` - set path to ini file.

`PHP_POOL_PATH` - set path to php pool config.

`PHP_BOOT_SCRIPTS` - set path to custom scripts what will be run at startup.

`XDEBUG_ENABLE` - set `true` if you want to enable xdebug php module

## Create php user

Must be set all of variables:

`PHP_USER` - set php user name.

`PHP_UID` - set php user id.

`PHP_GID` - set php user group id.

`PHP_HOME` - set homedir for php user.

# Build new Docker images
```
./build.sh
```
# Push images
```
docker image ls akel/php | grep -v "TAG" | awk '{print $2}' | grep -v "none" | tac | xargs -I {} docker push akel/php:{}
```
# Get image list for README on [hub.docker.com](https://hub.docker.com/r/akel/php)
```
for iid in $(docker image ls akel/php | grep -v "TAG" | awk '{print $3}' | uniq) ; do printf "* "; docker image ls | grep $iid | awk '{print $2}' | awk '{ print length(), $0 | "sort -rn" }' | awk '{print "`"$NF"`"}' | tr '\n' ' '; echo; echo; done
```
