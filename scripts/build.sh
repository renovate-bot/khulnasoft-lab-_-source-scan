#!/bin/bash
# shellcheck disable=SC2044
TAG=$1

if [ ${#TAG} -gt 0 ] ; then
  echo "Pruning Container: source-scan:${TAG}"  
  docker rmi -f source-scan:"${TAG}"
  echo "Building Container: source-scan:${TAG}"  
  docker image build --quiet --no-cache --file "Dockerfile-${TAG}" -t source-scan:"${TAG}" ./
else
  for FILENAME in $(find . -type f -name 'Dockerfile-*'); do
    TAG=${FILENAME#*-}
    # we can't assume that the testrepo is in every path, so we assume we set workdir in the image to the testrepo we want to use 
    # in a pipeline usually the container is mounted in the root of the repo, so this mimics that setup
    echo "Building Container: source-scan:${TAG}"
    docker image build --quiet --no-cache --file "${FILENAME}" -t source-scan:"${TAG}" ./
  done
fi
