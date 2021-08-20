set backupdir=~/.vim/backups
set directory=~/.vim/swaps
set undodir=~/.vim/undo

" Unload any triggers previously set by this .vimrc
augroup vimrc | au! | augroup END

set nocompatible
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'             " Plugin manager
Plugin 'lambdalisue/suda.vim'             " Save/load with root permission
Plugin 'scrooloose/nerdtree'              " File browser side panel
Plugin 'ctrlpvim/ctrlp.vim'               " Quick file/buffer finder
Plugin 'easymotion/vim-easymotion'        " Jump to content quickly
Plugin 'justinmk/vim-sneak'               " Jump around by searching two characters
Plugin 'tpope/vim-unimpaired'             " Lots of useful shortcuts
Plugin 'terryma/vim-expand-region'        " Quickly expand selected region
Plugin 'rstacruz/vim-xtract'              " Extract selection to new file
Plugin 'tpope/vim-repeat'                 " Enhanced 'repeat last action'
Plugin 'sheerun/vim-polyglot'             " Programming language support
Plugin 'tpope/vim-commentary'             " Comment/uncomment code
Plugin 'suy/vim-context-commentstring'    " Detect correct language for comments
Plugin 'tpope/vim-endwise'                " Automatically close blocks
Plugin 'tpope/vim-surround'               " Quickly change surrounding [] () {} ''
Plugin 'tpope/vim-speeddating'            " Quickly change dates
Plugin 'AndrewRadev/switch.vim'           " Quickly toggle booleans
Plugin 'AndrewRadev/sideways.vim'         " Shift items in a list
Plugin 'tomtom/tlib_vim'                  " ( Required by vim-snipmate )
Plugin 'marcweber/vim-addon-mw-utils'     " ( Required by vim-snipmate )
Plugin 'garbas/vim-snipmate'              " Expand snippets
Plugin 'honza/vim-snippets'               " Snippet collection
Plugin 'tpope/vim-fugitive'               " Use git from vim
Plugin 'jreybert/vimagit'                 " Use git from vim
Plugin 'ervandew/ag'                      " Search in files
Plugin 'vim-airline/vim-airline'          " Fancy status line
Plugin 'vim-airline/vim-airline-themes'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-vividchalk'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-colorscheme-switcher'
Plugin 'ryanoasis/vim-devicons'           " Fancy icons (must load last)
call vundle#end()

" Enable loading of file type specific plugins and indent rules
filetype plugin indent on

syntax on
set shortmess+=I                    " Disable vim intro message
set binary                          " Don't quietly change characters in a file
set expandtab                       " Use spaces to indent
set tabstop=2                       " How many spaces a tab character equals
set shiftwidth=2                    " How many spaces to shift by when indenting
set list listchars=tab:\ \ ,trail:∙ " Show trailing spaces (by default)
set listchars+=tab:>-               " Show tabs (until turned off)
set backspace=indent,eol,start      " Conventional backspace behavior
set display=lastline                " Do not hide contents of long lines
set undoreload=0                    " Clear undo history when reloading a file
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

" Quicker command line
map <leader>; :

" Toggle word wrapping
map <F2> :set wrap!<CR>

" Toggle relative line numbers
map <F3> :set invrelativenumber<CR>

" Toggle line numbers
map <F4> :set invnumber!<CR>

" Quick save
map <leader>w :w<CR>

" Save a file as root (doesn't work in neovim)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Quit
map <leader>q :qa!<CR>

" Reload file in current buffer, thereby resetting undo history
map <leader>e :e<CR>

" Display full path of current file
map <silent> <leader>g :echo expand("%:p")<CR>

" Show/hide tab characters
map <leader>tabon  :set listchars+=tab:>-<CR>
map <leader>taboff :set listchars-=tab:>-<CR>

" Split window and switch to the newly created one
map <leader>s <C-w>s<C-w><C-w>

" Easy window switching (Ctrl-j, Ctrl-k, Ctrl-h, Ctrl-l)
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

" Check if window has another one above or below it
fun! WinHasVNeighbor()
  return winnr('j') != winnr() || winnr('k') != winnr()
endfun

" Quick window resizing
noremap <expr> = WinHasVNeighbor() ? '<C-W>+' : ''
noremap <expr> - WinHasVNeighbor() ? '<C-W>-' : ''

" Close current window
noremap <leader>c <C-w>c

" Leave only the current window (close all others)
noremap <leader>o :only<CR>

" Cycle buffers
noremap <C-Left>  :bprev<CR>
noremap <C-Right> :bnext<CR>

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
  autocmd BufNew *.txt call timer_start(0, 'CloseEmptyBufferWindow')
augroup end

" Prevent cursor from jumping back one space when leaving insert mode
inoremap <silent> <Esc> <Esc>`^
inoremap <silent> <C-c> <Esc>`^

" Join lines without moving the cursor
nnoremap J mjJ`j

" Tab that will advance to align with next word on the previous line
fun! SuperTab() abort
  let spaces = matchstr(getline(line('.')-1)[col('.')-1:], '^\s*')

  return len(spaces) ? spaces : "\<tab>"
endfun

inoremap <expr> <C-t> SuperTab()

" New empty line before or after the current line (uses vim-unimpaired)
map <CR> [<space>
map <leader><CR> ]<space>

" Insert single character
nnoremap <leader>i i_<Esc>r

" Shift text left by one space
map <leader>, :s/^ //<CR>

" Shift items in a list using sideways.vim
nnoremap <leader>a :SidewaysLeft<cr>
nnoremap <leader>d :SidewaysRight<cr>

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

" Toggle paste mode
map <leader><Space>p :setlocal paste! paste?<CR>

" Copy to clipboard
vnoremap <leader>y  "+y
nnoremap <leader>yy "+yy

" Paste from clipboard
noremap <leader>p "+p

" Select text most recently edited or pasted
nnoremap gV `[v`]

" Jump to end of pasted text
noremap <silent> p p`]

" Replace highlighted search results
map <leader>R :%s///g<left><left>

" Clear search highlighting
nnoremap <C-c> :noh<CR><C-c>

" Expand regions (terryma/vim-expand-region)
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" Instrumental incantations
map <leader>bs :exec 'source ~/.vimrc'<CR>
map <silent> <leader>bi :PluginInstall<CR>
map <silent> <leader>m :NERDTreeToggle<CR>
map <silent> <leader>ff :exec 'silent !firefox-developer-edition % &'<CR>

" Execute current file
map <silent> <leader>rr :!./%<CR>

" Configure status line
let g:airline#extensions#tabline#enabled = 1
set laststatus=2 " show airline with only one screen
autocmd vimrc VimEnter * AirlineTheme murmur

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
colorscheme torte

" Line number color
highlight LineNr ctermfg=green

" Different color line numbers in insert mode
autocmd vimrc InsertEnter * hi LineNr ctermfg=darkgreen
autocmd vimrc InsertLeave * hi LineNr ctermfg=green
