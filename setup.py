#!/usr/bin/env python2

from __future__ import (absolute_import,
                        division,
                        print_function,
                        unicode_literals)

if __name__ == '__main__':
    import collections
    import itertools
    import os
    import sh

    PLUGINS_COMPULSORY = (
            'https://github.com/tpope/vim-pathogen.git',
    )
    PLUGINS = (
            'https://github.com/vim-scripts/bufexplorer.zip.git',
            'https://github.com/Rip-Rip/clang_complete.git',
            'https://github.com/morhetz/gruvbox.git',
            'https://github.com/davidhalter/jedi-vim.git',
            'https://github.com/LaTeX-Box-Team/LaTeX-Box.git',
            'https://github.com/ervandew/supertab.git',
            'https://github.com/scrooloose/syntastic.git',
            'https://github.com/godlygeek/tabular.git',
            'https://github.com/wellle/targets.vim.git',
            'https://github.com/majutsushi/tagbar.git',
            'https://github.com/tomtom/tcomment_vim.git',
            'https://github.com/mbbill/undotree.git',
            'https://github.com/easymotion/vim-easymotion.git',
            'https://github.com/fatih/vim-go.git',
            'https://github.com/pangloss/vim-javascript.git',
            'https://github.com/xuhdev/vim-latex-live-preview.git',
            'https://github.com/groenewege/vim-less.git',
            'https://github.com/plasticboy/vim-markdown.git',
            'https://github.com/tpope/vim-repeat.git',
            'https://github.com/tpope/vim-surround.git',
    )

    HOME = os.path.expanduser('~')
    SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))

    def sh_ln(src, dst):
        print('Symlinking \'{}\' -> \'{}\'.'.format(src, dst))
        sh.ln('-s', '-f', '-n', dst, src)

    def sh_mkdir(dst):
        print('Creating \'{}\'.'.format(dst))
        sh.mkdir('-p', dst)

    def bundle_name(plugin):
        return plugin.rsplit('/')[-1].split('.git')[0]


    sh_ln(os.path.join(HOME, '.vimrc'),
          os.path.join(SCRIPT_DIR, 'vimrc-insular'))

    sh_mkdir(os.path.join(SCRIPT_DIR, 'autoload'))
    sh_ln(os.path.join(SCRIPT_DIR, 'autoload', 'pathogen.vim'),
          os.path.join(SCRIPT_DIR, 'bundle', 'vim-pathogen',
                                   'autoload', 'pathogen.vim'))

    sh_mkdir(os.path.join(SCRIPT_DIR, 'bundle'))


    bundles_present = collections.OrderedDict(
            (bundle, None) for bundle in
            sorted(os.listdir(os.path.join(SCRIPT_DIR, 'bundle'))))
    bundles_needed = collections.OrderedDict(
            (bundle_name(plugin), plugin) for plugin in
            itertools.chain(PLUGINS_COMPULSORY, PLUGINS))

    bundles_to_update = collections.OrderedDict(
            (bundle, plugin) for (bundle, plugin) in bundles_needed.iteritems()
            if bundle in bundles_present)
    bundles_to_install = collections.OrderedDict(
            (bundle, plugin) for (bundle, plugin) in bundles_needed.iteritems()
            if bundle not in bundles_present)
    bundles_to_remove = collections.OrderedDict(
            (bundle, None) for bundle in bundles_present
            if bundle not in bundles_needed)

    for bundle, plugin in bundles_to_install.iteritems():
        bundle_dir = os.path.join(SCRIPT_DIR, 'bundle', bundle)
        print('Installing plugin \'{}\' (\'{}\').'.format(bundle, bundle_dir))
        sh.git('clone', '--recursive', plugin, bundle_dir)

    for bundle, plugin in bundles_to_update.iteritems():
        bundle_dir = os.path.join(SCRIPT_DIR, 'bundle', bundle)
        print('Updating plugin \'{}\' (\'{}\').'.format(bundle, bundle_dir))
        sh.git('-C', bundle_dir, 'pull', '--recurse-submodules')
        sh.git('-C', bundle_dir,
               'submodule', 'update', '--init', '--remote', '--recursive')

    for bundle in bundles_to_remove:
        bundle_dir = os.path.join(SCRIPT_DIR, 'bundle', bundle)
        print('Removing plugin \'{}\' (\'{}\').'.format(bundle, bundle_dir))
        sh.rm('-r', '-f', bundle_dir)

