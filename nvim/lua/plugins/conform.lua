return {
	"stevearc/conform.nvim", -- lightweight yet powerful formatter plugin
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescriptreact = { "prettierd" },
			css = { "prettierd" },
			scss = { "prettierd" },
			html = { "prettierd" },
			json = { "prettierd" },
			yaml = { "prettierd" },
			markdown = { "prettierd" },
			sh = { "shfmt" },
			php = { "phpcsfixer" },
			c = { "clang_format" },
			cpp = { "clang_format" },
			cs = { "clang_format" },
			tex = { "latexindent" },
		},

		formatters = {
			clang_format = {
				command = "clang-format",
				args = { "--style=file", "--fallback-style=chromium" },
			},
		},

		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true, -- fallback to formatting with LSP if the formatter is not available
		},
	},
}
