#!/bin/bash

# names.txt will have to be provided with a list of package names
# separated by a line
# ex.
# xonsh
# event-model

# This script will:

# 1. create a dependency graph of feedstocks
# 2. update version numbers in the dependency graph
# 3. create migrations, but not run them
# 4. run migrations and submit pull requests on GitHub for the nsls-ii-forge
# 5. display the status of migrations/pull requests

# This will use ~/.conda-smithy authentication for GitHub token
# It will use nsls2forge username on GitHub
# It will not fork repositories but instead create new branches
# It will use a max of 10 workers to build the graph

# If something goes wrong while executing this script
# please use 'auto-tick clean', fix the issue, and try again

# will stop execution if error occurs
set -e

# activate environment from setup.sh
source ~/mc/etc/profile.d/conda.sh
conda env list
conda activate botenv

# clone graph repo to get cached graph
git clone --depth 1 https://github.com/nsls-ii-forge/auto-tick-graph.git
# cp names.txt ./auto-tick-graph/
cd ./auto-tick-graph/

# list of packages to be updated (in graph)
# echo "=================="
# cat names.txt
# echo "=================="

# create graph with node_attrs/* and graph.json
time graph-utils make -o nsls-ii-forge -m 10

# update graph with new versions from their sources (see versions/*)
time graph-utils update

# move out of auto-tick-graph
cd ..

# copy graph files
cp -v ./auto-tick-graph/graph.json ./
cp -rv ./auto-tick-graph/node_attrs ./
# need checks for these since they might not be generated yet
if [ -d "./auto-tick-graph/pr_json" ]; then
    cp -rv ./auto-tick-graph/pr_json ./
fi
if [ -d "./auto-tick-graph/status" ]; then
    cp -rv ./auto-tick-graph/status ./
fi

# dry run of migrations to catch errors before PRs
auto-tick run --dry-run

# full run of migrations and submit PRs (see pr_json/*)
time auto-tick run

# output status of migrations to status/*
auto-tick status
cat ./status/could_use_help.json
cat ./status/version_status.json

# copy changed files back
cp -v graph.json ./auto-tick-graph
cp -rv ./node_attrs ./auto-tick-graph
cp -rv ./pr_json ./auto-tick-graph
cp -rv ./status ./auto-tick-graph
cd ./auto-tick-graph

# push changes to graph repo
git stash
git pull --all
git stash pop
git add .
if [ ! -z "$BUILD_BUILDNUMBER" ]; then
    commit_msg="Update graph from auto-tick-bot [${BUILD_BUILDNUMBER}]"
else
    commit_msg="Update graph from auto-tick-bot [local $(hostname)]"
fi
git commit -m "${commit_msg}" || echo "Nothing to commit"
git push origin master
cd ..
# cleanup
rm -rfv ./auto-tick-graph
auto-tick clean -y
