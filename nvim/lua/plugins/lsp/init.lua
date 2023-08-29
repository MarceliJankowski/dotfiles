local lspconfig = require("plugins/lsp/lspconfig")
local mason = require("plugins/lsp/mason")
local mason_lspconfig = require("plugins/lsp/mason-lspconfig")
local null_ls = require("plugins/lsp/null-ls")

return {
	null_ls,
	mason,
	mason_lspconfig,

	-- after setting up mason-lspconfig you may set up servers via lspconfig
	lspconfig,
}
