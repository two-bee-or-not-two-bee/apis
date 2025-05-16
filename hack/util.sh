#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# This script holds common bash variables and utility functions.

GSCHEDULER_GO_PACKAGE="github.com/ayf/k8scontroller"


# This function installs a Go tools by 'go install' command.
# Parameters:
#  - $1: package name, such as "sigs.k8s.io/controller-tools/cmd/controller-gen"
#  - $2: package version, such as "v0.4.1"
function util::install_tools() {
	local package="$1"
	local version="$2"
	echo "go install ${package}@${version}"
	GO111MODULE=on go install "${package}"@"${version}"
	GOPATH=$(go env GOPATH | awk -F ':' '{print $1}')
	export PATH=$PATH:$GOPATH/bin
}

# util::create_gopath_tree create the GOPATH tree
# Parameters:
#  - $1: the root path of repo
#  - $2: go path
function util:create_gopath_tree() {
  local repo_root=$1
  local go_path=$2

  local target_pkg_dir="${go_path}/src/${GSCHEDULER_GO_PACKAGE}"
  local go_src_dir=$(dirname "${target_pkg_dir}")

  mkdir -p "${go_src_dir}"

  if [[ ! -e "${go_src_dir}" || "$(readlink "${target_pkg_dir}")" != "${repo_root}" ]]; then
    ln -snf "${repo_root}" "${target_pkg_dir}"
  fi
}


