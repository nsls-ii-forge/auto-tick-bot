#!/bin/bash

# This script sets up the proper environemnt for
# the auto-tick bot

# install miniconda
wget https://repo.continuum.io/miniconda/Miniconda3-latest-${arch}-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p ~/mc
source ~/mc/etc/profile.d/conda.sh

# netrc setup for authentication
echo "machine github.com" > $HOME/.netrc
echo "login $GITHUB_USERNAME" >> $HOME/.netrc
echo "password $GITHUB_TOKEN" >> $HOME/.netrc
chmod -v go-rw $HOME/.netrc

# installation
conda create -n botenv python=3.7 -y
conda activate botenv
conda install -c conda-forge conda-smithy -y
pip install nsls2forge-utils
conda list --show-channel-url
conda info
pip install git+https://github.com/regro/cf-scripts@db87055b000e0ce9ea2fa5a82f55be0fb15613f2
wget https://raw.githubusercontent.com/regro/cf-scripts/master/requirements/run
conda install -c conda-forge --file run -y
rm -fv run
