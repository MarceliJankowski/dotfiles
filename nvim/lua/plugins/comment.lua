return {
	"numToStr/Comment.nvim", -- better commenting
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring", -- context aware commenting
	},
	config = function()
		-- KEYMAPS (enable recursive mappings because Comment.nvim doesn't expose API for commenting stuff out)
		vim.keymap.set("n", "<C-/>", "gcc", { remap = true })
		vim.keymap.set({ "v", "x" }, "<C-/>", "gc", { remap = true })
		vim.keymap.set("i", "<C-/>", "<Esc>gccA ", { remap = true })

		-- TMUX registers <C-/> as 
		vim.keymap.set("n", "", "gcc", { remap = true })
		vim.keymap.set({ "v", "x" }, "", "gc", { remap = true })
		vim.keymap.set("i", "", "<Esc>gccA ", { remap = true })

		-- setup nvim-ts-commentstring to work with Comment.nvim
		require("Comment").setup({
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(), -- trigger nvim-ts-context-commentstring
		})
	end,
}
