#!/usr/bin/env python3

if __name__ == '__main__':
    import os
    import subprocess

    HOME = os.path.expanduser('~')
    SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))

    # Sync git repo with origin.
    subprocess.run(['git', '-C', SCRIPT_DIR, 'pull', '--quiet'], check=True)

    # Set up vim-plug.
    subprocess.run(
        [
            'curl', '--silent', '--fail', '--create-dirs',
            'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim',
            '--output',
            os.path.join(SCRIPT_DIR, 'autoload', 'plug.vim')
        ],
        check=True)

    # Install vimrc (symlink).
    subprocess.run(
        [
            'ln', '-s', '-f', '-n',
            os.path.join(SCRIPT_DIR, 'vimrc-bootstrap'),
            os.path.join(HOME, '.vimrc')
        ],
        check=True)
