" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Disable backup and swap files unconditionally
set nobackup
set nowritebackup

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  let g:go_fmt_command = "goimports"
  autocmd FileType go setlocal number nowrap textwidth=80

  autocmd FileType c,cpp setlocal number nowrap tabstop=8 shiftwidth=8
    \ softtabstop=8 textwidth=80 noexpandtab cindent cinoptions=:0,l1,t0,g0,(0

  let g:load_doxygen_syntax=1

  autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2 expandtab nowrap
  autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 expandtab nowrap
  autocmd FileType css setlocal shiftwidth=2 tabstop=2 expandtab nowrap
  autocmd FileType scss setlocal shiftwidth=2 tabstop=2 expandtab nowrap
  autocmd FileType json setlocal shiftwidth=2 tabstop=2 expandtab nowrap
  autocmd FileType vue setlocal shiftwidth=4 tabstop=4 expandtab nowrap
  autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab smarttab nowrap
  autocmd FileType lua setlocal shiftwidth=4 tabstop=4 expandtab nowrap number
  augroup END

else

  set autoindent		" always set autoindenting on
  " C in general
  set number
  set nowrap
  set tabstop=8
  set shiftwidth=8
  set softtabstop=8
  set textwidth=80
  set noexpandtab
endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

set colorcolumn=80
