#!/bin/bash

# env variables
CONDA_DIR=${HOME}/miniconda3
CONDA_BIN=${CONDA_DIR}/bin

set -ex
export PATH="${CONDA_BIN}:${PATH}"

echo "installing saturn:"

conda env update -n saturn --file $1

${CONDA_DIR}/envs/saturn/bin/python -m ipykernel install \
        --name python3 \
        --display-name 'saturn (Python 3)' \
        --prefix=${CONDA_DIR}

${CONDA_DIR}/bin/conda clean -afy 

find ${CONDA_DIR} -type f,l -name '*.pyc' -delete
find ${CONDA_DIR} -type f,l -name '*.a' -delete && \
find ${CONDA_DIR} -type f,l -name '*.js.map' -delete
echo '' > ${CONDA_DIR}/envs/saturn/conda-meta/history
