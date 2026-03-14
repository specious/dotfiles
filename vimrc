set backupdir=~/.vim/backups
set directory=~/.vim/swaps

" Unload any triggers previously set by this .vimrc
augroup vimrc | au! | augroup END

" Drop backwards compatibility
if &compatible
  set nocp
endif

let s:user_home = expand('~') " <- overridable, if needed
let s:dein_install = '.local/share/dein' " <- set this, if different
let s:dein_base = s:user_home.'/'.s:dein_install
let s:dein_src = s:dein_base.'/repos/github.com/Shougo/dein.vim'

" Auto-install dein
if !isdirectory(s:dein_src)
  call mkdir(s:dein_base, 'p')
  execute '!git clone --depth 1 https://github.com/Shougo/dein.vim' s:dein_src
endif

execute 'set rtp+='.s:dein_src

call dein#begin(s:dein_base)
call dein#add(s:dein_src)

if !has('nvim')
  call dein#add('roxma/nvim-yarp')
  call dein#add('roxma/vim-hug-neovim-rpc')
endif

call dein#add('lambdalisue/suda.vim')            " Save/load with root permission
call dein#add('preservim/nerdtree')              " File browser side panel
call dein#add('ctrlpvim/ctrlp.vim')              " Quick file/buffer finder
call dein#add('easymotion/vim-easymotion')       " Jump to content quickly
call dein#add('justinmk/vim-sneak')              " Jump around by searching two characters
call dein#add('tpope/vim-unimpaired')            " Lots of useful shortcuts
call dein#add('terryma/vim-expand-region')       " Quickly expand selected region
call dein#add('rstacruz/vim-xtract')             " Extract selection to new file
call dein#add('tpope/vim-repeat')                " Enhanced 'repeat last action'
call dein#add('sheerun/vim-polyglot')            " Programming language support
call dein#add('tpope/vim-commentary')            " Comment/uncomment code
call dein#add('suy/vim-context-commentstring')   " Detect correct language for comments
call dein#add('tpope/vim-endwise')               " Automatically close blocks
call dein#add('chaoren/vim-wordmotion')          " Better word motions
call dein#add('mg979/vim-visual-multi')          " Visual multi-select
call dein#add('wellle/targets.vim')              " Extended text objects for editing
call dein#add('AndrewRadev/dsf.vim')             " Make function calls a text object
call dein#add('tpope/vim-surround')              " Quickly change surrounding [] () {} ''
call dein#add('tpope/vim-speeddating')           " Quickly change dates
call dein#add('AndrewRadev/switch.vim')          " Quickly toggle booleans
call dein#add('AndrewRadev/deleft.vim')          " Delete surrounding code structures
call dein#add('AndrewRadev/sideways.vim')        " Shift items in a list
call dein#add('tomtom/tlib_vim')                 " ( Required by vim-snipmate )
call dein#add('marcweber/vim-addon-mw-utils')    " ( Required by vim-snipmate )
call dein#add('garbas/vim-snipmate')             " Expand snippets
call dein#add('honza/vim-snippets')              " Snippet collection
call dein#add('tpope/vim-fugitive')              " Git integration
call dein#add('tpope/vim-rhubarb')               " Github integration
call dein#add('jreybert/vimagit')                " Use git from vim
call dein#add('mileszs/ack.vim')                 " Search in files
call dein#add('vim-airline/vim-airline')         " Fancy status line
call dein#add('vim-airline/vim-airline-themes')
call dein#add('altercation/vim-colors-solarized')
call dein#add('tpope/vim-vividchalk')
call dein#add('xolox/vim-misc')
call dein#add('xolox/vim-colorscheme-switcher')
call dein#add('flazz/vim-colorschemes')          " Lots of color schemes
call dein#add('ryanoasis/vim-devicons')          " Fancy icons (must load last)

call dein#end()

" Install plugins on first run (non-interactive)
if dein#check_install()
  call dein#install()
  echom 'Plugins installed!'
endif

call dein#save_state()

" Enable loading of file type specific plugins and indent rules
filetype plugin indent on

" Set 'ag' as the search utility
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Configure CtrlP to scan hidden files
let g:ctrlp_show_hidden = 0

syntax on
set shortmess+=I                    " Disable vim intro message
set expandtab                       " Use spaces to indent
set tabstop=2                       " How many spaces a tab character equals
set shiftwidth=2                    " How many spaces to shift by when indenting
set list listchars=tab:>-,trail:∙   " Show tabs and trailing spaces
set backspace=indent,eol,start      " Conventional backspace behavior
set display=lastline                " Do not hide contents of long lines
set wildmenu                        " Enhanced command line completion
set wildmode=longest:full,full      " Command line completion behavior
set wildignore+=.git,.svn
set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.bmp
set wildignore+=.DS_Store
set wildignore+=node_modules,bower_components,elm-stuff
set wildcharm=<C-z>                 " Trigger tab completion via <C-z> inside a macro
set number                          " Show line numbers
set hlsearch                        " Highlight search matches
set incsearch                       " Highlight search matches as you type
set visualbell                      " Use visual bell instead of beeping
set helpheight=999                  " Expand help window to maximum height
set lazyredraw                      " Don't redraw screen while executing macros
set hidden                          " Allow buffers with unsaved changes to be hidden

let mapleader="\<Space>"
let maplocalleader=","

" User defined command to update plugins
:command! Modup :call dein#update()

" Quicker command line
map <leader>; :

" Reload configuration
map <leader>ss :source ~/.vimrc<cr>:noh<bar>echom "Reloaded config: ".expand('~/.vimrc')<cr>

" Toggle file tree panel
map <silent> <leader>m :NERDTreeToggle<CR>

" Quick save
map <leader>w :w<CR>

" Save a file as root
nnoremap <leader>W :SudaWrite<cr>

" Quit
map <leader>q :qa!<CR>

" Reload file
nnoremap <leader>e :e<cr>

" Display full path of current file
map <silent> <leader>g :echo expand("%:p")<CR>

" Clear undo history
fun! ClearUndo()
  let ul = &undolevels
  let was_modified = &modified
  setlocal undolevels=-1
  exe "normal! ax\<bs>\<esc>"
  let &undolevels = ul
  if !was_modified
    setlocal nomodified
  endif
  redraw
  echo "Undo history cleared"
endfun

nnoremap <space>u :call ClearUndo()<cr>

" Toggle whitespace visualization
nnoremap <space>tt :set list!<cr>

" Strip trailing whitespace (on every line)
noremap <leader>tr :%s/\s\+$//e<cr>

" Toggle word wrapping
map <F2> :set wrap!<CR>

" Toggle line numbers
map <F3> :set invnumber!<CR>

" Toggle relative line numbers
map <F4> :set invrelativenumber<CR>

" Split window and switch to the newly created one
map <leader>sp <C-w>s<C-w><C-w>

" Easy window switching (Ctrl-j, Ctrl-k, Ctrl-h, Ctrl-l)
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

" Check if window has another one above or below it
fun! WinHasVNeighbor()
  return winnr('j') != winnr() || winnr('k') != winnr()
endfun

" Check if window has another one to the left or right
fun! WinHasHNeighbor()
  return winnr('h') != winnr() || winnr('l') != winnr()
endfun

" Resize focused window (vertical)
noremap <expr> = WinHasVNeighbor() ? '<C-W>+' : ''
noremap <expr> - WinHasVNeighbor() ? '<C-W>-' : ''

" Resize focused window (horizontal)
noremap <expr> <leader>- WinHasHNeighbor() ? '<C-W><' : ''
noremap <expr> <leader>= WinHasHNeighbor() ? '<C-W>>' : ''

" Close current window
noremap <leader>c <C-w>c

" Leave only the current window (close all others)
noremap <leader>o :only<CR>

" Cycle buffers (in addition to [b and ]b)
nnoremap <tab>   :bnext<CR>
nnoremap <s-tab> :bprev<CR>

" Close current buffer
noremap <leader>bb :bw<CR>

" Is a buffer an unmodified empty buffer
fun! IsBufferEmptyAndUnmodified(which)
  return bufname(a:which) == '' && !getbufvar(a:which, "&modified")
endfun

" Close the other window if it's showing an untouched empty buffer while we're viewing help
fun! CloseEmptyBufferWindow(timer)
  if &filetype == "help" && getbufinfo('')[0].loaded && IsBufferEmptyAndUnmodified('#')
    " Close the last window that had focus
    +close
  endif
endfun

" Set trigger to hide unmodified empty buffer when opening help
augroup fixhelp
  au!
  au BufNew *.txt call timer_start(0, 'CloseEmptyBufferWindow')
augroup end

" Prevent cursor from jumping back one space when leaving insert mode
inoremap <silent> <Esc> <Esc>`^
inoremap <silent> <C-c> <Esc>`^

" Clear the line under the cursor
noremap <leader>ll 0D

" Join lines without moving the cursor
nnoremap J mjJ`j

" Tab that will advance to align with next word on the previous line
fun! SuperTab() abort
  "
  " TODO: Find last nonempty line
  "
  let spaces = matchstr(getline(line('.')-1)[col('.')-1:], '^\s*')

  return len(spaces) ? spaces : "\<tab>"
endfun

inoremap <expr> <C-t> SuperTab()

" Navigate to next/previous "blankish" line
nnoremap <leader>[ ?\v^\s*$<cr>:noh<cr>:echom "Line ".line('.')." (previous blank-ish)"<cr>
nnoremap <leader>] /\v^\s*$<cr>:noh<cr>:echom "Line ".line('.')." (next blank-ish)"<cr>

" Insert empty line before or after the current line (vim-unimpaired)
map <cr> [<space>
map <leader><cr> ]<space>

" Insert single character
nnoremap <leader>i i_<esc>r

" Shift current line left/right by one space
nnoremap <leader>, :s/^ //<cr>
nnoremap <leader>. :s/^/ /<cr>
vnoremap <leader>, :s/^ //<cr>gv
vnoremap <leader>. :s/^/ /<cr>gv

" Shift items in a list using sideways.vim
nnoremap <leader>sa :SidewaysLeft<cr>
nnoremap <leader>sd :SidewaysRight<cr>

" Make list items (arguments) a kind of text object
omap aa <Plug>SidewaysArgumentTextobjA
xmap aa <Plug>SidewaysArgumentTextobjA
omap ia <Plug>SidewaysArgumentTextobjI
xmap ia <Plug>SidewaysArgumentTextobjI

" Insert new list items
nmap <leader>li <Plug>SidewaysArgumentInsertBefore
nmap <leader>la <Plug>SidewaysArgumentAppendAfter
nmap <leader>lI <Plug>SidewaysArgumentInsertFirst
nmap <leader>lA <Plug>SidewaysArgumentAppendLast

" Copy selection to clipboard
vnoremap <leader>y "+y

" Copy current line to clipboard
nnoremap <leader>yy "+yy

" Copy entire buffer to clipboard
nnoremap <leader>yg :%y +<cr>

" Delete and copy selection to clipboard
vnoremap <leader>d "+d

" Delete current line and copy it to the clipboard
nnoremap <leader>dd "+dd

" Paste from clipboard
noremap <leader>p "+p

" Select most recently edited or pasted text
nnoremap gV `[v`]

" Jump to end of pasted text on paste
noremap <silent> p p`]

" Replace highlighted search results
map <leader>R :%s///g<left><left>

" Clear search highlighting
nnoremap <C-c> :noh<CR><C-c>

" Progressively expand or shrink selection (terryma/vim-expand-region)
vmap v <plug>(expand_region_expand)
vmap <c-v> <plug>(expand_region_shrink)

" Execute current file
map <silent> <leader>rr :!./%<CR>

" Open current file in Firefox
map <silent> <leader>ff :exec 'silent !firefox-developer-edition % &'<CR>

" Ensure C++ has // comments
au FileType cpp setlocal commentstring=//%s

" Protect default word motions by enabling enhanced motions under a special prefix
let g:wordmotion_prefix = '<Leader>2'

" Configure status line
let g:airline#extensions#tabline#enabled = 1
set laststatus=2 " show airline with only one screen
au vimrc VimEnter * AirlineTheme murmur

" Enable devicons in the UI
let g:webdevicons_enable_ctrlp = 1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1

" Switch color scheme (show name after switching)
map <leader><F2> :colorscheme <C-z>
map <leader><F3> :RandomColorScheme<CR>:colorscheme<CR>
map <F6> :PrevColorScheme<CR>:colorscheme<CR>
map <F7> :NextColorScheme<CR>:colorscheme<CR>

" Default color scheme
colorscheme maui

" Line number color
highlight LineNr ctermfg=green

" Different color line numbers in insert mode
au vimrc InsertEnter * hi LineNr ctermfg=darkgreen
au vimrc InsertLeave * hi LineNr ctermfg=green

" Disable automatic enforcement of formatting rules when editing git commit messages
au Filetype gitcommit setlocal formatoptions-=tl
