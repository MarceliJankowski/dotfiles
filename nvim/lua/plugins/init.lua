-- plugins with no/minimal config required
return {
	--------------------------------------------------
	--               FILE NAVIGATION                --
	--------------------------------------------------

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
	--                  UTILITIES                   --
	--------------------------------------------------

	"ntpeters/vim-better-whitespace", -- highlights trailing whitespace

	--------------------------------------------------
	--              MOTION RELATED                  --
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
	--             SYNTAX HIGHLIGHTING              --
	--------------------------------------------------

	"leafgarland/typescript-vim", -- TS syntax highlighting

	"maxmellon/vim-jsx-pretty", -- JSX highlighting

	"yuezk/vim-js", -- recommended by vim-jsx-pretty

	--------------------------------------------------
	--                   TMUX                       --
	--------------------------------------------------

	"christoomey/vim-tmux-navigator", -- seamless vim/tmux navigation (requires tween plugin on the tmux side)
}
