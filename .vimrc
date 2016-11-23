set backupdir=~/.vim/backups
set directory=~/.vim/swaps
set undodir=~/.vim/undo

set nocompatible
set rtp+=~/.vim/bundle/vundle/
call vundle#begin()
Plugin 'gmarik/vundle'
Plugin 'scrooloose/nerdtree'
Plugin 'digitaltoad/vim-pug'
Plugin 'wavded/vim-stylus'
Plugin 'elmcast/elm-vim'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-surround'
Plugin 'kovisoft/slimv'
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
set backspace=start
set display=lastline " Do not hide contents of long lines
set undoreload=0
set wildmenu
set wildmode=longest:full,full
set wildignore+=.git,.svn
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
set wildignore+=*.sw?
set wildignore+=.DS_Store
set wildignore+=node_modules,bower_components,elm-stuff
set nu
set hls
set incsearch
set visualbell

" Toggle line numbers
nmap <F4> :set invnumber<CR>

" Show trailing spaces
set listchars=trail:∙

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

" Join lines without creating whitespace between them
:nnoremap J gJ

" Insert empty line
nmap <CR> O<Esc>

" Jump to end of pasted text
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" Clear search highlighting
nnoremap <C-c> :noh<CR><C-c>

" Commenting blocks of code
autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
autocmd FileType sh,ruby,python   let b:comment_leader = '# '
autocmd FileType conf,fstab       let b:comment_leader = '# '
autocmd FileType clojure          let b:comment_leader = '; '
autocmd FileType tex              let b:comment_leader = '% '
autocmd FileType mail             let b:comment_leader = '> '
autocmd FileType vim              let b:comment_leader = '" '
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

" Toggle paste mode
nmap <leader>pp :setlocal paste! paste?<CR>

" Quicker command line
nnoremap ; :

let mapleader="\<Space>"
nmap <silent> <leader>ss :exec 'source ~/.vimrc'<CR>
nmap <silent> <leader>bi :PluginInstall<CR>
nmap <silent> <leader>m :NERDTreeToggle<CR>
nmap <silent> <leader>chrome :exec 'silent !open -a "Google Chrome Dev" % &'<CR>
nmap <silent> <leader>canary :exec 'silent !open -a "Google Chrome Canary" % &'<CR>

" Configure status line (vim-airline/vim-airline)
let g:airline#extensions#tabline#enabled = 1
set laststatus=2 " show airline with only one screen
let g:airline_left_sep = '»'

" Color scheme
colorscheme delek
nmap <F3> :colorscheme torte<CR>

" Expand regions (terryma/vim-expand-region)
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" Save a file as root
noremap <leader>W :w !sudo tee % > /dev/null<CR>

highlight LineNr ctermfg=green