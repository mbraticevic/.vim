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
        'https://github.com/junegunn/goyo.vim.git',
        'https://github.com/morhetz/gruvbox.git',
        'https://github.com/ervandew/supertab.git',
        'https://github.com/wellle/targets.vim.git',
        'https://github.com/vim-airline/vim-airline.git',
        'https://github.com/junegunn/vim-easy-align.git',
        'https://github.com/tommcdo/vim-exchange.git',
        'https://github.com/michaeljsmith/vim-indent-object.git',
        'https://github.com/tpope/vim-repeat.git',
        'https://github.com/kshenoy/vim-signature.git',
        'https://github.com/mhinz/vim-startify.git',
        'https://github.com/tpope/vim-surround.git',
        'https://github.com/tpope/vim-unimpaired.git',
        # Programming
        'https://github.com/w0rp/ale.git',  # see docs for language tools
        'https://github.com/Yggdroot/indentLine.git',
        'https://github.com/majutsushi/tagbar.git',
        'https://github.com/Chiel92/vim-autoformat.git',  # yapf, rustfmt
        'https://github.com/tpope/vim-commentary.git',
        # Python
        'https://github.com/davidhalter/jedi-vim.git',  # jedi
        'https://github.com/fisadev/vim-isort.git',  # isort
        'https://github.com/Vimjas/vim-python-pep8-indent.git',
        'https://github.com/jmcantrell/vim-virtualenv.git',
        # Rust
        'https://github.com/rust-lang/rust.vim.git',
        'https://github.com/racer-rust/vim-racer.git',  # racer
        'https://github.com/cespare/vim-toml.git',
        # TeX
        'https://github.com/lervag/vimtex.git',
        'https://github.com/xuhdev/vim-latex-live-preview.git',
        # Version Control
        'https://github.com/tpope/vim-fugitive.git',
        'https://github.com/mhinz/vim-signify.git',
    )

    HOME = os.path.expanduser('~')
    SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))

    def sh_gitpull(dst):
        sh.git('-C', dst, 'pull', '--recurse-submodules')
        sh.git('-C', dst, 'submodule', 'update',
               '--init', '--remote', '--recursive')

    def sh_curl(src, dst):
        print('DLoading \'{}\' (\'{}\').'.format(src, dst))
        sh.curl('--fail', '--location', '--create-dirs', '--output', dst, src)

    def sh_mkdir(dst):
        print('Creating \'{}\'.'.format(dst))
        sh.mkdir('-p', dst)

    def bundle_name(plugin):
        return plugin.rsplit('/')[-1].split('.git')[0]

    def bundle_dir(bundle, op):
        bundle_dir_ = os.path.join(SCRIPT_DIR, 'bundle', bundle)
        print('{} plugin \'{}\' (\'{}\').'.format(op, bundle, bundle_dir_))
        return bundle_dir_

    def sh_ln(src, dst):
        print('SLinking \'{}\' (\'{}\').'.format(src, dst))
        sh.ln('-s', '-f', '-n', dst, src)

    print('Updating repository \'{}\'.'.format(SCRIPT_DIR))
    sh_gitpull(SCRIPT_DIR)

    sh_curl('https://raw.githubusercontent.com/tpope/vim-pathogen/master/'
            'autoload/pathogen.vim',
            os.path.join(SCRIPT_DIR, 'autoload', 'pathogen.vim'))

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
        sh_gitpull(bundle_dir_)

    for bundle, plugin in bundles_to_install.iteritems():
        bundle_dir_ = bundle_dir(bundle, 'Instling')
        sh.git('clone', '--recursive', plugin, bundle_dir_)

    for bundle in bundles_to_remove:
        bundle_dir_ = bundle_dir(bundle, 'Removing')
        sh.rm('-r', '-f', bundle_dir_)

    sh_ln(os.path.join(HOME, '.vimrc'),
          os.path.join(SCRIPT_DIR, 'vimrc-bootstrap'))
