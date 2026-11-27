-- Colors live in each colorscheme's highlight_groups/overrides.
return {
	"HiPhish/rainbow-delimiters.nvim",
	event = "VeryLazy",
	config = function()
		local rainbow_delimiters = require("rainbow-delimiters")

		require("rainbow-delimiters.setup").setup({
			strategy = { [""] = rainbow_delimiters.strategy["global"] },
			query = { [""] = "rainbow-delimiters" },
			highlight = {
				"RainbowDelimiterRed",
				"RainbowDelimiterYellow",
				"RainbowDelimiterBlue",
				"RainbowDelimiterOrange",
				"RainbowDelimiterGreen",
				"RainbowDelimiterViolet",
				"RainbowDelimiterCyan",
			},
		})
	end,
}
