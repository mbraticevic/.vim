""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimrc
"
" Maintainer:   Tushar Raibhandare <traib@users.noreply.github.com>
"
" Personal vimrc that's tweaked and updated religiously.

" Basic
set nocompatible
execute pathogen#infect()
execute pathogen#helptags()
augroup Vimrc
  autocmd!
augroup END

" Disable modelines
set modelines=0
set nomodeline

" UTF FTW
set termencoding=utf-8
set encoding=utf-8
setglobal fileencoding=utf-8
set fileformats=unix,dos,mac

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd Vimrc BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" Things to remember
set history=1024         " amount of history to store for ':' and '/'
set viminfo=%,'256,<0,@0,h  " /,:,f1 are implicit, see :help 'viminfo'
set noundofile           " do not persist undo history

" Command-line completion
set wildmenu
set wildmode=list:longest,full
set wildignorecase

" Insert mode completion
set complete=.,b,u,t
set completeopt=longest,menuone

" Extra search features
set incsearch           " incremental searching
set ignorecase          " ignore case while searching
set smartcase           " override ignorecase if pattern has upper case
set nowrapscan          " don't wrap around the start/end of file
set hlsearch            " highlight previous search pattern matches
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>

" Wrapping options
set wrap
set linebreak           " break lines at word boundaries
let &listchars="tab:\u21e5 ,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"
set colorcolumn=80
set whichwrap=b,s,<,>,[,]

" No backup or swap files,
" but do make a backup before overwriting (deleted on success)
set nobackup
set noswapfile
set writebackup

" Highlight current row
set cursorline
autocmd Vimrc WinLeave * setlocal nocursorline
autocmd Vimrc WinEnter * setlocal cursorline

" No beep or flash on errors
set belloff=all
set noerrorbells
set visualbell
set t_vb=

" Show-off
set display=lastline    " display as much as possible of the last line
set number              " show line numbers
set relativenumber      " show relative line numbers
set ruler               " show the cursor position
set scrolloff=8         " min screen lines to keep above/below cursor
set showmode            " if in I, R or V, put a msg on the last line
set showcmd             " show (partial) command in status line

" Miscellaneous
set backspace=indent,eol,start  " backspace over everything
set confirm             " raise a dialog instead of failing
set nojoinspaces        " never insert two spaces on a join command
set mouse=a             " enable mouse for all modes
set nrformats=alpha,hex,bin  " C-A, C-X apply to alphabet, hexadecimal, binary
set splitright          " put new window to the right of current one
set notimeout ttimeout ttimeoutlen=100  " time out on key codes only
set ttyfast             " fast terminal connection
set virtualedit=block   " allow virtual editing in visual block mode
set lazyredraw          " do not redraw while executing macros, registers, etc.
set laststatus=2        " always show status line
set nolangremap         " langmap won't apply to chars resulting from a mapping

" Miscellaneous Mappings
let mapleader="\<space>"
cnoremap w!! w !sudo tee >/dev/null %
inoremap <C-u> <C-g>u<C-u>
nnoremap & :&&<CR>
xnoremap & :&&<CR>
nnoremap Y y$
nnoremap <silent> <leader>cd :cd %:p:h<CR>:pwd<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimrc - Indentation - functions
"
" To indent purely with hard tabs, call '*Hard'.
" To use spaces for all indentation, call '*Soft'.
" The 'Setlocal*' variants will set the buffer-local options.
"
" All functions take an argument 'sw', which corresponds to the required
" 'shiftwidth'.

function! SetIndentSoft(sw)
  set expandtab
  let &shiftwidth=a:sw
  let &softtabstop=a:sw
  set tabstop&
endfunction
function! SetlocalIndentSoft(sw)
  setlocal expandtab
  let &l:shiftwidth=a:sw
  let &l:softtabstop=a:sw
  setlocal tabstop&
endfunction

function! SetIndentHard(sw)
  set noexpandtab
  let &shiftwidth=a:sw
  set softtabstop&
  let &tabstop=a:sw
endfunction
function! SetlocalIndentHard(sw)
  setlocal noexpandtab
  let &l:shiftwidth=a:sw
  setlocal softtabstop&
  let &l:tabstop=a:sw
endfunction

" Indentation - settings
filetype plugin indent on
set autoindent          " copy indent from current line when starting a new one
set smarttab            " tab in front of a line inserts blanks acc. to 'shiftwidth'
set shiftround          " round indent to multiple of 'shiftwidth'
call SetIndentSoft(2)   " use 2 spaces per indentation level by default
augroup Vimrc_indent
  autocmd!
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gruvbox
let g:gruvbox_bold=0
let g:gruvbox_italic=0
let g:gruvbox_contrast_dark='hard'
set termguicolors
set background=dark
syntax enable
colorscheme gruvbox
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" jedi-vim
let g:jedi#show_call_signatures=0
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" supertab
let g:SuperTabNoCompleteAfter=['^', ',', '\s', ';', '=', '[', ']', '(', ')', '{', '}']
let g:SuperTabLongestEnhanced=1
let g:SuperTabLongestHighlight=1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tagbar
nnoremap <F8> :TagbarToggle<CR>
let g:tagbar_autofocus=1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" targets.vim
" Prefer multiline targets around cursor over distant targets within cursor line
let g:targets_seekRanges='cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB rr ll rb al rB Al bb aa bB Aa BB AA'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-airline
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_idx_mode=1
let g:airline#extensions#tabline#fnamemod=':t'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-latex-live-preview
if (system('uname') =~ 'darwin')
  let g:livepreview_previewer='open -a Preview'
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-surround
if !exists('g:surround_no_mappings') || ! g:surround_no_mappings
  autocmd Vimrc BufEnter \[BufExplorer\] unmap ds
  autocmd Vimrc BufLeave \[BufExplorer\] nmap ds <Plug>Dsurround
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
