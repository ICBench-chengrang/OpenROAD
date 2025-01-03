# Target with dependencies to build all flow tools from their sources.
# i.e., "./build_openroad.sh --local" from inside a docker container
# NOTE: don't use this file directly unless you know what you are doing,
# instead use etc/DockerHelper.sh

ARG fromImage=openroad/flow-ubuntu22.04-dev:latest

FROM $fromImage AS orfs-base

WORKDIR /OpenROAD-flow-scripts
COPY --link dev_env.sh dev_env.sh
COPY --link build_openroad.sh build_openroad.sh

FROM orfs-base AS orfs-builder-base

COPY --link tools tools
ARG numThreads=$(nproc)

RUN echo "" > tools/yosys/abc/.gitcommit && \
  env CFLAGS="-D__TIME__=0 -D__DATE__=0 -D__TIMESTAMP__=0 -Wno-builtin-macro-redefined" \
  CXXFLAGS="-D__TIME__=0 -D__DATE__=0 -D__TIMESTAMP__=0 -Wno-builtin-macro-redefined" \
  ./build_openroad.sh --no_init --local --threads ${numThreads}

FROM orfs-base

# The order for copying the directories is based on the frequency of changes (ascending order),
# and the layer size (descending order)
COPY --link docker docker
COPY --link flow/tutorials flow/tutorials
COPY --link docs docs
COPY --link flow/test flow/test
COPY --link flow/platforms flow/platforms
COPY --link flow/util flow/util
COPY --link flow/scripts flow/scripts
COPY --link flow/designs flow/designs
COPY --link tools/AutoTuner tools/AutoTuner

# Manually exclude unnecessary directories and files
RUN rm -rf .git* tools/ docs/ docker/ flow/designs flow/platforms \
       flow/scripts flow/test flow/tutorials flow/util
COPY . ./
COPY --from=orfs-builder-base /OpenROAD-flow-scripts/tools/install tools/install
