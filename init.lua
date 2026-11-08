
-- Set <space> as the leader key
-- See `:h mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '

-- OPTIONS
--
-- See `:h vim.o`
-- NOTE: You can change these options as you wish!
-- For more options, you can see `:h option-list`
-- To see documentation for an option, you can use `:h 'optionname'`, for example `:h 'number'`
-- (Note the single quotes)

vim.o.number = true -- Show line numbers in a column.

-- Show line numbers relative to where the cursor is.
-- Affects the 'number' option above, see `:h number_relativenumber`.
vim.o.relativenumber = true

-- to get my old terminal vibes back

local term_buf, term_win
local function toggle_term()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_hide(term_win)
    term_win = nil
    return
  end
  vim.cmd('botright 15split')
  term_win = vim.api.nvim_get_current_win()
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    vim.api.nvim_win_set_buf(term_win, term_buf)
  else
    vim.cmd.terminal()
    term_buf = vim.api.nvim_get_current_buf()
  end
  vim.cmd.startinsert()
end

vim.keymap.set('n', '<leader>ft', toggle_term, { desc = 'Toggle terminal' })
vim.keymap.set('t', '<A-t>', toggle_term, { desc = 'Toggle terminal' })
-- Sync clipboard between OS and Neovim. Schedule the setting after `UIEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:h 'clipboard'`
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.o.clipboard = 'unnamedplus'
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'rust',
  callback = function() vim.keymap.set('i', "'", "'", { buffer = true }) end,
})

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.cursorline = true -- Highlight the line where the cursor is on.
vim.o.scrolloff = 10 -- Keep this many screen lines above/below the cursor.
vim.o.list = true -- Show <tab> and trailing spaces.

-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s). See `:h 'confirm'`
vim.o.confirm = true

-- need fzf as variable

-- KEYMAPS
--
-- See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
vim.keymap.set({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set({ 't', 'i' }, '<A-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set({ 'n' }, '<A-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<A-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<A-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<A-l>', '<C-w>l')

--Quick save
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>')

-- make missing : less annoying
vim.keymap.set('n', ';', ':')


-- Map shift + H and shift + L to go to start and end of line
vim.keymap.set({'n', 'v'}, 'H', '^')
vim.keymap.set({'n', 'v'}, 'L', '$')


-- AUTOCOMMANDS (EVENT HANDLERS)
--
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- USER COMMANDS: DEFINE CUSTOM COMMANDS
--
-- See `:h nvim_create_user_command()` and `:h user-commands`

-- Create a command `:GitBlameLine` that print the git blame for the current line
vim.api.nvim_create_user_command('GitBlameLine', function()
  local line_number = vim.fn.line('.') -- Get the current line number. See `:h line()`
  local filename = vim.api.nvim_buf_get_name(0)
  print(vim.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }):wait().stdout)
end, { desc = 'Print the git blame for the current line' })


-- rust quick build test thingy
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'rust',
  callback = function() vim.cmd.compiler('cargo') end,
})

vim.keymap.set('n', '<leader>cb', '<cmd>make build<cr>',  { desc = 'cargo build' })
vim.keymap.set('n', '<leader>cc', '<cmd>make clippy<cr>', { desc = 'cargo clippy' })
vim.keymap.set('n', '<leader>ct', '<cmd>make test<cr>',   { desc = 'cargo test' })
vim.keymap.set('n', ']q', '<cmd>cnext<cr>')
vim.keymap.set('n', '[q', '<cmd>cprev<cr>')
-- PLUGINS
--
-- See `:h :packadd`, `:h vim.pack`

-- Add the "nohlsearch" package to automatically disable search highlighting after
-- 'updatetime' and when going to insert mode.
vim.cmd('packadd! nohlsearch')

-- Install third-party plugins via "vim.pack.add()".
vim.pack.add({
  -- Quickstart configs for LSP
  'https://github.com/neovim/nvim-lspconfig',
  -- Fuzzy picker
  'https://github.com/ibhagwan/fzf-lua',
  -- Autocompletion
  'https://github.com/nvim-mini/mini.completion',
  -- Enhanced quickfix/loclist
  'https://github.com/stevearc/quicker.nvim',
  -- Git integration
  'https://github.com/lewis6991/gitsigns.nvim',
  -- the wakatime for hackatime
  'https://github.com/wakatime/vim-wakatime',
  -- the statusline
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-lualine/lualine.nvim'
  --the theme
  'https://github.com/sainnhe/gruvbox-material',
  -- which-key for info
  'https://github.com/folke/which-key.nvim',
  --to automatically end starting parenthesis with ending one
  'https://github.com/nvim-mini/mini.pairs',
  -- to add surrounding brackets when needed
  'https://github.com/nvim-mini/mini.surround',
})


require('fzf-lua').setup { fzf_colors = true }
local fzf = require('fzf-lua')

-- Map <leader>ff to FzfLua files
vim.keymap.set('n', '<leader>ff', fzf.files, {desc= "Find Files"})
vim.keymap.set('n', '<leader>fg', fzf.live_grep, {desc= "Grep project"})
vim.keymap.set('n', '<leader>fb', fzf.buffers, {desc= "Find Buffers"})
vim.keymap.set('n', '<leader><leader>', fzf.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Close buffer' })


require('mini.pairs').setup {}
require('mini.surround').setup {}
require('mini.completion').setup {}
require('quicker').setup {}
vim.keymap.set('n', '<leader>q', function() require('quicker').toggle() end, { desc = 'Toggle quickfix' })
vim.keymap.set('n', '<leader>cd', vim.diagnostic.setqflist, { desc = 'Diagnostics to quickfix' })

require('gitsigns').setup {}
require('which-key').setup {}
require('which-key').add({
  { '<leader>f', group = 'find' },
  { '<leader>c', group = 'cargo / code' },
  { '<leader>b', group = 'buffer' },
  { 's', group = 'substitute' },
})

vim.o.background = 'dark'
vim.cmd.colorscheme('gruvbox-material')
-- the bottom status line
-- plain bar: same background for every section, no colored mode block
local theme = require('lualine.themes.auto')
for _, m in pairs(theme) do m.a, m.b = m.c, m.c end

require('lualine').setup {
  options = {
    theme = theme,
    globalstatus = true,
    section_separators = '',
    component_separators = '',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'filename' },
    lualine_c = { 'lsp_status', 'branch' },
    lualine_x = { 'diff', 'diagnostics' },
    lualine_y = { function() return os.date('%H:%M') end },
    lualine_z = { 'progress', 'location' },
  },
}


-- LSP slop
vim.lsp.config('lua_ls', {
  settings = { Lua = {
    runtime = { version = 'LuaJIT' },
    diagnostics = { globals = { 'vim' } },
    workspace = { library = { vim.env.VIMRUNTIME } },
  } },
})
vim.lsp.enable({ 'rust_analyzer', 'clangd', 'zls', 'lua_ls' })

vim.lsp.inlay_hint.enable()
vim.diagnostic.config({ virtual_text = true, severity_sort = true })

-- format on save, only for the languages you work in
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.rs', '*.c', '*.cpp', '*.h', '*.zig' },
  callback = function() vim.lsp.buf.format({ async = false }) end,
})
