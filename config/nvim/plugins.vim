" Gentleman.Dots - Plugin Configuration
" Define and configure plugins

" Plugin manager (mini.deps style - keep it simple)
" In production, use your preferred plugin manager:
"   - lazy.nvim (recommended)
"   - packer.nvim
"   - vim-plug

" Example plugin setup using built-in packages:
" Place plugins in lua/ directory when using lazy.nvim

" =============================================================================
" Core Plugins (uncomment to enable)
" =============================================================================

" File navigation
" packadd! netrw            " Built-in file explorer
" packadd! fzf              " Fuzzy finder integration
" packadd! telescope        " Highly extendable fuzzy finder

" Git integration
" packadd! git             " Built-in git support
" packadd! gitsigns        " Git signs in the sign column
" packadd! diffview        " Git diff views

" UI enhancements
" packadd! coc             " Conquer of Completion (LSP)
" packadd! lspkind         " VSCode-like icons for LSP
" packadd! dashboard       " Start screen

" Utilities
" packadd! undotree        " Undo tree
" packadd! bookmarks       " Bookmarks
" packadd! which-key       " Keybinding helper

" =============================================================================
" Plugin Configurations
" =============================================================================

" Telescope configuration
" let g:telescope_theme = 'dropdown'
" nnoremap <leader>ff <cmd>Telescope find_files<cr>
" nnoremap <leader>fg <cmd>Telescope live_grep<cr>
" nnoremap <leader>fb <cmd>Telescope buffers<cr>
" nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" LSP configuration
" lua << EOF
" local lsp = require('lspconfig')
" 
" lsp.rust_analyzer.setup({})
" lsp.tsserver.setup({})
" lsp.gopls.setup({})
" lsp.pyright.setup({})
" EOF

" GitSigns configuration
" require('gitsigns').setup({
"     signs = {
"         add = { text = '+' },
"         change = { text = '~' },
"         delete = { text = '_' },
"         topdelete = { text = '‾' },
"         changedelete = { text = '~' },
"     },
" })

" Dashboard configuration
" let g:dashboard_default_executive = 'telescope'
" let g:dashboard_custom_shortcut = {
"     \ 'last_session':       'SPC s l',
"     \ 'find_history':       'SPC f h',
"     \ 'find_files':        'SPC f f',
"     \ 'new_file':          'SPC c n',
"     \ 'change_colorscheme': 'SPC t c',
"     \ 'find_word':         'SPC f a',
"     \ 'bookmarks':         'SPC f b',
"     \ 'git_status':        'SPC g s',
"     \ 'quit':              'SPC q q',
"     \ }

" WhichKey configuration
" let g:which_key_sep = ' '
" let g:which_key_use_floating_win = 0
" nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<cr>
" vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<cr>

" =============================================================================
" Plugin Helper Functions
" =============================================================================

" Lazy loading helper
function! GentlemanLoadPlugin(plugin_name, ft)
    if a:ft == '' || has(a:ft)
        execute 'packadd!' a:plugin_name
    endif
endfunction

" Install plugins (run this to bootstrap)
function! GentlemanInstallPlugins()
    " This is a placeholder - in production, use your plugin manager's
    " install command. For example with lazy.nvim:
    " :Lazy sync
    
    echo "Plugins should be managed by your plugin manager."
    echo "See: https://github.com/folke/lazy.nvim"
endfunction

command! GentlemanInstallPlugins call GentlemanInstallPlugins()

" Update plugins
function! GentlemanUpdatePlugins()
    echo "Update plugins using your plugin manager."
    echo "For lazy.nvim: :Lazy sync"
endfunction

command! GentlemanUpdatePlugins call GentlemanUpdatePlugins()
