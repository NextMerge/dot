let mapleader = " "
set clipboard=unnamedplus

" use J and K to move page up and down and keep cursor in center of screen
nnoremap J <C-d>zz
nnoremap K <C-u>zz

" use U to redo
nnoremap <C-r> U
nnoremap U <C-r>

" highlight entire scope and focus top of it
nnoremap <leader>{ va{Vo
nnoremap <leader>[ va[Vo
nnoremap <leader>( va(Vo
nnoremap <leader>< vatVo

" paste over highlighted text without yanking it
vnoremap <leader>p "_dP
