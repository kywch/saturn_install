#!/bin/bash

# env variables
CONDA_DIR=${HOME}/miniconda3
CONDA_BIN=${CONDA_DIR}/bin
JUPYTER_SATURN_VERSION=2021.04.19

set -ex
export PATH="${CONDA_BIN}:${PATH}"

# create workspace and move the examples from the start
mkdir -p $HOME/workspace
rm -rf $HOME/workspace/saturn-examples
mv examples $HOME/workspace/saturn-examples

cd ${HOME}

echo "updating conda:"

# Update conda
conda update -y conda

# Allow easy direct installs from conda forge
conda config --system --add channels conda-forge
conda config --system --set auto_update_conda false
conda config --system --set show_channel_urls true

echo "installing root env:"

# download Saturn jupyter server yml
URL="https://raw.githubusercontent.com/saturncloud/images/main/saturnbase-gpu/environment.yml"
export JUPYTER_SATURN_VERSION
wget --quiet $URL -O jupyter-temp.yml
envsubst < jupyter-temp.yml > jupyter.yml

cat jupyter.yml
conda env update -n root -f jupyter.yml
jupyter serverextension enable --sys-prefix jupyter_server_proxy
jupyter serverextension enable --py jsaturn --sys-prefix
jupyter serverextension enable dask_labextension --sys-prefix
jupyter serverextension enable --py jupyterlab_code_formatter --sys-prefix

jupyter labextension install @bokeh/jupyter_bokeh
jupyter labextension install @jupyter-widgets/jupyterlab-manager
jupyter labextension install dask-labextension@3.0.0
jupyter labextension install @ryantam626/jupyterlab_code_formatter@1.3.8
jupyter labextension install @pyviz/jupyterlab_pyviz
jupyter labextension install jupyterlab-execute-time
jupyter labextension install @telamonian/theme-darcula
jupyter labextension install jupyterlab-python-file

cd ${CONDA_DIR}/jsaturn_ext
npm install
npm run build
jupyter labextension install

cd ${HOME}
rm -rf ${CONDA_DIR}/jsaturn_ext

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
