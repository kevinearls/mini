set -x
set -e

export BUILD_IMAGE=kevinearls/simplehttp:${GITHUB_SHA}
make docker-build
docker images
