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
" Plug 'vim-syntastic/syntastic'
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
" Plug 'windwp/nvim-autopairs'
" Markdown
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
" Automatic session saving and loading
Plug 'wilon/vim-auto-session'
" Metal syntax highlighting
Plug 'tklebanoff/metal-vim'
" HTML snippets and shortcuts
Plug 'mattn/emmet-vim'
" Dep for vim-svelte
Plug 'othree/html5.vim'
" Dep for vim-svelte
Plug 'pangloss/vim-javascript'
" Svelte syntax highlighting and indentation support
Plug 'evanleck/vim-svelte', {'branch': 'main'}

if has("nvim")
  " File explorer
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'kyazdani42/nvim-tree.lua'
  " Language servers
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
  " Fuzzy finder
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  " Advanced syntax highlighting
  Plug 'nvim-treesitter/nvim-treesitter'
  " Easier text navigation
  Plug 'phaazon/hop.nvim'
endif

call plug#end()

" SECTION: Settings

" Syntax highlighting
syntax on
" Full colours
set t_Co=256
" Theme
colorscheme palenight
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
" Additional session saving options
set sessionoptions+=terminal,folds,blank,help,winsize,localoptions,tabpages

" Disable stupid SQL completion plugin
let g:loaded_sql_completion = 0
let g:omni_sql_no_default_maps = 1

" Add coc statusline
if has("nvim")
  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
  " Fix bad completion menu fg colour"
  hi CocMenuSel ctermfg=237 ctermbg=39
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
tnoremap <esc> <C-\><C-n>

" Go back one navigation step
nnoremap <silent> gb <C-o>

" Clear highlights
nnoremap <leader>u :nohl<CR>

" Go one pane up
nnoremap <silent> <c-k> :wincmd k<CR>
inoremap <silent> <c-k> <esc>:wincmd k<CR>
tmap <silent> <c-k> <esc>:wincmd k<CR>
" Go one pane down
nnoremap <silent> <c-j> :wincmd j<CR>
inoremap <silent> <c-j> <esc>:wincmd j<CR>
tmap <silent> <c-j> <esc>:wincmd j<CR>
" Go one pane left
nnoremap <silent> <c-h> :wincmd h<CR>
inoremap <silent> <c-h> <esc>:wincmd h<CR>
tmap <silent> <c-h> <esc>:wincmd h<CR>
" Go one pane right
nnoremap <silent> <c-l> :wincmd l<CR>
inoremap <silent> <c-l> <esc>:wincmd l<CR>
tmap <silent> <c-l> <esc>:wincmd l<CR>

" SECTION: Nvim-only mappings

if has("nvim")
  " Confirm completion
  inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  " Next completion or trigger completion
  function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction
  inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

  " Previous completion
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"


  " Previous diagnostic
  nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
  " Next diagnostic
  nnoremap <silent> ]g <Plug>(coc-diagnostic-next)
  " Go to definition of symbol under cursor
  nnoremap <silent> gd <Plug>(coc-definition)
  " Show documentation for symbol under cursor
  nnoremap <silent> K <cmd>call <SID>ShowDocumentation()<CR>

  " Find files
  nnoremap <leader>ff <cmd>Telescope git_files<cr>
  " Find help tags
  nnoremap <leader>fh <cmd>Telescope help_tags<cr>
  " Grep project
  nnoremap <leader>fs <cmd>Telescope live_grep<cr>
  " Resume last search
  nnoremap <leader>fr <cmd>Telescope resume<cr>

  " Open Package.swift and resize the NvimTree (should be run from file view)
  nnoremap <C-s> <cmd>call SetupSwiftWorkspace()<cr>

  " Toggle file explorer
  nnoremap <C-x> <cmd>NvimTreeToggle<CR>

  " Hop to word
  nnoremap <leader>w <cmd>HopWord<CR>
  " Hop to occurence of character
  nnoremap <leader>c <cmd>HopChar1<CR>
  " Hop to first non-whitespace character of line
  nnoremap <leader>l <cmd>HopLineStart<CR>
  " Hop to pattern matches
  nnoremap <leader>/ <cmd>HopPattern<CR>

  " Open a terminal
  nnoremap <leader>t <cmd>call OpenTerminal()<cr>

  " Restart coc
  nnoremap <leader>rs <cmd>CocRestart<cr><cr>
  " Coc action
  nnoremap <leader>ac <Plug>(coc-codeaction)<cr>
  " Coc fix
  nnoremap <leader>fi <Plug>(coc-fix-current)<cr>
  " Coc rename
  nnoremap <leader>rn <Plug>(coc-rename)
  " Coc format
  nnoremap <leader>fo <Plug>(coc-format)

  nnoremap <leader>gr <Plug>(coc-references)
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
command! -nargs=0 Cheat :e ~/Desktop/Projects/Notes/VimCheat.md
" Open project ideas
command! -nargs=0 ProjIdeas :e ~/Desktop/Projects/Notes/Ideas.md
" Useful resources
command! -nargs=0 Resources :e ~/Desktop/Projects/Notes/Resources.md
" Hacking
command! -nargs=0 Hacking :e ~/Desktop/Projects/Notes/Hacking.md

" SECTION: Autocommands

" Metal filetype
autocmd BufNewFile,BufRead *.metal set ft=metal

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
  " Always enter terminal windows in insert mode
  autocmd BufWinEnter,WinEnter term://* startinsert
  " Disable line numbers and set height of terminal to 10 on open
  autocmd TermOpen * call SetupTerminal()
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
  " Hop
  lua require'hop'.setup()

  " Tree sitter
  lua << EOF
  require'nvim-treesitter.configs'.setup {
    ensure_installed = { "swift", "rust" },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  }
EOF

  " File tree
  lua << EOF
  require'nvim-tree'.setup {
    view = {
      preserve_window_proportions = true,
      mappings = {
        list = {
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
    local trash_cmd = "trash "

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

  function! OpenTerminal()
    split
    wincmd j
    terminal
    call SetupTerminal()
    startinsert
  endfunction

  function! SetupTerminal()
    setlocal nonumber norelativenumber
    exe 10 "wincmd _"
  endfunction
endif
