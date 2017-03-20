#!/bin/bash

set -x -e
echo $PATH
pwd
ls
cd qiime2-source
pwd
ls
conda build -c https://conda.anaconda.org/qiime2 -c defaults --override-channels --output-folder ../builds --python 3.5 ci/recipe
cd ..
pwd
ls
find builds
