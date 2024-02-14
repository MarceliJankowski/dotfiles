return {
	"WhoIsSethDaniel/mason-tool-installer.nvim", -- installs (through mason) specified third party tools automatically
	dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
	opts = {
		ensure_installed = {
			-- formatters
			"stylua",
			"prettierd",
			"shfmt",
			"php-cs-fixer",
			"clang-format",
			"latexindent",

			-- linters
			"phpstan",
		},
	},
}
