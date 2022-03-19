#!/bin/bash

# env variables
CONDA_DIR=${HOME}/miniconda3
CONDA_BIN=${CONDA_DIR}/bin
JUPYTER_SATURN_VERSION=2022.01.06-1

set -ex
export PATH="${CONDA_BIN}:${PATH}"


echo "installing mamba:"
conda install -c conda-forge mamba


echo "installing root env:"
mamba env update -n root -f saturnbase-gpu-11.2.yml

conda clean -afy
jupyter lab clean
jlpm cache clean
npm cache clean --force
rm -rf $HOME/.node-gyp
rm -rf $HOME/.local


echo "installing saturn-rapids:"
mamba env create -f saturn-rapids.yml

${CONDA_DIR}/envs/saturn-rapids/bin/python -m ipykernel install \
        --name saturn-rapids \
        --display-name 'RAPIDS' \
        --prefix=${CONDA_DIR}


echo "installing saturn-pytorch:"
mamba env create -f saturn-pytorch.yml

${CONDA_DIR}/envs/saturn-pytorch/bin/python -m ipykernel install \
        --name saturn-pytorch \
        --display-name 'pytorch' \
        --prefix=${CONDA_DIR}


echo "installing saturn-tensorflow:"
mamba env create -f saturn-tensorflow.yml

${CONDA_DIR}/envs/saturn-tensorflow/bin/python -m ipykernel install \
        --name saturn-tensorflow \
        --display-name 'tensorflow' \
        --prefix=${CONDA_DIR}


echo "cleaning conda:"

${CONDA_DIR}/bin/conda clean -afy 

find ${CONDA_DIR}/ -name '*.pyc' \( -type f -o -type l \) -delete
find ${CONDA_DIR}/ -name '*.a' \( -type f -o -type l \) -delete
find ${CONDA_DIR}/ -name '*.js.map' \( -type f -o -type l \) -delete


echo "creating the workspace:"
# create workspace and move the examples from the start
mkdir -p $HOME/workspace
rm -rf $HOME/workspace/saturn-examples
cd ${HOME}/workspace
git clone https://github.com/kywch/saturn-examples.git
