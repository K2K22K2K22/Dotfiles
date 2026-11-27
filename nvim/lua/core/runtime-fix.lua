-- Neovim 0.12's stock markdown ftplugin leaves unmaps in b:undo_ftplugin that
-- throw E31 when FileType reloads. Keep only the treesitter cleanup.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.b.undo_ftplugin = "call v:lua.vim.treesitter.stop()"
	end,
})
