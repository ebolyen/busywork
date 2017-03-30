#!/bin/bash

set -e -x

conda update -y conda
conda create -y -p ./test-env
source activate ./test-env

CHANNELS=$(ls -1 -d $(pwd)/* | grep '^.\+-channel$' | sed "s/^/ -c /" | xargs)
conda install -y $CHANNELS \
  -c https://conda.anaconda.org/qiime2 \
  -c https://conda.anaconda.org/biocore \
  -c defaults \
  -c https://conda.anaconda.org/conda-forge \
  -c https://conda.anaconda.org/bioconda \
  --override-channels \
  qiime2 q2cli q2templates q2-types q2-feature-table q2-alignment q2-composition $(: q2-deblur) q2-demux q2-diversity q2-emperor q2-feature-classifier q2-phylogeny q2-quality-filter q2-taxa

echo "backend: Agg" > matplotlibrc

conda list
