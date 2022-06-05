" SECTION: Install vim-plug

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" SECTION: Install plugins

call plug#begin()
" Color theme
Plug 'drewtempelmeyer/palenight.vim'
" Syntax checking
Plug 'vim-syntastic/syntastic'
" Statusline
Plug 'itchyny/lightline.vim'
" Auto-detect indentation setting of files
Plug 'tpope/vim-sleuth'
" Show trailing whitespace
Plug 'ntpeters/vim-better-whitespace'
" Syntax highlighting for .swift.gyb, .c.gyb and .sil
Plug 'jph00/swift-apple'
" Show Swiftlint and SwiftPM diagnostics in vim
Plug 'keith/swift.vim'
" Show vim diff next to line numbers
Plug 'airblade/vim-gitgutter'
" Nicer behaviour for brackets and quotes
Plug 'windwp/nvim-autopairs'
" Markdown
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
" Automatic session saving and loading
Plug 'wilon/vim-auto-session'
" Faster text navigation shortcuts
Plug 'easymotion/vim-easymotion'

if has("nvim")
  " File explorer
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'kyazdani42/nvim-tree.lua'
  " Language servers
  Plug 'neoclide/coc.nvim', { 'branch': 'master' }
  " Fuzzy finder
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  " Advanced syntax highlighting
  Plug 'nvim-treesitter/nvim-treesitter'
endif

call plug#end()

" SECTION: Settings

" Theme
colorscheme palenight
" Syntax highlighting
syntax on
" Enable syntax concealing (mainly for markdown)
set conceallevel=2
" Autowrap comments at 100 characters
set formatoptions-=t
set formatoptions+=cr
set textwidth=100
" Line wrap
set wrap
" default file encoding
set encoding=utf-8
" Don't make noise
set visualbell
" Always display status line
set laststatus=2
" Highlight search results
set hlsearch
" Highlight incrementally
set incsearch
" Link clipboard to system clipboard
set clipboard=unnamedplus
" Full colours
set t_Co=256
" Mouse support
set mouse=a
" Disable backup files
set nobackup
set nowritebackup
set shortmess+=c
" Fast updates
set updatetime=300
" Always draw sign column
set signcolumn=yes

" Line numbers
set ruler
set number

" Add coc statusline
if has("nvim")
  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
endif

" SECTION: Mappings

" An easy to reach leader key
nnoremap <SPACE> <Nop>
let mapleader = " "

" Remap ctrl+c to escape
nmap <c-c> <esc>
imap <c-c> <esc>
vmap <c-c> <esc>
omap <c-c> <esc>
tnoremap <c-c> <C-\><C-n>

" Go back one navigation step
nnoremap <silent> gb <C-o>

" Clear highlights
nnoremap <leader>u :nohl<CR>

" Go one pane up
nnoremap <silent> <c-k> :wincmd k<CR>
" Go one pane down
nnoremap <silent> <c-j> :wincmd j<CR>
" Go one pane left
nnoremap <silent> <c-h> :wincmd h<CR>
" Go one pane right
nnoremap <silent> <c-l> :wincmd l<CR>

" Cycle through completions with tab
" If completion popup visible, go to next completion
" If text from start of line to cursor is whitespace, insert tab
" Otherwise, refresh completions
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>CheckBackspace() ? "\<TAB>" :
  \ coc#refresh()
" Cycle through completions backwards with shift tab
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" SECTION: Nvim-only mappings

if has("nvim")
  " Previous diagnostic
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  " Next diagnostic
  nmap <silent> ]g <Plug>(coc-diagnostic-next)
  " Go to definition of symbol under cursor
  nmap <silent> gd <Plug>(coc-definition)
  " Show documentation for symbol under cursor
  nnoremap <silent> K :call <SID>ShowDocumentation()<CR>

  " Find files
  nnoremap <leader>ff <cmd>Telescope git_files<cr>
  " Find help tags
  nnoremap <leader>fh <cmd>Telescope help_tags<cr>
  " Grep project
  nnoremap <leader>fs <cmd>Telescope live_grep<cr>
  " Resume last search
  nnoremap <leader>fr <cmd>Telescope resume<cr>

  " Open Package.swift and resize the NvimTree (should be run from file view)
  nnoremap <leader>w <cmd>call SetupSwiftWorkspace()<cr>

  " Toggle file explorer
  nnoremap <C-x> :NvimTreeToggle<CR>
endif

" SECTION: Commands

" Set tab width
command! -nargs=1 SetTab call SetTab(<f-args>)
" Function to trim extra whitespace in whole file
command! -nargs=0 Trim StripWhitespace
" Open config file
command! -nargs=0 Config :e ~/.vimrc
" Reload config file
command! -nargs=0 Source :source ~/.vimrc
" Open personal cheatsheet
command! -nargs=0 Cheat :e ~/.vimcheat.md

" SECTION: Autocommands

" Disable autopairs for double quotes in vimrc
autocmd Filetype vim let b:AutoPairs = { "(": ")", "{": "}", "[": "]", "'": "'" }

" Stop easy-motion messing with coc
autocmd User EasyMotionPromptBegin silent! CocDisable
autocmd User EasyMotionPromptEnd silent! CocEnable

" Change line number style depending on mode
augroup numbertoggle
  autocmd!
  " If not in insert mode, use relative line numbers
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &number && mode() != "i" | set relativenumber   | endif
  " If in insert mode or unfocussed window, use absolute line numbers
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &number                  | set norelativenumber | endif
augroup END

" SECTION: Nvim-only autocommands

if has("nvim")
  " Highlight the symbol and its references when holding the cursor
  autocmd CursorHold * silent call CocActionAsync('highlight')
  " Update status line on relative coc updates
  autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
endif

" SECTION: Plugin configuration

" Swiftlint
let g:syntastic_swift_checkers = ['swiftlint']

" Set new list item indent to 0 spaces
let g:vim_markdown_new_list_item_indent = 0
" Disable folding (by default all folds are closed by markdown plugin)
let g:vim_markdown_folding_disabled = 1

" Status line
let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'cocstatus': 'coc#status'
  \ },
  \ }

" SECTION: Nvim-only plugin configuration

if has("nvim")
  " Tree sitter
  lua << EOF
  require'nvim-treesitter.configs'.setup {
    -- ensure_installed = { "swift", "rust" },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  }
EOF

  " Autopairs
  lua << EOF
  local npairs = require'nvim-autopairs'
  local Rule = require'nvim-autopairs.rule'
  local ts_conds = require'nvim-autopairs.ts-conds'

  -- Use treesitter for autopairs
  npairs.setup {
    check_ts = true
  }
EOF

  " File tree
  lua << EOF
  require'nvim-tree'.setup {
    view = {
      mappings = {
        list = {
          { key = "<SPACE>", action = "edit", mode = "n" },
          { key = "v", action = "vsplit" },
          { key = "h", action = "split" },
          { key = { "<C-x>", "<C-v>" }, action = "" },
          { key = "d", cb = ":call NvimTreeTrash()<CR>" },
        }
      }
    }
  }
EOF
endif

" SECTION: Functions

" Set tab width to n spaces
function! SetTab(n)
    let &l:tabstop=a:n
    let &l:softtabstop=a:n
    let &l:shiftwidth=a:n
    set expandtab
endfunction

" Show documentation for symbol under cursor
function! s:ShowDocumentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Check if backspace should delete line
function! s:CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" SECTION: Nvim-only functions

if has("nvim")
  " Setup Swift package workspace how I like it
  function! SetupSwiftWorkspace()
    e Package.swift
    NvimTreeToggle
    NvimTreeToggle
    wincmd l
  endfunction

  " Move a file to the trash in NvimTree
  function! NvimTreeTrash()
    lua << EOF
    local lib = require('nvim-tree.lib')
    local node = lib.get_node_at_cursor()
    local trash_cmd = "rmtrash "

    local function get_user_input_char()
    	local c = vim.fn.getchar()
    	return vim.fn.nr2char(c)
    end

    print("Trash "..node.name.." ? y/n")

    if (get_user_input_char():match('^y') and node) then
    	vim.fn.jobstart(trash_cmd .. node.absolute_path, {
    		detach = true,
    		on_exit = function (job_id, data, event) lib.refresh_tree() end,
    	})
    end

    vim.api.nvim_command('normal :esc<CR>')
EOF
  endfunction
endif
