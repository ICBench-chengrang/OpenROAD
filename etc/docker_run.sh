#!/usr/bin/bash

image=openroad/flow-ubuntu22.04-builder:latest

docker run --rm -it \
	-u $(id -u ${USER}):$(id -g ${USER}) \
	-v $(pwd)/flow:/OpenROAD-flow-scripts/flow \
	$image
