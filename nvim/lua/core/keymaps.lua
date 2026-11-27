vim.o.timeout = true
vim.o.timeoutlen = 300

-----------------------------------------------------
--------------- General Stuff -----------------------
-----------------------------------------------------
local cheat_sheet = function()
	require("core.cheatsheet").open()
end
-- F1 works across terminals; Ctrl+Shift+/ does not.
vim.keymap.set({ "n", "v" }, "<F1>", cheat_sheet, { desc = "Open keymap cheat sheet" })
vim.keymap.set({ "n", "v" }, "<leader>?", cheat_sheet, { desc = "Open keymap cheat sheet" })
vim.api.nvim_create_user_command("CheatSheet", cheat_sheet, {})

vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Toggle GitHub-style Markdown preview" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines down in visual selection" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines up in visual selection" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join the current line with the one below it" })
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })

vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move up in buffer with cursor centered" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move down in buffer with cursor centered" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Next match, centered, fold opened" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous match, centered, fold opened" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
vim.keymap.set("n", "<leader>C", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
vim.keymap.set(
	"n",
	"<leader>ur",
	"<cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / clear search / update diff" }
)

vim.keymap.set("v", "<", "<gv", { desc = "Indent selection left and keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent selection right and keep selection" })

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format current buffer with LSP" })

-- Replace the word under the cursor, globally.
vim.keymap.set(
	"n",
	"<leader>r",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace the current word globally" }
)

vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { desc = "Make current file executable" })
vim.keymap.set("n", "<leader>XX", "<cmd>!chmod +x % && ./%<CR>", { desc = "Make executable and run" })
vim.keymap.set("n", "<leader>mk", "<cmd>!cd build && make clean && make<CR>", { desc = "Build project" })
vim.keymap.set("n", "<leader>rt", "<cmd>!cd build && make clean && make && ctest<CR>", { desc = "Build and run tests" })
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "Open Lazy plugin manager" })

vim.keymap.set("n", "<leader>fp", function()
	local path = vim.fn.expand("%:~")
	vim.fn.setreg("+", path)
	vim.notify("Copied path: " .. path)
end, { desc = "Copy file path to clipboard" })

-- Diagnostics.
local diagnostic_jump = function(next, severity)
	return function()
		vim.diagnostic.jump({
			count = (next and 1 or -1) * vim.v.count1,
			severity = severity and vim.diagnostic.severity[severity] or nil,
			float = true,
		})
	end
end
vim.keymap.set("n", "]d", diagnostic_jump(true), { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", diagnostic_jump(false), { desc = "Previous diagnostic" })
vim.keymap.set("n", "]e", diagnostic_jump(true, "ERROR"), { desc = "Next error" })
vim.keymap.set("n", "[e", diagnostic_jump(false, "ERROR"), { desc = "Previous error" })

local isLspDiagnosticsVisible = true
vim.keymap.set("n", "<leader>lx", function()
	isLspDiagnosticsVisible = not isLspDiagnosticsVisible
	vim.diagnostic.config({
		virtual_text = isLspDiagnosticsVisible,
		underline = isLspDiagnosticsVisible,
	})
end, { desc = "Toggle LSP diagnostics" })

vim.keymap.set("n", "<leader>uh", function()
	local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
	vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
end, { desc = "Toggle inlay hints" })

-- LSP commands.
local function installed_servers()
	local ok, servers = pcall(function()
		return require("mason-lspconfig").get_installed_servers()
	end)
	return ok and servers or {}
end

vim.api.nvim_create_user_command("LspInfo", function()
	vim.cmd("checkhealth vim.lsp")
end, {})

vim.api.nvim_create_user_command("LspStop", function()
	for _, client in ipairs(vim.lsp.get_clients()) do
		client:stop()
	end
end, {})

vim.api.nvim_create_user_command("LspStart", function()
	local names = {}
	for _, name in ipairs(installed_servers()) do
		if vim.lsp.config[name] then
			table.insert(names, name)
		end
	end
	vim.lsp.enable(names)
end, {})

vim.api.nvim_create_user_command("LspRestart", function()
	local names = {}
	for _, client in ipairs(vim.lsp.get_clients()) do
		names[client.name] = true
	end
	for _, client in ipairs(vim.lsp.get_clients()) do
		client:stop()
	end
	vim.defer_fn(function()
		if next(names) then
			vim.lsp.enable(vim.tbl_keys(names))
		end
		vim.cmd("edit")
	end, 100)
end, {})

vim.keymap.set("n", "<leader>cn", function()
	require("notify").dismiss({ silent = false, pending = false })
end, { desc = "Clear notifications" })

vim.cmd([[cnoreabbrev W SudaWrite]])

-----------------------------------------------------
-------------- Clipboard Stuff ----------------------
-----------------------------------------------------
vim.keymap.set("x", "<leader>P", [["_dp]], { desc = "Paste without yanking" })
vim.keymap.set("v", "p", [["_dp]], { desc = "Paste without yanking selection" })
vim.keymap.set("n", "x", [["_x]], { desc = "Delete char without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>Ds", [["_d]], { desc = "Delete without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>Dl", [["_dd]], { desc = "Delete line without yanking" })

-----------------------------------------------------
----------------- Tab / Buffer Stuff ----------------
-----------------------------------------------------
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open a new tab" })
vim.keymap.set("n", "<leader>tO", "<cmd>tabnew %<CR>", { desc = "Open current file in a new tab" })
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close a tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Previous tab" })

vim.keymap.set("n", "[b", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })

-----------------------------------------------------
----------------- splits Stuff ----------------------
-----------------------------------------------------
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to up split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Leave terminal mode" })

-----------------------------------------------------
--------------- Autocommands Stuff ------------------
-----------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Close helper windows with q.
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("close-with-q", { clear = true }),
	pattern = { "checkhealth", "help", "lspinfo", "man", "notify", "qf", "query", "trouble" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
	end,
})
