#!/bin/bash

set -e -v

# TODO template q2d2 credentials
git config --global user.name q2d2
git config --global user.email "q2d2.noreply@gmail.com"

RELPATH="$RELEASE/$BUILD_TYPE/"

git clone ./environment-files ./updated-environment-files
cd ./updated-environment-files

mkdir -p $RELPATH
cp ../linux-environment-files/* $RELPATH
cp ../darwin-environment-files/* $RELPATH

if [ "$BUILD_TYPE" == "test" ]
then
  # Latest Test
  mkdir -p latest/test
  cp ../linux-environment-files/qiime2-$RELEASE-py38-linux-conda.yml latest/test/qiime2-latest-py38-linux-conda.yml
  cp ../darwin-environment-files/qiime2-$RELEASE-py38-osx-conda.yml latest/test/qiime2-latest-py38-osx-conda.yml
  git add latest/test
fi

if [ "$BUILD_TYPE" == "staging" ]
then
  # Latest Staging
  mkdir -p latest/staging
  cp ../linux-environment-files/qiime2-$RELEASE-py38-linux-conda.yml latest/staging/qiime2-latest-py38-linux-conda.yml
  cp ../darwin-environment-files/qiime2-$RELEASE-py38-osx-conda.yml latest/staging/qiime2-latest-py38-osx-conda.yml
  git add latest/staging
fi

git add $RELPATH
git diff-index --quiet HEAD || git commit -m "Updated $RELEASE $BUILD_TYPE environment file."
