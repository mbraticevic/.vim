Vim configuration
====

Does not support older versions of vim.
It is recommended to have the latest `Huge` version, and run it on a terminal supporting [true color](https://gist.github.com/XVilka/8346728).

1. Clone the repository
   ```shell
   % git clone --recursive https://github.com/traib/.vim.git ~/.vim
   ```

2. Use `setup.py` to update repo, install symlinks, and manage plugins
   ```shell
   % ~/.vim/setup.py
   ```

   Run it periodically, as well as when the plugins list is modified, to perform the mentioned maintenance tasks automatically. Please see the source for more details.
