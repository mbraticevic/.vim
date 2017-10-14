#!/usr/bin/env python2

from __future__ import (absolute_import,
                        division,
                        print_function,
                        unicode_literals)

if __name__ == '__main__':
    import collections
    import os
    import sh

    PLUGINS = (
            # General
            'https://github.com/vim-scripts/bufexplorer.zip.git',
            'https://github.com/morhetz/gruvbox.git',
            'https://github.com/ervandew/supertab.git',
            'https://github.com/wellle/targets.vim.git',
            'https://github.com/junegunn/vim-easy-align.git',
            'https://github.com/tpope/vim-repeat.git',
            'https://github.com/tpope/vim-surround.git',
            # Markdown
            'https://github.com/plasticboy/vim-markdown.git',
            # Programming
            'https://github.com/scrooloose/syntastic.git',
            'https://github.com/majutsushi/tagbar.git',
            'https://github.com/tpope/vim-commentary.git',
            # TeX
            'https://github.com/lervag/vimtex.git',
            'https://github.com/xuhdev/vim-latex-live-preview.git',
    )

    HOME = os.path.expanduser('~')
    SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))


    def sh_curl(src, dst):
        print('Downloading \'{}\' (\'{}\').'.format(dst, src))
        sh.curl('--fail', '--location', '--create-dirs', '--output', dst, src)

    sh_curl('https://raw.githubusercontent.com/tpope/vim-pathogen/master/'
            'autoload/pathogen.vim',
            os.path.join(SCRIPT_DIR, 'autoload', 'pathogen.vim'))


    def sh_mkdir(dst):
        print('Creating \'{}\'.'.format(dst))
        sh.mkdir('-p', dst)

    def bundle_name(plugin):
        return plugin.rsplit('/')[-1].split('.git')[0]

    def bundle_dir(bundle, op):
        bundle_dir_ = os.path.join(SCRIPT_DIR, 'bundle', bundle)
        print('{} plugin \'{}\' (\'{}\').'.format(op, bundle, bundle_dir_))
        return bundle_dir_

    sh_mkdir(os.path.join(SCRIPT_DIR, 'bundle'))

    bundles_present = collections.OrderedDict(
            (bundle, None) for bundle in
            sorted(os.listdir(os.path.join(SCRIPT_DIR, 'bundle'))))
    bundles_needed = collections.OrderedDict(
            (bundle_name(plugin), plugin) for plugin in PLUGINS)

    bundles_to_update = collections.OrderedDict(
            (bundle, plugin) for (bundle, plugin) in bundles_needed.iteritems()
            if bundle in bundles_present)
    bundles_to_install = collections.OrderedDict(
            (bundle, plugin) for (bundle, plugin) in bundles_needed.iteritems()
            if bundle not in bundles_present)
    bundles_to_remove = collections.OrderedDict(
            (bundle, None) for bundle in bundles_present
            if bundle not in bundles_needed)

    for bundle, plugin in bundles_to_update.iteritems():
        bundle_dir_ = bundle_dir(bundle, 'Updating')
        sh.git('-C', bundle_dir_, 'pull', '--recurse-submodules')
        sh.git('-C', bundle_dir_,
               'submodule', 'update', '--init', '--remote', '--recursive')

    for bundle, plugin in bundles_to_install.iteritems():
        bundle_dir_ = bundle_dir(bundle, 'Installing')
        sh.git('clone', '--recursive', plugin, bundle_dir_)

    for bundle in bundles_to_remove:
        bundle_dir_ = bundle_dir(bundle, 'Removing')
        sh.rm('-r', '-f', bundle_dir_)

