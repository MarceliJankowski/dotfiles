return {
	"nvim-treesitter/nvim-treesitter", -- interface for treesitter parser generator. Exposes various features, such as enchanced syntax highlighting
	build = ":TSUpdate",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring", -- context aware commenting
		"windwp/nvim-ts-autotag", -- automatically closes and renames HTML tags
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			-- list of parser names, or "all"
			ensure_installed = { "c" },

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = true,

			-- List of parsers to ignore installing (for "all")
			-- ignore_install = { "javascript" },

			---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
			-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

			highlight = {
				-- `false` will disable the whole extension
				enable = true,

				-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
				-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
				-- the name of the parser)
				-- list of languages that will be disabled
				disable = { "css" },

				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = false,
			},

			autotag = {
				enable = true, -- enable nvim-ts-autotag
			},

			autopairs = {
				enable = true, -- enable nvim-autopairs
			},
		})

		-- skip backwards compatibility routines and speed up loading
		vim.g.skip_ts_context_commentstring_module = true

		require("ts_context_commentstring").setup({
			enable_autocmd = false, -- disable autocmd so that this extension is only triggered when commenting (Comment.nvim plugin has a pre_hook for this one)
		})
	end,
}
