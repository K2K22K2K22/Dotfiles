-- Live keymap cheat sheet. <F1> or <leader>? opens it.
local M = {}

local mode_labels = {
	n = "Normal",
	i = "Insert",
	v = "Visual",
	x = "Visual (charwise)",
	s = "Select",
	t = "Terminal",
	c = "Command",
}

local function label(lhs)
	local leader = vim.g.mapleader or " "
	if leader ~= "" then
		lhs = lhs:gsub(vim.pesc(leader), "Leader")
	end
	return lhs:gsub("<leader>", "Leader")
		:gsub("<localleader>", "LocalLeader")
		:gsub("<C%-", "C-")
		:gsub("<S%-", "S-")
		:gsub("<A%-", "A-")
		:gsub("<CR>", "Enter")
		:gsub("<ESC>", "Esc")
		:gsub("<Tab>", "Tab")
		:gsub("<Space>", "Space")
		:gsub("<Bar>", "|")
		:gsub("[<>]", "")
end

local function build()
	local lines = {
		"NEOVIM CHEAT SHEET",
		"q / Esc close    / search    F1 or Leader? reopen",
		"",
	}
	local seen = {}

	for _, mode in ipairs({ "n", "i", "v", "x", "t", "c" }) do
		local maps = vim.api.nvim_get_keymap(mode)
		vim.list_extend(maps, vim.api.nvim_buf_get_keymap(0, mode))
		local entries = {}

		for _, map in ipairs(maps) do
			if map.desc and map.desc ~= "" then
				local key = label(map.lhs)
				local id = mode .. "|" .. key .. "|" .. map.desc
				if not seen[id] then
					seen[id] = true
					table.insert(entries, { key = key, desc = map.desc })
				end
			end
		end

		if #entries > 0 then
			table.sort(entries, function(a, b)
				return a.key < b.key
			end)
			table.insert(lines, "== " .. (mode_labels[mode] or mode) .. " ==")
			for _, entry in ipairs(entries) do
				table.insert(lines, string.format("  %-20s %s", entry.key, entry.desc))
			end
			table.insert(lines, "")
		end
	end

	return lines
end

function M.open()
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, build())
	vim.api.nvim_buf_add_highlight(buf, -1, "Title", 0, 0, -1)
	vim.bo[buf].modifiable = false
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].filetype = "cheatsheet"

	local height = math.min(40, math.floor(vim.o.lines * 0.85))
	local width = math.min(104, vim.o.columns - 4)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		width = width,
		height = height,
		border = "rounded",
		style = "minimal",
	})
	vim.wo[win].number = false
	vim.wo[win].relativenumber = false
	vim.wo[win].cursorline = true
	vim.wo[win].wrap = false
	vim.wo[win].winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder"

	local close = function()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end
	vim.keymap.set("n", "q", close, { buffer = buf, nowait = true, silent = true })
	vim.keymap.set("n", "<Esc>", close, { buffer = buf, nowait = true, silent = true })
end

return M
