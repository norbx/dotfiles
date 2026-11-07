call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'Mofiqul/vscode.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'branch': 'main', 'do': ':TSUpdate' }
Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-neo-tree/neo-tree.nvim', { 'branch': 'v3.x' }
call plug#end()

set number
set relativenumber
set mouse=a
set clipboard=unnamedplus
set ignorecase smartcase
set expandtab shiftwidth=2 tabstop=2
set termguicolors
set foldlevelstart=99

silent! colorscheme vscode

let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git/*"'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }

nnoremap <C-p> :Files<CR>
nnoremap <D-p> :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>/ :Rg<CR>

function! RemoteOpen(path, line) abort
  if &buftype !=# ''
    for winnr in range(1, winnr('$'))
      if getbufvar(winbufnr(winnr), '&buftype') ==# ''
        execute winnr . 'wincmd w'
        break
      endif
    endfor
  endif
  execute 'drop' fnameescape(a:path)
  if a:line > 0
    execute a:line
    normal! zvzz
  endif
  redraw
endfunction

nnoremap J 7j
nnoremap K 7k
xnoremap J 7j
xnoremap K 7k

nnoremap <silent> <D-b> :execute &filetype ==# 'neo-tree' ? 'Neotree close' : 'Neotree focus'<CR>
nnoremap <silent> <leader>e :execute &filetype ==# 'neo-tree' ? 'Neotree close' : 'Neotree focus'<CR>

lua << EOF
local ok, ts = pcall(require, 'nvim-treesitter')
if ok then
  ts.install({
    'ruby', 'embedded_template', 'javascript', 'typescript', 'tsx',
    'json', 'yaml', 'html', 'css', 'scss', 'sql', 'bash', 'markdown',
    'markdown_inline', 'lua', 'vim', 'vimdoc',
  })
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      if pcall(vim.treesitter.start, args.buf) then
        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      end
    end,
  })
end

local ok_neotree, neotree = pcall(require, 'neo-tree')
if ok_neotree then
  neotree.setup({
    close_if_last_window = true,
    window = {
      width = 60,
    },
    filesystem = {
      window = {
        mappings = {
          ['/'] = { 'fuzzy_finder', config = { keep_filter_on_submit = true } },
        },
        fuzzy_finder_mappings = {
          ['<CR>'] = function(state)
            vim.cmd('stopinsert')
            vim.api.nvim_win_close(0, true)
            vim.schedule(function()
              if vim.api.nvim_win_is_valid(state.winid) then
                vim.api.nvim_set_current_win(state.winid)
                require('neo-tree.sources.filesystem.commands').open(state)
              end
            end)
          end,
        },
      },
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = true,
      },
      use_libuv_file_watcher = true,
      find_by_full_path_words = true,
    },
  })
end
EOF
