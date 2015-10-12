#!/bin/sh

set -e

CURDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ln -sfn $CURDIR/vimrc-insular ~/.vimrc

cd $CURDIR
mkdir -p bundle
mkdir -p autoload
ln -sfn ../bundle/vim-pathogen/autoload/pathogen.vim autoload/pathogen.vim

bundle_git() {
    local bdir=$( echo "$1" | sed 's/.*\/\(.*\)\.git/\1/' )
    echo "$bdir:"

    if test -d "bundle/$bdir"; then
        cd "bundle/$bdir"
        git pull && git submodule update --init --recursive
        cd - > /dev/null
    else
        cd bundle
        rm -rf "$bdir"
        git clone --recursive "$1"
        cd - > /dev/null
    fi

    echo
}

bundle_git "https://github.com/vim-scripts/bufexplorer.zip.git"
bundle_git "https://github.com/Rip-Rip/clang_complete.git"
bundle_git "https://github.com/morhetz/gruvbox.git"
bundle_git "https://github.com/davidhalter/jedi-vim.git"
bundle_git "https://github.com/LaTeX-Box-Team/LaTeX-Box.git"
bundle_git "https://github.com/ervandew/supertab.git"
bundle_git "https://github.com/scrooloose/syntastic.git"
bundle_git "https://github.com/godlygeek/tabular.git"
bundle_git "https://github.com/wellle/targets.vim.git"
bundle_git "https://github.com/majutsushi/tagbar.git"
bundle_git "https://github.com/tomtom/tcomment_vim.git"
bundle_git "https://github.com/mbbill/undotree.git"
bundle_git "https://github.com/fatih/vim-go.git"
bundle_git "https://github.com/pangloss/vim-javascript.git"
bundle_git "https://github.com/xuhdev/vim-latex-live-preview.git"
bundle_git "https://github.com/groenewege/vim-less.git"
bundle_git "https://github.com/plasticboy/vim-markdown.git"
bundle_git "https://github.com/tpope/vim-pathogen.git"
bundle_git "https://github.com/tpope/vim-repeat.git"
bundle_git "https://github.com/tpope/vim-surround.git"
