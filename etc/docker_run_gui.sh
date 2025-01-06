#!/usr/bin/bash

image=openroad/flow-ubuntu22.04-builder:latest
docker run --rm -it \
	-u $(id -u ${USER}):$(id -g ${USER}) \
	-v $(pwd)/flow:/OpenROAD-flow-scripts/flow \
	-e DISPLAY=${DISPLAY} \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ${HOME}/.Xauthority:/.Xauthority \
	--network host \
	--security-opt seccomp=unconfined \
	$image
