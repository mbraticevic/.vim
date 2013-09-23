#!/bin/sh

set -e

mkdir -p bundle
mkdir -p autoload
ln -t autoload -sf ../bundle/vim-pathogen/autoload/pathogen.vim

bdirlist="bundle/.bdirs"
rm -rf "$bdirlist"

bundle_git() {
    local bdir=$( echo "$1" | sed 's/.*\/\(.*\)\.git/\1/' | tee -a "$bdirlist" )
    echo "$bdir:"

    if test -d "bundle/$bdir"; then
        pushd "bundle/$bdir" > /dev/null
        git pull && git submodule update --init --recursive
        popd > /dev/null
    else
        pushd bundle > /dev/null
        rm -rf "$bdir"
        git clone --recursive "$1"
        popd > /dev/null
    fi

    echo
}

bundle_manual() {
    echo "$1" >> "$bdirlist"
}

bundle_git "https://github.com/mileszs/ack.vim.git"
bundle_git "https://github.com/vim-scripts/bufexplorer.zip.git"
bundle_git "https://github.com/Rip-Rip/clang_complete.git"
bundle_git "https://github.com/nanotech/jellybeans.vim.git"
bundle_git "https://github.com/scrooloose/nerdtree.git"
bundle_git "https://github.com/ervandew/supertab.git"
bundle_git "https://github.com/scrooloose/syntastic.git"
bundle_git "https://github.com/godlygeek/tabular.git"
bundle_git "https://github.com/majutsushi/tagbar.git"
bundle_git "https://github.com/tomtom/tcomment_vim.git"
bundle_git "https://github.com/SirVer/ultisnips.git"
bundle_git "https://github.com/mbbill/undotree.git"
bundle_git "https://github.com/Lokaltog/vim-easymotion.git"
bundle_git "https://github.com/tpope/vim-fugitive.git"
bundle_git "https://github.com/plasticboy/vim-markdown.git"
bundle_git "https://github.com/jistr/vim-nerdtree-tabs.git"
bundle_git "https://github.com/tpope/vim-pathogen.git"
bundle_git "https://github.com/tpope/vim-repeat.git"
bundle_git "https://github.com/tpope/vim-surround.git"

bundle_manual "eclim"   # https://github.com/ervandew/eclim.git

for unused in $( find "bundle" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | sort "$bdirlist" - | uniq -u ); do
    if test ! -d "bundle/$unused"; then
        continue
    fi
    read -p "Delete unused directory ‘bundle/$unused’? [y/N] " ans
    case $ans in
        [Yy] ) rm -rf "bundle/$unused"; echo "Deleted.";;
        [Nn] ) ;;
        ""   ) ;;
        *    ) echo "Skipped.";;
    esac
    echo
done

rm -rf "$bdirlist"
