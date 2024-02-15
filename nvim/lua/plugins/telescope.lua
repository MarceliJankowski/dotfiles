return {
	"nvim-telescope/telescope.nvim", -- fuzzy finder
	tag = "0.1.5",
	dependencies = {
		"nvim-lua/plenary.nvim", -- collection of nvim lua functions
		"nvim-telescope/telescope-media-files.nvim", -- extension for viewing media files
	},
	config = function()
		local telescope = require("telescope")

		-- load media-files extension
		telescope.load_extension("media_files")

		telescope.setup({
			defaults = {
				layout_strategy = "horizontal",
				layout_config = {
					width = 0.92,
					height = 0.92,
					preview_width = 55,
				},
			},
			extensions = {
				media_files = {
					-- filetypes whitelist
					-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
					filetypes = { "png", "webp", "jpg", "jpeg" },
					find_cmd = "rg", -- defaults to `fd` (ripgrep is faster)
				},
			},
		})

		-- KEYMAPS
		local telescope_builtin = require("telescope.builtin")

		vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files)
		vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep)
		vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers)
		vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags)
		vim.keymap.set("n", "<leader>fm", telescope.extensions.media_files.media_files)

		-- show hidden files (except for '.git' directory), and hide blobs/trees from '.gitignore'
		vim.keymap.set(
			"n",
			"<leader>.",
			"<Cmd>lua require('telescope.builtin').find_files({ find_command = { 'rg', '--files', '--hidden', '-g', '!.git' } })<CR>"
		)
	end,
}
