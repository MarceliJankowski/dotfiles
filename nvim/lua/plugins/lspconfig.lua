return {
	"neovim/nvim-lspconfig", -- configs for neovim LSP client
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		--------------------------------------------------
		--                   DEFAULTS                   --
		--------------------------------------------------

		local lsp_defaults = {
			-- set capabilities for cmp
			capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
		}

		local lspconfig = require("lspconfig")

		-- extend default configuration so that I don't have to manually assign it to every LSP server
		lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, lsp_defaults)

		--------------------------------------------------
		--                   SERVERS                    --
		--------------------------------------------------

		lspconfig.vimls.setup({})
		lspconfig.tsserver.setup({})
		lspconfig.bashls.setup({})
		lspconfig.cssls.setup({})
		lspconfig.cssmodules_ls.setup({})
		lspconfig.dockerls.setup({})
		lspconfig.html.setup({})
		lspconfig.jsonls.setup({})
		lspconfig.marksman.setup({})
		lspconfig.sqlls.setup({})
		lspconfig.lemminx.setup({})
		lspconfig.yamlls.setup({})
		lspconfig.phpactor.setup({})
		lspconfig.clangd.setup({
			cmd = {
				"clangd",
				"--offset-encoding=utf-16",
			},
		})

		lspconfig.emmet_ls.setup({
			filetypes = {
				"css",
				"eruby",
				"html",
				"javascript",
				"javascriptreact",
				"less",
				"sass",
				"scss",
				"svelte",
				"pug",
				"typescriptreact",
				"vue",
				"php",
			},
		})

		lspconfig.lua_ls.setup({
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})

		--------------------------------------------------
		--                   SERVERS                    --
		--------------------------------------------------
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Enable completion triggered by <C-x><C-o>
				vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local map = vim.keymap.set
				local mappingOpts = { buffer = ev.buf, noremap = true, silent = true }
				map("n", "gD", vim.lsp.buf.declaration, mappingOpts)
				map("n", "gd", vim.lsp.buf.definition, mappingOpts)
				map("n", "gh", vim.lsp.buf.hover, mappingOpts)
				map("n", "gi", vim.lsp.buf.implementation, mappingOpts)
				map("n", "<leader>D", vim.lsp.buf.type_definition, mappingOpts)
				map("n", "<leader>a", vim.lsp.buf.code_action, mappingOpts)
				map("n", "<M-r>", vim.lsp.buf.rename, mappingOpts)

				-- show line diagnostics automatically in hover window
				-- wiki: https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
				vim.api.nvim_create_autocmd("CursorHold", {
					buffer = bufnr,
					callback = function()
						local diagnosticOpts = {
							focusable = false,
							close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
							-- border = "rounded",
							source = "always",
							prefix = " ",
							scope = "cursor",
						}
						vim.diagnostic.open_float(nil, diagnosticOpts)
					end,
				})
			end,
		})

		--------------------------------------------------
		--                   VISUALS                    --
		--------------------------------------------------

		-- change diagnostic symbols in the sign column (gutter)
		local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end

		-- customize how diagnostics are displayed
		vim.diagnostic.config({
			virtual_text = false,
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		--------------------------------------------------
		--   FIX RED HIGHLIGHTS IN HOVER DEFINITIONS    --
		--------------------------------------------------
		-- fixes symbols like '_' being highlighted in red

		local fixRedHighlightsInHoverDefinitionsGroup =
			vim.api.nvim_create_augroup("fixRedHighlightsInHoverDefinitions", { clear = true })

		vim.api.nvim_create_autocmd("FileType", {
			group = fixRedHighlightsInHoverDefinitionsGroup,
			pattern = "*",
			callback = function()
				if vim.bo.filetype ~= "markdown" then
					vim.cmd("highlight link markdownError NONE")
				end
			end,
			desc = "fix red highlights in hover definitions by disabling markdownError highlighting (doesn't affect markdown filetype)",
		})
	end,
}
