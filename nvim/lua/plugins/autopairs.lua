return {
	"windwp/nvim-autopairs", -- automatically closes braces
	event = "InsertEnter",
	config = function()
		require("nvim-autopairs").setup({
			check_ts = true,
			ts_config = {
				-- it will not add a pair on that treesitter node
				lua = { "string" },
				javascript = { "string", "template_string" },
			},
			disable_filetype = { "TelescopePrompt" },
		})

		-- insert `(` after selecting function or method item
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
