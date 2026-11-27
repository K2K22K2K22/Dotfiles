return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern",
		spec = {
			{ "<leader>c", group = "[C]ode / Clear" },
			{ "<leader>d", group = "[D]iagnostics" },
			{ "<leader>f", group = "[F]ind / Format / File" },
			{ "<leader>g", group = "[G]it" },
			{ "<leader>i", group = "[I]ndent" },
			{ "<leader>l", group = "[L]int / LSP" },
			{ "<leader>p", group = "[P]icker" },
			{ "<leader>s", group = "[S]plit / Search" },
			{ "<leader>t", group = "[T]ab / Toggle / Theme" },
			{ "<leader>u", group = "[U]ndo / Utility" },
		},
	},
	keys = {
		{
			"<leader>K",
			function() require("which-key").show({ global = false }) end,
			desc = "Buffer-local keymaps",
		},
	},
}
