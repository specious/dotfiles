set backupdir=~/.vim/backups
set directory=~/.vim/swaps
set undodir=~/.vim/undo

set nocompatible
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()
Plugin 'gmarik/vundle'
Plugin 'scrooloose/nerdtree'
Plugin 'digitaltoad/vim-pug'
Plugin 'wavded/vim-stylus'
Plugin 'elmcast/elm-vim'
Plugin 'guns/vim-sexp'
Plugin 'tpope/vim-sexp-mappings-for-regular-people'
Plugin 'kovisoft/paredit'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-surround'
Plugin 'eapache/rainbow_parentheses.vim'
Plugin 'tpope/vim-fireplace'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'ervandew/ag'
Plugin 'terryma/vim-expand-region'
Plugin 'marcweber/vim-addon-mw-utils' " Required by garbas/vim-snipmate
Plugin 'tomtom/tlib_vim'              " Required by garbas/vim-snipmate
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-fugitive'
Plugin 'jreybert/vimagit'
Plugin 'AndrewRadev/switch.vim'
Plugin 'tpope/vim-speeddating'
Plugin 'tpope/vim-unimpaired'
Plugin 'rstacruz/vim-xtract'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-vividchalk'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-colorscheme-switcher'
call vundle#end()
filetype plugin indent on " see: http://vimdoc.sourceforge.net/htmldoc/filetype.html

syntax on
set binary
set noeol
set expandtab
set tabstop=2
set shiftwidth=2
set backspace=indent,eol,start " Conventional backspace behavior
set display=lastline           " Do not hide contents of long lines
set undoreload=0
set wildmenu
set wildmode=longest:full,full
set wildignore+=.git,.svn
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
set wildignore+=*.sw?
set wildignore+=.DS_Store
set wildignore+=node_modules,bower_components,elm-stuff
set wildcharm=<C-z>            " Trigger tab completion via <C-z>
set nu                         " Display line numbers
set hls                        " Highlight search matches
set noincsearch                " Turn off incremental search
set visualbell

let mapleader="\<Space>"
let maplocalleader=","

" Quicker command line
nnoremap ; :
vnoremap ; :

" Toggle word wrapping
map <F2> :set wrap!<CR>

" Toggle relative line numbers
map <F3> :set invrelativenumber<CR>

" Toggle line numbers
map <F4> :set invnumber!<CR>

" Toggle rainbow parentheses
map <F5> :RainbowParenthesesToggleAll<CR>

" Quick save
map <leader>w :w<CR>

" Quit
map <silent> <leader>q :qa!<CR>

" Reload file in current buffer, thereby resetting undo history
map <silent> <leader>e :e<CR>

" Display full path of current file
map <silent> <leader>g :echo expand("%:p")<CR>

" Copy to clipboard
vnoremap <leader>y  "+y
nnoremap <leader>yy "+yy

" Paste from clipboard
nnoremap <leader>p "+p
vnoremap <leader>p "+p

" Show trailing spaces
set list listchars=tab:\ \ ,trail:∙

" Show/hide tabs
map <silent> <leader>tt :set listchars+=tab:>-<CR>
map <silent> <leader>TT :set listchars-=tab:>-<CR>

" Easy window switching (Ctrl-j, Ctrl-k, Ctrl-h, Ctrl-l)
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

" Easy window resizing (+,-)
if bufwinnr(1)
  map = <C-W>+
  map - <C-W>-
endif

" Join lines and restore cursor location (J)
nnoremap J mjJ`j

" Like gJ, but always remove spaces ( http://vi.stackexchange.com/a/440 )
fun! JoinSpaceless()
  execute 'normal gJ'

  " Character under cursor is whitespace?
  if matchstr(getline('.'), '\%' . col('.') . 'c.') =~ '\s'
    " When remove it!
    execute 'normal dw'
  endif
endfun

nnoremap <leader>j :call JoinSpaceless()<CR>

" Insert empty line
map <CR> O<Esc>

" Insert empty line without leaving normal mode
map <leader>o o<ESC>k
map <leader>O O<ESC>j

" Insert single character
:nnoremap <leader>i i_<Esc>r

" Jump to end of pasted text
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" Clear search highlighting
nnoremap <C-c> :noh<CR><C-c>

" Select text most recently edited or pasted
nnoremap gV `[v`]

" Expand regions (terryma/vim-expand-region)
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" Comment blocks of code
autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
autocmd FileType sh,ruby,python   let b:comment_leader = '# '
autocmd FileType conf,fstab       let b:comment_leader = '# '
autocmd FileType clojure          let b:comment_leader = '; '
autocmd FileType tex              let b:comment_leader = '% '
autocmd FileType mail             let b:comment_leader = '> '
autocmd FileType vim              let b:comment_leader = '" '
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

" Shift text left by one space
map <leader>, :s/^ //<CR>

" Hot-reload code in connected Clojure REPL
au Filetype clojure nmap <C-c><C-k> :Require<CR>

" Set filetype for uncommon extensions
au BufRead,BufNewFile *.boot set filetype=clojure

" Toggle paste mode
map <leader>pp :setlocal paste! paste?<CR>

" Instrumental incantations
map <silent> <leader>ss :exec 'source ~/.vimrc'<CR>
map <silent> <leader>bi :PluginInstall<CR>
map <silent> <leader>m :NERDTreeToggle<CR>
map <silent> <leader>chrome :exec 'silent !open -a "Google Chrome Dev" % &'<CR>
map <silent> <leader>canary :exec 'silent !open -a "Google Chrome Canary" % &'<CR>

" Execute current file
map <silent> <leader>rr :!./%<CR>

" Configure status line (vim-airline/vim-airline)
let g:airline#extensions#tabline#enabled = 1
set laststatus=2 " show airline with only one screen
let g:airline_left_sep = '»'
au VimEnter * AirlineTheme lucius

" Default color scheme
colorscheme solarized

" Switch color scheme
map <leader><F2> :colorscheme <C-z>
map <leader><F3> :RandomColorScheme<CR>
map <F6> :PrevColorScheme<CR>
map <F7> :NextColorScheme<CR>

" Save a file as root
noremap <leader>W :w !sudo tee % > /dev/null<CR>

highlight LineNr ctermfg=green