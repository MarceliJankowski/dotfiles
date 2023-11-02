return {
	"WhoIsSethDaniel/mason-tool-installer.nvim", -- installs (through mason) specified third party tools automatically

	ensure_installed = {
		-- formatters
		"stylua",
		"prettierd",
		"shfmt",
		"phpcsfixer",
		"clang_format",
		"latexindent",

		-- linters
		"phpstan",
	},
}
