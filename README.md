<!--- They there! I am interested in buying your "traib" GitHub handle. Please get in touch with me at miljan@risesystems.io if you'd entertain selling it. --->

Vim configuration
====

Does not support older versions of vim.
It is recommended to have the latest `Huge` version, and run it on a terminal supporting [true color](https://gist.github.com/XVilka/8346728).

1. Clone the repo.
   ```shell
   % git clone https://github.com/traib/.vim.git ~/.vim
   ```

2. Use `setup.py` to update the repo and install the configuration.
   ```shell
   % ~/.vim/setup.py
   ```
   Run it periodically to perform these maintenance tasks automatically.

3. Use `vim-plug` commands (`:PlugInstall`, `:PlugUpdate`, `:PlugClean` etc.) to manage plugins.
   The list of plugins is in the `vimrc`.
