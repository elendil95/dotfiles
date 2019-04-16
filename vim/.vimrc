" This is just a very basic Vimrc without plugins. grab the plugins you need depending on the setup.
set number
set tabstop=4
set shiftwidth=4
set expandtab

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

syntax on
colorscheme slate

" compile latex from within cwd (change name of file if you need to)
nnoremap <F2> :up \| :silent !pdflatex -synctex=1 -interaction=nonstopmode main.tex<CR>:redr!<CR>
nnoremap <F8> :silent !bibtex main.aux<CR>:redr!<CR>

" toggle spell-checking.
nnoremap <F4> :setlocal spell! spelllang=en<CR>

"copy-paste from/to clipboard (requires gvim)
map <C-y> "+y
map <C-p> "+p

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
call plug#end()
filetype plugin on
set wildmenu
autocmd BufWritePost ~/.Xresources !xrdb %

autocmd filetype tex set linebreak "when writing latex, don't break words in half when wrapping. Doesn't change much but it soothes my computer autism. 
