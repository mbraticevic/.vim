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
if &termencoding == ""
  let &termencoding = &encoding
endif
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
set history=100         " history of ':' commands and previous search patterns
set viminfo=%,'100,r/tmp,s10

" Command-line completion
set wildmenu
set wildmode=list:longest,full
set wildignorecase

" Insert mode completion
" set complete=.,b,u,t
" set completeopt=longest,menu
" set pumheight=10

" Extra search features
set incsearch           " incremental searching
set ignorecase          " ignore case while searching
set smartcase           " override ignorecase if pattern has upper case
set nowrapscan          " don't wrap around the start/end of file
set gdefault            " substitute all matches in a line instead of one
set hlsearch            " highlight previous search pattern matches
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>

" Wrapping options
set wrap
set linebreak           " break lines at word boundaries
let &listchars = "tab:\u21e5 ,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"
set colorcolumn=80
set whichwrap=b,s,<,>,[,]

" No backup or swap files
set nobackup
set nowritebackup
set noswapfile

" Highlight current row
set cursorline
autocmd Vimrc WinLeave * setlocal nocursorline
autocmd Vimrc WinEnter * setlocal cursorline

" No beep or flash on errors
set noerrorbells
set visualbell
set t_vb=

" Show-off
set display=lastline    " display as much as possible of the last line
set number              " show line numbers
set ruler               " show the cursor position
set scrolloff=8         " min screen lines to keep above/below cursor
set showmode            " if in I, R or V, put a msg on the last line
set showcmd             " show (partial) command in status line

" Window Movement
nnoremap <C-Up>    <C-w>k<C-w>_
nnoremap <C-Down>  <C-w>j<C-w>_
nnoremap <C-Left>  <C-w>h
nnoremap <C-Right> <C-w>l
set winminheight=0

" Miscellaneous
set backspace=indent,eol,start  " backspace over everything
set confirm             " raise a dialog instead of failing
set hidden              " buffer becomes hidden when it is abandoned
set nojoinspaces        " never insert two spaces on a join command
set mouse=a             " enable mouse for all modes
set nrformats=hex       " nos. starting with 0x or 0X taken as hex (C-A, C-X)
set splitright          " put new window to the right of current one
set nostartofline       " keep cursor in same column if possible
set notimeout ttimeout ttimeoutlen=50
set ttyfast             " fast terminal connection
set virtualedit=block   " allow virtual editing in visual block mode

" Miscellaneous Mappings
cnoremap w!! w !sudo tee >/dev/null %
inoremap <C-u> <C-g>u<C-u>
nnoremap & :&&<CR>
xnoremap & :&&<CR>
nnoremap Y y$
nnoremap <silent> <leader>cd :cd %:p:h<CR>:pwd<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimrc - Smart Home
function! SmartHome()
  let l:lnum = line('.')
  let l:ccol = col('.')
  execute 'normal! ^'
  let l:fcol = col('.')
  execute 'normal! 0'
  let l:hcol = col('.')

  if l:ccol != l:fcol
    call cursor(l:lnum, l:fcol)
  else
    call cursor(l:lnum, l:hcol)
  endif
endfunction
nnoremap <silent> <Home> :call SmartHome()<CR>
inoremap <silent> <Home> <C-o>:call SmartHome()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimrc - Indentation - functions
"
" To indent purely with hard tabs, call '*Hard'.
" To use spaces for all indentation, call '*Soft'.
" Calling '*Mixed' will cause as many hard tabs as possible being used for
" indentation, and spaces being used to fill in the remains.
" The 'Setl*' variants will set the buffer-local options.
"
" All functions take an argument 'sw', which corresponds to the required
" 'shiftwidth'.
" The '*Mixed' functions take an additional optional argument to set the
" 'tabstop'; if it's unspecified, 'tabstop' is reset to its default value.

function! SeIndentHard(sw)
  set noexpandtab
  let &shiftwidth=a:sw
  set softtabstop&
  let &tabstop=a:sw
endfunction
function! SetlIndentHard(sw)
  setlocal noexpandtab
  let &l:shiftwidth=a:sw
  setlocal softtabstop&
  let &l:tabstop=a:sw
endfunction

function! SeIndentSoft(sw)
  set expandtab
  let &shiftwidth=a:sw
  let &softtabstop=a:sw
  set tabstop&
endfunction
function! SetlIndentSoft(sw)
  setlocal expandtab
  let &l:shiftwidth=a:sw
  let &l:softtabstop=a:sw
  setlocal tabstop&
endfunction

function! SeIndentMixed(sw, ...)
  set noexpandtab
  let &shiftwidth=a:sw
  let &softtabstop=a:sw
  if (a:0 > 0)
    let &tabstop=a:1
  else
    set tabstop&
  endif
endfunction
function! SetlIndentMixed(sw, ...)
  setlocal noexpandtab
  let &l:shiftwidth=a:sw
  let &l:softtabstop=a:sw
  if (a:0 > 0)
    let &l:tabstop=a:1
  else
    setlocal tabstop&
  endif
endfunction

" Indentation - settings
filetype plugin indent on
set autoindent          " copy indent from current line when starting a new one
set smarttab            " tab in front of a line inserts blanks acc. to 'shiftwidth'
set shiftround          " round indent to multiple of 'shiftwidth'
call SeIndentSoft(2)    " use 2 spaces per indentation level
augroup Vimrc_indent
  autocmd!
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimrc - Folding
set foldmethod=indent   " lines with equal indent form a fold
set foldlevelstart=99   " set foldlevel when starting to edit a buffer
set foldnestmax=2       " max nesting of folds for indent & syntax
set foldcolumn=1        " use these many columns to indicate folds
set foldopen+=jump      " also open folds if the cursor jumps inside
nnoremap <Space> za

function! FoldText()
  let fs = v:foldstart
  while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
  endwhile
  if fs > v:foldend
    let line = getline(v:foldstart)
  else
    let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
  endif

  let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
  let foldSize = 1 + v:foldend - v:foldstart
  let foldSizeStr = " " . foldSize . " lines "
  let foldLevelStr = repeat("<", v:foldlevel)
  let lineCount = line("$")
  let foldPercentage = printf("[%.1f", (foldSize*1.0)/lineCount*100) . "%] "
  let expansionString = repeat(" ", w - strwidth(foldSizeStr.line.foldLevelStr.foldPercentage))
  return line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
endfunction
set foldtext=FoldText()

let c_no_comment_fold=1
autocmd Vimrc FileType c setlocal foldmethod=syntax

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimrc - Statusline
set laststatus=2
set statusline=
set statusline+=[%n]
set statusline+=\ %1*[%.64t]%*%y
set statusline+=[%{&ff}→%{strlen(&fenc)?&fenc:'none'}%{&bomb?\"•\":\"\"}]
set statusline+=\ %2*%m%*
set statusline+=%=
set statusline+=L%l/%L:C%-3c\ %3p%%
set statusline+=\ %<

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" clang_complete
let g:clang_complete_auto = 0
let g:clang_auto_select = 0
let g:clang_close_preview=1
let g:clang_use_library=1
let g:clang_complete_macros=1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" jedi-vim
let g:jedi#show_call_signatures=0
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Jellybeans
syntax enable
let g:jellybeans_overrides = {
  \ 'Cursor': { 'guifg': '151515', 'guibg': 'b0d0f0' },
  \ }
colorscheme jellybeans
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Markdown Vim Mode
let g:vim_markdown_folding_disabled=1
autocmd Vimrc FileType mkd setlocal foldmethod=expr foldexpr=Foldexpr_markdown(v:lnum)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" neocomplete
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#disable_auto_complete = 1

inoremap <silent> <expr><CR> pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr><TAB> pumvisible() ?
    \ "\<Down>" : <SID>neo_check_back() ? "\<TAB>" : "\<C-n>\<Down>"
function! s:neo_check_back()
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
inoremap <expr><S-Tab> pumvisible() ? "\<Up>" : "\<C-p>\<Up>"
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplete#force_omni_input_patterns.objc = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#force_omni_input_patterns.objcpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Surround
if !exists("g:surround_no_mappings") || ! g:surround_no_mappings
  autocmd Vimrc BufEnter \[BufExplorer\] unmap ds
  autocmd Vimrc BufLeave \[BufExplorer\] nmap ds <Plug>Dsurround
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'

let g:syntastic_c_compiler='clang'
let g:syntastic_c_compiler_options=' -std=c99 -pedantic -Wall -Wextra'
let g:syntastic_c_config_file='.clang_complete'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tagbar
nnoremap <silent> <F10> :TagbarToggle<CR>
let g:tagbar_autofocus=1
let g:tagbar_compact=1
let g:tagbar_expand=1
let g:tagbar_foldlevel=0
let g:tagbar_iconchars=['▸', '▾']
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" undotree
nnoremap <silent> <F9> :UndotreeToggle<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-latex-live-preview
if (system('uname') =~ "darwin")
  let g:livepreview_previewer = 'open -a Preview'
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
