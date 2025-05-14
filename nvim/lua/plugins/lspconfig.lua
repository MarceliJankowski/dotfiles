return {
  "neovim/nvim-lspconfig", -- collection of default neovim LSP client configs
  lazy = false,
  config = function()
    local lspconfig = require("lspconfig")

    --------------------------------------------------
    --            SERVER CONFIG DEFAULTS            --
    --------------------------------------------------

    lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, {
      capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    })

    --------------------------------------------------
    --                SERVER CONFIGS                --
    --------------------------------------------------

    lspconfig.vimls.setup({})
    lspconfig.ts_ls.setup({})
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
    lspconfig.clangd.setup({})
    lspconfig.pyright.setup({})
    lspconfig.eslint.setup({})
    lspconfig.emmet_ls.setup({})
    lspconfig.ruff.setup({})

    lspconfig.lua_ls.setup({
      root_dir = lspconfig.util.root_pattern(".git"),
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if
            path ~= vim.fn.stdpath("config")
            and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
          then
            return
          end
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
          runtime = {
            version = "LuaJIT",
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
            },
          },
        })
      end,
      settings = {
        Lua = {},
      },
    })

    --------------------------------------------------
    --                AUTO COMMANDS                 --
    --------------------------------------------------

    -- set keymaps for buffers with attached LSP
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local keymap_opts = { buffer = ev.buf, noremap = true, silent = true }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, keymap_opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)
        vim.keymap.set("n", "gh", vim.lsp.buf.hover, keymap_opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, keymap_opts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, keymap_opts)
        vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, keymap_opts)
        vim.keymap.set("n", "<M-r>", vim.lsp.buf.rename, keymap_opts)
      end,
    })

    -- display line diagnostics upon cursor hover
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = vim.api.nvim_create_augroup("floatDiagnosticCursor", { clear = true }),
      callback = function()
        vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
      end,
    })

    --------------------------------------------------
    --                MISCELLANEOUS                 --
    --------------------------------------------------
    -- wiki: https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization

    vim.diagnostic.config({
      virtual_text = false,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.HINT] = "",
          [vim.diagnostic.severity.INFO] = "",
        },
      },
    })
  end,
}
