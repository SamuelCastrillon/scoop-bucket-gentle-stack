" Windows-specific configuration for Gentleman.Dots Neovim setup
" This file is loaded when Neovim runs on Windows (has('win32') || has('win64'))

" Path translations for Windows compatibility
" Unix paths -> Windows paths

" Set VIM directory to Local AppData on Windows
if has('win32') || has('win64')
    let g:is_windows = 1
    
    " Override $VIM to use LocalAppData (more appropriate for installed apps)
    if empty($VIM)
        let $VIM = expand('$LOCALAPPDATA/nvim')
    endif
    
    " Set XDG_CONFIG_HOME equivalent for Windows
    if empty($XDG_CONFIG_HOME)
        let $XDG_CONFIG_HOME = expand('$APPDATA')
    endif
    
    " Set XDG_DATA_HOME equivalent
    if empty($XDG_DATA_HOME)
        let $XDG_DATA_HOME = expand('$LOCALAPPDATA')
    endif
    
    " Set cache directory
    if empty($XDG_CACHE_HOME)
        let $XDG_CACHE_HOME = expand('$LOCALAPPDATA/nvim-data')
    endif
    
    " Path separator for display
    let g:is_windows_path_sep = has('win32') ? '\' : '/'
    
    " Shell settings for Windows
    if has('win32')
        set shellcmdflag=/s\ /c
        set shellxquote=
        set shellslash       " Use forward slashes in paths
    endif
    
    " Use PowerShell as default shell on Windows
    if executable('pwsh')
        set shell=pwsh
        set shellcmdflag=-c
    elseif executable('powershell')
        set shell=powershell
        set shellcmdflag=-c
    endif
    
    " Disable some Unix-specific features
    " set noswapfile      " Swapfiles can cause issues on Windows network drives
    set nobackup         " No backup files
    set nowritebackup    " Don't create backup files
    
    " Path handling for Windows
    if exists('+shellslash') && !has('win32unix')
        set shellslash
    endif
endif

" Set runtimepath to use Windows directories
function! g: GentlemanSetWindowsPaths() abort
    if has('win32') || has('win64')
        " Neovim config directory
        let s:nvim_config = expand('$LOCALAPPDATA/nvim')
        
        " Add Windows-specific runtime paths
        let &runtimepath = join([
            \ s:nvim_config,
            \ expand('$LOCALAPPDATA/nvim-data'),
            \ expand('$APPDATA/nvim-data'),
            \ ], ',') . ',' . &runtimepath
    endif
endfunction

augroup GentlemanWindows
    autocmd!
    autocmd VimEnter * call GentlemanSetWindowsPaths()
augroup END
