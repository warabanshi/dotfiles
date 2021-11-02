#!/usr/bin/env bash

set -ue -o pipefail

BASE_DIR=`pwd`
DEST_DIR=~/

cleanup() {
    rm -rf ${BASE_DIR}/dotfiles
}

init() {
    trap cleanup EXIT
    git clone https://github.com/warabanshi/dotfiles.git
}

common() {
    cd dotfiles
    mkdir ~/tmp-dotfiles
    find ./files -maxdepth 1 -type f -exec cp {} ${DEST_DIR} \;
    cp -r ./files/.vim ${DEST_DIR}

    cd $OLDPWD

    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
}

debian() {
    common

    # setup pyenv
    sed -Ei -e '/^([^#]|$)/ {a \
    export PYENV_ROOT="$HOME/.pyenv"
    a \
    export PATH="$PYENV_ROOT/bin:$PATH"
    a \
    ' -e ':a' -e '$!{n;ba};}' ~/.profile
    echo 'eval "$(pyenv init --path)"' >>~/.profile

    echo 'eval "$(pyenv init -)"' >> ~/.bashrc
}

opensuse() {
    common

    # setup pyenv
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
    echo 'eval "$(pyenv init --path)"' >> ~/.profile

    echo 'if command -v pyenv >/dev/null; then eval "$(pyenv init -)"; fi' >> ~/.bashrc
}


init

if [ -f /etc/SUSE-brand ]; then
    opensuse
elif [ -f /etc/os-release ]; then
    debian
fi
