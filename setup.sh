#!/usr/bin/env bash

set -ue -o pipefail

BASE_DIR=`pwd`

init() {
    trap 'rm -rf ${BASE_DIR}/dotfiles' EXIT
    git clone https://github.com/warabanshi/dotfiles.git
}

common() {
    cd dotfiles
    mkdir ~/tmp-dotfiles
    cp -r files/* ~/tmp-dotfiles

    cd $OLDPWD
}

debian() {
    common
}

opensuse() {
    common
}


init

if [ -f /etc/SUSE-brand ]; then
    opensuse
elif [ -f /etc/os-release ]; then
    debian
fi
