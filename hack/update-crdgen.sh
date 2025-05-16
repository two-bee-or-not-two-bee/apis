#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

CONTROLLER_GEN_PKG="sigs.k8s.io/controller-tools/cmd/controller-gen"
CONTROLLER_GEN_VER="v0.16.5"

#GO111MODULE=on go install ${CONTROLLER_GEN_PKG}@${CONTROLLER_GEN_VER}
pwd
# REPO_ROOT=$(git rev-parse --show-toplevel)
# cd "${REPO_ROOT}"
# echo "${REPO_ROOT}"

source hack/util.sh

echo "Generating with controller-gen"
# util::install_tools ${CONTROLLER_GEN_PKG} ${CONTROLLER_GEN_VER} >/dev/null 2>&1
util::install_tools ${CONTROLLER_GEN_PKG} ${CONTROLLER_GEN_VER}

# Unify the crds used by helm chart and the installation scripts
controller-gen crd paths=./pkg/apis/sparkoperator/... output:crd:dir=./crds
