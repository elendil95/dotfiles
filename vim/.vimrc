set number "Enables line numbering
set relativenumber "Enable relative numbering. 
"Used along with he previous option, the current line nr. will only be shown for the current line.

set tabstop=2 "How many spaces is a tab
set shiftwidth=2 "how many spaces to shift when using automatic indenting and/or > and <
set expandtab "Automatically convert tabs into spaces.

set smartcase "When searching, writing all lowercase will perform a case-insensitive search.

set undofile "Make undos and history for a file persisit across reboots, by creating hidden undo files.
set history=100 "How many entries of cmd history to keep (':' commands). History is saved to RAM unless 'undofile' is set
set undolevels=100 "how many levels of undo to keep. Undos are saved to RAM unless 'undofile' is set

syntax on "Enable syntax highlighting
colorscheme slate
set nocompatible "Disacard settings for VI backward-compatibility
set splitbelow "When opening a file in a horizontal split, put the new file below the old one by default

"search options
set incsearch "Start searching as i type
set hlsearch "Highlight matches
set showmatch "Show all matches, not just the current one
nnoremap <CR> :noh<CR><CR> 
"Press Enter in normal mode to get rid of the highlight, it stays one even after the search is done

"Powerline Stuff
" python3 from powerline.vim import setup as powerline_setup
" python3 powerline_setup()
" python3 del powerline_setup
" set  rtp+=/usr/local/lib/python3.5/dist-packages/powerline/bindings/vim/
" set laststatus=2
" set t_Co=256

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
autocmd Filetype tex,markdown nnoremap <F4> :setlocal spell! spelllang=en<CR>

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
Plug 'tpope/vim-surround'   "The word you need to remeber is *surrounding*: delete surrounding '*' (ds*) or change the surrounding {} (cs{) 
                            "Pick opening or closing paren, works on both
Plug 'sheerun/vim-polyglot' "Expand vim language support
" Plug 'vimwiki/vimwiki'
Plug 'gioele/vim-autoswap' "When a file is open in a vim buffer, and you try to open it again from another terminal, switch to it instead of prompting the user.
call plug#end()

filetype plugin on
set wildmenu "Add horizontal menu at the bottom, with tab completion.

autocmd BufWritePost ~/.Xresources !xrdb %

autocmd filetype tex set linebreak "when writing latex, don't break words in half when wrapping. Doesn't change much but it soothes my computer autism. 

command! MakeTags !ctags -R . "Type MakeTags in command mode to generate tags for the current file, allowing 'Jump to definition' and stuff

"Syntastic optiona
" autocmd filetype python set statusline+=%#warningmsg#
" autocmd filetype python set statusline+=%{SyntasticStatuslineFlag()}
" autocmd filetype python set statusline+=%*
" autocmd filetype python let g:syntastic_always_populate_loc_list = 1
" autocmd filetype python let g:syntastic_auto_loc_list = 1
" autocmd filetype python let g:syntastic_check_on_open = 1
" autocmd filetype python let g:syntastic_check_on_wq = 0
" let g:syntastic_quiet_messages = { "type": "style" }

