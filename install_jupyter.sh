#!/bin/bash

# env variables
CONDA_DIR=${HOME}/miniconda3
CONDA_BIN=${CONDA_DIR}/bin
JUPYTER_SATURN_VERSION=2022.01.06-1

set -ex
export PATH="${CONDA_BIN}:${PATH}"

# create workspace and move the examples from the start
mkdir -p $HOME/workspace
rm -rf $HOME/workspace/saturn-examples
cd ${HOME}/workspace
git clone https://github.com/kywch/saturn-examples.git

cd ${HOME}

echo "installing root env:"

# download Saturn jupyter server yml
URL="https://raw.githubusercontent.com/saturncloud/images/main/saturnbase-gpu/environment.yml"
export JUPYTER_SATURN_VERSION
wget --quiet $URL -O jupyter-temp.yml
envsubst < jupyter-temp.yml > jupyter.yml

cat jupyter.yml
conda install -c conda-forge mamba
mamba env update -n root  -f jupyter.yml

conda clean -afy
jupyter lab clean
jlpm cache clean
npm cache clean --force
find ${CONDA_DIR}/ -type f,l -name '*.pyc' -delete
find ${CONDA_DIR}/ -type f,l -name '*.a' -delete
find ${CONDA_DIR}/ -type f,l -name '*.js.map' -delete
rm -rf $HOME/.node-gyp
rm -rf $HOME/.local

# post install env setup
mkdir -p $HOME/npm
export NPM_DIR=$HOME/npm
export NB_PYTHON_PREFIX=$CONDA_DIR/envs/saturn
export PATH="${NB_PYTHON_PREFIX}/bin:${CONDA_BIN}:${NPM_DIR}/bin:${HOME}/.local/bin:${PATH}"

conda create -n saturn
