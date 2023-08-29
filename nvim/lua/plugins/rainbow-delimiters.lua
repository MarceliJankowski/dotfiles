return {
	"HiPhish/rainbow-delimiters.nvim", -- rainbow delimiters
	config = function()
		local rainbow_delimiters = require("rainbow-delimiters")

		vim.g.rainbow_delimiters = {
			strategy = {
				[""] = rainbow_delimiters.strategy["global"],
				vim = rainbow_delimiters.strategy["local"],
			},
			query = {
				[""] = "rainbow-delimiters",
				lua = "rainbow-blocks",

				-- don't highlight JSX/TSX tags (only delimiters)
				tsx = "rainbow-parens",
				javascript = "rainbow-parens",
			},
			highlight = {
				"RainbowDelimiterGold",
				"RainbowDelimiterPink",
				"RainbowDelimiterPurple",
				"RainbowDelimiterBlue",
				"RainbowDelimiterCyan",
				"RainbowDelimiterGray",
			},

			-- disable plugin in these filetypes
			blacklist = { "html" },
		}
	end,
}
