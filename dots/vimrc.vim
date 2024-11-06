let mapleader = " "
set clipboard=unnamedplus

inoremap <C-c> <Esc>

" move page up and down and keep cursor in center of screen
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" use U to redo
nnoremap <C-r> U
nnoremap U <C-r>

" paste over highlighted text without yanking it
vnoremap <leader>p "_dP

" delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" move block of text up and down
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
