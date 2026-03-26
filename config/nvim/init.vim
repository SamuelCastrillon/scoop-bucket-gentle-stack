" Gentleman.Dots - Main Neovim Configuration
" Loaded on startup after defaults.vim

" Load Windows-specific configuration if on Windows
if has('win32') || has('win64')
    let s:windows_vim = fnamemodify(stdpath('config'), 's') . '/windows.vim'
    if filereadable(s:windows_vim)
        source `=s:windows_vim`
    endif
endif

" Set up plugin management (lazy.nvim style)
" Plugins are defined in plugins.vim
runtime! plugins.vim

" Basic options
set encoding=utf-8
set fileencoding=utf-8
set number              " Show line numbers
set relativenumber      " Relative line numbers
set cursorline          " Highlight current line
set cursorcolumn        " Highlight current column
set signcolumn=yes      " Always show sign column
set nowrap              " Don't wrap lines
set scrolloff=8         " Lines around cursor when scrolling
set sidescrolloff=8    " Columns around cursor when scrolling
set showmode            " Show mode in command line
set showcmd             " Show incomplete commands
set wildmenu            " Enhanced command-line completion
set wildignore+=*.o,*.obj,*.pyc,*.class,*.jar " Ignore these in completion

" Indentation
set autoindent          " Auto-indent new lines
set smartindent         " Smart indent
set tabstop=4           " Number of spaces that a <Tab> in the file counts for
set softtabstop=4       " Number of spaces that <Tab> counts for while editing
set shiftwidth=4        " Number of spaces for autoindent
set expandtab           " Use spaces instead of tabs
set shiftround          " Round indent to multiple of 'shiftwidth'

" Search
set incsearch           " Incremental search
set hlsearch            " Highlight search matches
set ignorecase          " Ignore case in search
set smartcase           " Override ignorecase when pattern has uppercase
set grepprg=rg\ --vimgrep " Use ripgrep for grep

" Splits
set splitright          " New vertical split goes to the right
set splitbelow          " New horizontal split goes below
set fillchars+=diff:╱   " Better diff display

" UI
set termguicolors       " Use true colors in terminal
set mouse=a             " Enable mouse in all modes
set conceallevel=0      " Don't hide concealed text
set confirm            " Confirm before closing with unsaved changes
set hidden              " Hide buffers instead of closing them

" Performance
set lazyredraw          " Don't redraw during macros and scripts
set synmaxcol=240       " Limit syntax highlighting for performance

" Backup and swap
set nobackup            " Don't keep backup files
set nowritebackup       " Don't create backup while editing
set noswapfile          " Don't create swap files

" Formatting
set formatoptions-=cro  " Don't auto-wrap comments

" Maps
let mapleader = ' '
let maplocalleader = ' '

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Better vertical navigation
nnoremap <leader>j :<C-u>call winrestview(#{topline: winrestview().topline + 10})<CR>
nnoremap <leader>k :<C-u>call winrestview(#{topline: winrestview().topline - 10})<CR>

" Clear search highlights
nnoremap <leader><leader> :nohlsearch<CR>

" Quick exit
nnoremap <leader>q :quit<CR>
nnoremap <leader>Q :quitall<CR>

" Save with Ctrl-s
nnoremap <C-s> :w<CR>
inoremap <C-s> <C-o>:w<CR>

" Split navigation
nnoremap <leader>h :split<CR>
nnoremap <leader>v :vsplit<CR>

" Move to beginning/end of line
nnoremap B ^
nnoremap E g_

" Stay in indent mode
nnoremap < <gv
nnoremap > >gv

" Better paste
nnoremap p ]p
nnoremap P ]P

" Highlight yanked text
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="Search", timeout=200}
augroup END

" Auto-commands
augroup gentlemandots
    autocmd!
    
    " Remember last cursor position
    autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif
    
    " Trim trailing whitespace on save (except for some file types)
    autocmd BufWritePre *
        \ if &ft !~# 'markdown' && &ft !~# 'diff'
        \ |   %s/\s\+$//e
        \ | endif
    
    " Set spell for certain file types
    autocmd FileType gitcommit,markdown set spell
augroup END

" Colorscheme (loaded after plugins)
if has('termguicolors') && !exists('g:colors_name')
    colorscheme industry  " Fallback colorscheme
endif
