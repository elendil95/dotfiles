set number
set tabstop=4
set shiftwidth=4
set expandtab
set undofile
set smartcase
set history=1000
set undolevels=1000
set relativenumber
syntax on
colorscheme slate
set nocompatible
set splitbelow

"search options
set incsearch
set showmatch
set hlsearch
nnoremap <CR> :noh<CR><CR>

"Powerline Stuff
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
set  rtp+=/usr/local/lib/python3.5/dist-packages/powerline/bindings/vim/
set laststatus=2
set t_Co=256

"Switch between splits with Ctrl+vimKeys
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"remap arrowkeys to move between wrapped lines (a.k.a visual lines)
imap <silent> <Down> <C-o>gj
imap <silent> <Up> <C-o>gk
nmap <silent> <Down> gj
nmap <silent> <Up> gk

"compile latex documents, bibtex and toggle spell cheking
autocmd Filetype tex nnoremap <F2> :up \| :silent !pdflatex -synctex=1 -interaction=nonstopmode --shell-escape main.tex<CR>:redr!<CR> 
autocmd Filetype tex nnoremap <F8> :silent !bibtex main.aux<CR>:redr!<CR>
autocmd Filetype tex nnoremap <F4> :setlocal spell! spelllang=en<CR>

"run Python files
autocmd Filetype python noremap <F2> :silent :write! !python %<CR>:redr!<CR>


"copy-paste from/to clipboard (requires gvim)
map <C-y> "+y
map <C-p> "+p

"Vim-Plug setup and Plugins; run :PlugInstall to install them when on a new machine
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-commentary' "Type 'gcc' to comment out a line, or 'gc' to comment selected text in visual mode. also works with action cmds like 'gc10j'  
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-surround'   "The word you need to remeber is *surrounding*: delete surrounding '*' (ds*) or change the surrounding {} (cs{) 
                            "Pick opening or closing paren, works on both
Plug 'vimwiki/vimwiki'
Plug 'gioele/vim-autoswap'
Plug 'scrooloose/nerdtree', {'for': 'python'}
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'scrooloose/syntastic', {'for': 'python'}
call plug#end()

filetype plugin on
set wildmenu

autocmd BufWritePost ~/.Xresources !xrdb %

autocmd filetype tex set linebreak "when writing latex, don't break words in half when wrapping. Doesn't change much but it soothes my computer autism. 

"Syntastic optiona
" autocmd filetype python set statusline+=%#warningmsg#
" autocmd filetype python set statusline+=%{SyntasticStatuslineFlag()}
" autocmd filetype python set statusline+=%*

autocmd filetype python let g:syntastic_always_populate_loc_list = 1
autocmd filetype python let g:syntastic_auto_loc_list = 1
autocmd filetype python let g:syntastic_check_on_open = 1
autocmd filetype python let g:syntastic_check_on_wq = 0
let g:syntastic_quiet_messages = { "type": "style" }

command! MakeTags !ctags -R .
