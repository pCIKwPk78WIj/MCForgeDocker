#!/bin/bash

BASEDIR="$PWD/$(dirname $0)"
SHARED="files"
BUILD="build"
IMAGETAG="dockers:mc"
WORLDNAME="world"

echo '  __  __  _____   ______ ____  _____   _____ ______                                               '
echo ' |  \/  |/ ____| |  ____/ __ \|  __ \ / ____|  ____|                                              '
echo ' | \  / | |      | |__ | |  | | |__) | |  __| |__     _ __ ___   __ _ _ __   __ _  __ _  ___ _ __ '
echo ' | |\/| | |      |  __|| |  | |  _  /| | |_ |  __|   | `_ ` _ \ / _` | `_ \ / _` |/ _` |/ _ \ `__|'
echo ' | |  | | |____  | |   | |__| | | \ \| |__| | |____  | | | | | | (_| | | | | (_| | (_| |  __/ |   '
echo ' |_|  |_|\_____| |_|    \____/|_|  \_\\_____|______| |_| |_| |_|\__,_|_| |_|\__,_|\__, |\___|_|   '
echo '                                                                                   __/ |          '
echo '                                                                                  |___/           '
echo '                                                                                       with docker'

function save(){
    SAVEDIR="SAVE_$(date +%Y-%m-%d_%H%M%S)"
    if [ -d $BASEDIR/$SAVEDIR ]; then
        echo "[ERROR] Save directory already exists!"
        exit 1
    fi
    mkdir $BASEDIR/$SAVEDIR
    cp -v $BASEDIR/$SHARED/server.properties $BASEDIR/$SAVEDIR/
    cp -rv $BASEDIR/$SHARED/$WORLDNAME $BASEDIR/$SAVEDIR/
    cp -v $BASEDIR/$SHARED/user_jvm_args.txt $BASEDIR/$SAVEDIR/
    cp -v $BASEDIR/$SHARED/eula.txt $BASEDIR/$SAVEDIR/
    cp -rv $BASEDIR/$SHARED/mods $BASEDIR/$SAVEDIR/
    cp -v $BASEDIR/$SHARED/run.sh $BASEDIR/$SAVEDIR/
}

if [ ! -d "$BASEDIR/$SHARED" ]; then
    echo "[ERROR] There is no directory called $BASEDIR/$SHARED"
    exit 1
fi

case "$1" in
    "--run" | "-r")
        DOCKER_ID=$(docker run -d -p 25565:25565 -v $BASEDIR/$SHARED:/server/ --rm -it $IMAGETAG)
        docker attach $DOCKER_ID
        exit 0
    ;;

    "--upgrade" | "-u")

        if [ "$2" == "" ]; then
            echo "[ERROR] Please specify the file!" 
            exit 1
        fi
        
        if [ ! -f $2 ]; then
            echo "[ERROR] Cannot find the file $2!"
            exit 1
        fi 

        echo "[INFO] Saving the important files."
        save 
        echo "[INFO] Saving done, files are stored at $BASEDIR/$SAVEDIR."    
 
        echo "[INFO] Installing new server."
        rm -r $BASEDIR/$SHARED/libraries
        java -jar $2 --installServer $BASEDIR/$SHARED
        echo "[INFO] Upgrade process finished."
        exit 0 
    ;;

    "--build" | "-b")
        echo "[INFO] Starting to build."
        if [ ! -d $BASEDIR/$BUILD ]; then
            echo "[ERROR] There is no build directory at $BASEDIR/$BUILD"
            exit 1
        fi
        
        if [ ! -f $BASEDIR/$BUILD/Dockerfile ]; then
            echo "[ERROR] Missing Dockerfile at $BASEDIR/$BUILD"
            exit 1
        fi

        cd $BASEDIR/$BUILD
        docker build . -t $IMAGETAG
        echo "[INFO] Building done."
        exit 0
    ;;

    "--save" | "-s")
        echo "[INFO] Starting to save the important files."
        save
        echo "[INFO] Saving finished, saved files at $BASEDIR/$SAVEDIR."
        exit 0
    ;;

esac

echo "USAGE: /bin/bash $0 [function]"
echo "Available functions:"
echo -e "\t--run\t\tor\t-r\t\t\tstarts the server in docker."
echo -e "\t--upgrade\tor\t-u <file to upgrade>\tupgrades the server, but before saves the important files."
echo -e "\t--save\t\tor\t-s\t\t\tsaves the important files (world,mods,server.properties, eula.txt)."
echo -e "\t--build\t\tor\t-b\t\t\tbuilds the docker image."

exit 0
