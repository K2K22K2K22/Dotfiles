local opt = vim.opt

-- oil.nvim replaces netrw.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Undo history outside the project tree.
opt.undodir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(vim.fn.stdpath("state") .. "/undo", "p")

-- Line numbers.
opt.number = true
opt.relativenumber = true

-- Clipboard.
opt.clipboard = "unnamedplus"

-- Indentation.
opt.autoindent = true
opt.smartindent = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.shiftround = true
opt.backspace = { "start", "eol", "indent" }

-- Searching.
opt.incsearch = true
opt.inccommand = "split"
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Backups and swaps.
opt.swapfile = false
opt.backup = false
opt.undofile = true

-- UI.
opt.wrap = true
opt.linebreak = true
opt.showbreak = "↳ "
opt.termguicolors = true
opt.background = "dark"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.cursorline = true
opt.showmode = false -- lualine shows it.
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.title = true
opt.updatetime = 200
opt.mouse = "a"
opt.confirm = true
opt.completeopt = "menu,menuone,noselect"
opt.formatoptions:remove({ "c", "r", "o" })
opt.fillchars = { eob = " " }
opt.pumblend = 10
opt.pumheight = 12
opt.winminwidth = 5

-- Search with ripgrep when available.
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"

-- Skip unused providers: faster startup.
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
