return {
	"jose-elias-alvarez/null-ls.nvim", -- hooks into neovim builtin LSP for formatting, diagnostics, linters, and so on
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local null_ls = require("null-ls")

		-- formatters
		local formatting = null_ls.builtins.formatting -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting

		-- diagnostics
		local diagnostics = null_ls.builtins.diagnostics -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics

		-- format on save group
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		null_ls.setup({
			-- sources need to be installed on the system and be available without need for providing path
			sources = {
				formatting.stylua, -- lua formatter
				formatting.prettierd, -- faster prettier
				formatting.shfmt, -- shell formatter
				formatting.phpcsfixer, -- php formatter
				formatting.clang_format, -- c formatter

				diagnostics.phpstan, -- php linter
				-- diagnostics.eslint_d, -- faster eslint
			},

			-- format on save
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({
								bufnr = bufnr,
								filter = function(client)
									return client.name == "null-ls"
								end,
							})
						end,
					})
				end
			end,
		})
	end,
}
