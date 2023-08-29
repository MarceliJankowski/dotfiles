return {
	"nvim-lualine/lualine.nvim", -- better status line
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			theme = "material",
			component_separators = "|",
			globalstatus = true,
		},

		sections = {
			lualine_b = { "branch" },
			lualine_x = { "filetype", "encoding", "fileformat" },
		},
	},
}
