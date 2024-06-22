-- plugins with no/minimal config required
return {

	--------------------------------------------------
	--                  UTILITIES                   --
	--------------------------------------------------

	"ntpeters/vim-better-whitespace", -- highlights trailing whitespace

	"kevinhwang91/nvim-bqf", -- better quickfix window

	"kshenoy/vim-signature", -- displays and manages marks

	{
		"moll/vim-bbye", -- deletes buffers without messing up layout
		config = function()
			vim.keymap.set({ "n", "v", "x" }, "<C-w>", "<Cmd>Bdelete<CR>")
		end,
	},

	--------------------------------------------------
	--                    VISUAL                    --
	--------------------------------------------------

	{
		"nvim-tree/nvim-web-devicons", -- adds icons for plugins to use (requires Nerd Font)
		lazy = true,
	},

	{ "kaicataldo/material.vim", branch = "main", priority = 1000, lazy = false }, -- color scheme

	--------------------------------------------------
	--                MOTION RELATED                --
	--------------------------------------------------

	"wellle/targets.vim", -- adds various text objects

	"tpope/vim-surround", -- keymaps to easily delete, change and add surroundings

	--------------------------------------------------
	--                   GIT                        --
	--------------------------------------------------

	{
		"lewis6991/gitsigns.nvim", -- git decorations (gutter ones)
		config = true, -- runs require("gitsigns").setup()
	},

	{
		"tpope/vim-fugitive", -- gateway to git
		cmd = { "Git", "G" },
	},

	--------------------------------------------------
	--                LANGUAGE TOOLS                --
	--------------------------------------------------

	"leafgarland/typescript-vim", -- TS syntax highlighting

	"maxmellon/vim-jsx-pretty", -- JSX highlighting

	"yuezk/vim-js", -- recommended by vim-jsx-pretty

	{
		"mrcjkb/rustaceanvim", -- rust development tools
		lazy = false, -- this plugin is already lazy
	},
}
