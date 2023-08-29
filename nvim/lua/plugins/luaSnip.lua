return {
	"L3MON4D3/LuaSnip", -- snippet engine
	version = "2.*", -- follow latest release
	build = "make install_jsregexp", -- install jsregexp (optional)
	dependencies = {
		"rafamadriz/friendly-snippets", -- snippet collection
	},
	config = function()
		-- use existing VS Code style snippets from rafamadriz/friendly-snippets plugin
		require("luasnip.loaders.from_vscode").lazy_load()
	end,
}
