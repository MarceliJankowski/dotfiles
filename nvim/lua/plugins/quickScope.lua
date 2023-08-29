return {
	"unblevable/quick-scope", -- highlights unique character in every word on a line to help with: [F, f, T, t] motions
	init = function()
		-- trigger a highlight in the appropriate direction when pressing these keys:
		vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }

		-- set colors
		local quickScopeColorsGroup = vim.api.nvim_create_augroup("quickScopeColors", { clear = true })

		vim.api.nvim_create_autocmd("ColorScheme", {
			command = "highlight QuickScopePrimary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline",
			group = quickScopeColorsGroup,
			desc = "set quickScope primary highlight",
		})

		vim.api.nvim_create_autocmd("ColorScheme", {
			command = "highlight QuickScopeSecondary guifg='violet' gui=underline ctermfg=155 cterm=underline",
			group = quickScopeColorsGroup,
			desc = "set quickScope secondary highlight",
		})
	end,
}
