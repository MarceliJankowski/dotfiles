return {
	"Valloric/MatchTagAlways", -- highlights XML/HTML tag which encloses my cursor
	config = function()
		-- enable plugin in these filetypes:
		vim.g.mta_filetypes = {
			typescriptreact = 1,
			javascriptreact = 1,
			html = 1,
			xhtml = 1,
			xml = 1,
			jinja = 1,
			php = 1,
		}
	end,
}
