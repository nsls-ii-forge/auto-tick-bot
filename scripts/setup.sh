#!/bin/bash

# This script sets up the proper environment for the auto-tick bot

if [ "$1" == "verbose" ]; then
    VERBOSE="-v"
else
    VERBOSE=""
fi

PYTHON_VERSION=3.7


# git setup
git config --global user.email nsls2forge@gmail.com
git config --global user.name nsls2forge

# netrc setup for authentication
echo "machine github.com" > $HOME/.netrc
echo "login $GITHUB_USERNAME" >> $HOME/.netrc
echo "password $GITHUB_TOKEN" >> $HOME/.netrc
chmod -v 600 $HOME/.netrc

# install miniconda
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p ~/mc
source ~/mc/etc/profile.d/conda.sh

# installation
conda info
conda create -y -n botenv python=${PYTHON_VERSION}
conda activate botenv

# Install the tools for bot:
## conda install -y git
## pip install git+https://github.com/nsls-ii-forge/nsls2forge-utils
# better use a package
conda install -y -c nsls2forge nsls2forge-utils

# Install conda-smithy separatly from conda-forge as we don't want to make it
# an explicit dependency:
conda install -y -c conda-forge conda-smithy

# Install cf-scripts from a specific commit:
pip install git+https://github.com/regro/cf-scripts@db87055b000e0ce9ea2fa5a82f55be0fb15613f2

wget https://raw.githubusercontent.com/regro/cf-scripts/master/requirements/run
echo "================"
cat run | sort -u
echo "================"
conda install -y -c conda-forge --file run

rm -f ${VERBOSE} run

# List the final state of the environment
conda list --show-channel-url
conda info
