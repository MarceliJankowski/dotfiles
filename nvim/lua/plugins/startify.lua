return {
	"mhinz/vim-startify", -- awesome start screen
	lazy = false,
	priority = 500,
	init = function()
		vim.g.startify_bookmarks = {
			{ i = "$DOTFILES/nvim/init.lua" },
			{ d = "$DOTFILES" },
			{ n = "$NOTES" },
			{ p = "~/programming" },
			{ s = "$SHELL_SCRIPTS_PATH" },
		}

		vim.g.startify_lists = {
			{ type = "bookmarks", header = { "   Bookmarks" } },
			{ type = "dir", header = { "   Current Directory:" .. vim.fn.expand("%") } },
			{ type = "files", header = { "   Recent Files" } },
		}

		-- KEYMAPS
		vim.keymap.set("n", "<leader>s", "<Cmd>Startify<CR>")
	end,
}
