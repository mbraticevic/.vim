#!/usr/bin/env python2

from __future__ import (absolute_import,
                        division,
                        print_function,
                        unicode_literals)

if __name__ == '__main__':
    import collections
    import os

    import sh

    # Split into sections. Additional requirements are listed in comments,
    # and should be installed separately for enabling relevant functionality.
    PLUGINS = (
        # General
        'https://github.com/vim-scripts/bufexplorer.zip.git',
        'https://github.com/morhetz/gruvbox.git',
        'https://github.com/ervandew/supertab.git',
        'https://github.com/wellle/targets.vim.git',
        'https://github.com/vim-airline/vim-airline.git',
        'https://github.com/junegunn/vim-easy-align.git',
        'https://github.com/easymotion/vim-easymotion.git',
        'https://github.com/tommcdo/vim-exchange.git',
        'https://github.com/michaeljsmith/vim-indent-object.git',
        'https://github.com/tpope/vim-repeat.git',
        'https://github.com/tpope/vim-surround.git',
        # Markdown
        'https://github.com/plasticboy/vim-markdown.git',
        # Programming
        'https://github.com/w0rp/ale.git',  # see docs for language tools
        'https://github.com/Yggdroot/indentLine.git',
        'https://github.com/majutsushi/tagbar.git',
        'https://github.com/Chiel92/vim-autoformat.git',  # yapf
        'https://github.com/tpope/vim-commentary.git',
        # Python
        'https://github.com/davidhalter/jedi-vim.git',  # jedi
        'https://github.com/fisadev/vim-isort.git',  # isort
        'https://github.com/Vimjas/vim-python-pep8-indent.git',
        'https://github.com/jmcantrell/vim-virtualenv.git',
        # TeX
        'https://github.com/lervag/vimtex.git',
        'https://github.com/xuhdev/vim-latex-live-preview.git',
        # Version Control
        'https://github.com/mhinz/vim-signify.git',
    )

    HOME = os.path.expanduser('~')
    SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))

    def sh_ln(src, dst):
        print('Symlinking \'{}\' (\'{}\').'.format(src, dst))
        sh.ln('-s', '-f', '-n', dst, src)

    def sh_curl(src, dst):
        print('Downloading \'{}\' (\'{}\').'.format(src, dst))
        sh.curl('--fail', '--location', '--create-dirs', '--output', dst, src)

    sh_ln(os.path.join(HOME, '.vimrc'),
          os.path.join(SCRIPT_DIR, 'vimrc-bootstrap'))

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
