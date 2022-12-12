#!/bin/bash

docker run -d -p 25565:25565 -v $(pwd)/files:/server/ --rm -it dockers:mc_vanilla

exit 0
