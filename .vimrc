" This is just a very basic Vimrc without plugins. grab the plugins you need depending on the setup.
set number
set tabstop=4
set shiftwidth=4
set expandtab

" python3 from powerline.vim import setup as powerline_setup
" python3 powerline_setup()
" python3 del powerline_setup
" set  rtp+=/usr/local/lib/python3.5/dist-packages/powerline/bindings/vim/
" set laststatus=2
" set t_Co=256
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
syntax on
colorscheme slate

" compile latex from within cwd (change name of file if you need to)
nnoremap <F2> :up \| :silent !pdflatex -synctex=1 -interaction=nonstopmode main.tex<CR>:redr!<CR>
" toggle spell-checking.
nnoremap <F4> :setlocal spell! spelllang=en<CR>
