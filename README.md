Vim configuration
====

Does not support older versions of vim.
It is recommended to have the latest `Huge` version, and run it on a terminal supporting [true color](https://gist.github.com/XVilka/8346728).

1. Clone the repository
   ```shell
   % git clone --recursive https://github.com/traib/.vim.git ~/.vim
   ```

2. Use `setup.py` to install symlinks and manage plugins
   ```shell
   % ~/.vim/setup.py
   ```
   Additional plugins can be listed in the same file, please see the source for more info.

3. Use `git` to keep the configuration in the repo updated
   ```shell
   % git -C ~/.vim pull --recurse-submodules && \
     git -C ~/.vim submodule update --init --remote --recursive
   ```
   In addition, run `setup.py` periodically, as well as when the plugins list is modified - to update, install and remove plugins.
