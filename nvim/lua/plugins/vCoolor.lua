return {
	"KabbAmine/vCoolor.vim", -- color picker (requires Zenity)
	keys = {
		{ "<M-c>", "<Cmd>VCoolor<CR>", mode = { "n", "i" }, desc = "pick hex color" },
	},
	cmd = "VCoolor",
	config = function()
		-- generate colors in lower case
		vim.g.vcoolor_lowercase = 1

		-- disable default mappings
		vim.g.vcoolor_disable_mappings = 1
	end,
}
