vim.loader.enable()

-- Set leaders before anything else loads plugins.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("core.options")
require("core.runtime-fix")
require("core.keymaps")
require("lazy_setup")
require("current-theme")
