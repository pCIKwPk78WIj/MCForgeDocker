# MC FORGE manager with docker

## New repo, what's dis?
Basically a docker image and a bash script. It runs a minecraft forge server inside a minimal docker container.

## What do I need to run this?
- I tested on Debian 11 (Bullseye), but should work in bascially any GNU/Linux distribution.
- You will need the docker service running, and preferably your user added to the `docker` group.
- OpenJDK/Java on the host OS to run the `upgrade` function, the `java` executable shall be in your path.

## Usage
### Run the script without any parameter and it will help you.
### Parameters
    - --run or -r               : starts the minecraft forge server in the built docker container.
    - --upgrade or -u <file>    : upgrades the minecraft forge server with the given parameter. Before the upgrade, it will save the important files.
    - --save or -s              : saves the important files into a directory.
    - --build or -b             : builds the docker image.

### Ok. But how do I use this?
- `git clone https://github.com/pCIKwPk78WIj/MCForgeDocker.git`
- `cd MCForgeDocker`
- `/bin/bash manage_server.sh --build`
- Optionally `/bin/bash manager_server.sh --update <path to newer version of forge JAR file>`
- `/bin/bash manage_server.sh --run`

## What are the "important files"?
- server.properties 
- eula.txt
- user_jvm_args.txt
- run.sh
- your world directory (default name: world)
- the mods directory

## Why?
* be me
* want to run a minecraft forge server self-hosted to play with friends
* find nothing similar due to alarmly bad searching skills and smooth brain
* write this script to manage the minecraft forge server running in a __minimalist__ docker
* upload it to github and forget about it forever
* spend at least 45 mins writing this README.md which will read nobody

## There is a feature which I miss ;_;
Then feel to contribute and extend the script.
