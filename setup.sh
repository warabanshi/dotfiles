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

    curl https://pyenv.run | bash
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
    sudo apt install liblzma-dev tk-dev libncurses5-dev libreadline-dev sqlite3 libsqlite3-dev libbz2-dev libffi-dev
    sudo apt install fd-find ripgrep fzf neovim
    pip install ast-grep-cli

    # install lazygit
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/
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
