#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
cd "${REPO_ROOT}"
echo "${REPO_ROOT}"

# install code generate command
GO111MODULE=on go install k8s.io/code-generator/cmd/deepcopy-gen
GO111MODULE=on go install k8s.io/code-generator/cmd/defaulter-gen
GO111MODULE=on go install k8s.io/code-generator/cmd/register-gen

export GOPATH=$(go env GOPATH | awk -F ':' '{print $1}')
export PATH=$PATH:$GOPATH/bin

# register cleanup function
tmp_go_path="/tmp/_go"
cleanup() {
 sudo  rm -rf "${tmp_go_path}"
}
# trap "cleanup" EXIT SIGINT

# cleanup

# link current project to temp go path
source "${REPO_ROOT}"/hack/util.sh
util:create_gopath_tree "${REPO_ROOT}" "${tmp_go_path}"
export GOPATH="${tmp_go_path}"

echo "Generating with deepcopy-gen"
deepcopy-gen \
  --go-header-file hack/boilerplate.go.txt \
  --output-file=zz_generated.deepcopy.go \
  spark-operator/apis/pkg/apis/sparkoperator/v1beta2

#echo "Generating with register-gen"
#register-gen \
#  --go-header-file hack/boilerplate.go.txt \
#  --output-file=zz_generated.register.go \
#  spark-operator/apis/pkg/apis/sparkoperator/v1beta2

#echo "Generating with defaulter-gen"
#defaulter-gen \
#  --go-header-file hack/boilerplate.go.txt \
#  --output-file=default.go \
#  spark-operator/apis/pkg/apis/sparkoperator/v1beta2


