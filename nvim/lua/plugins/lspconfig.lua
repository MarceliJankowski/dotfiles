return {
  "neovim/nvim-lspconfig", -- collection of default neovim LSP client configs
  lazy = false,
  config = function()
    --------------------------------------------------
    --                SERVER CONFIGS                --
    --------------------------------------------------

    local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
    local default_config_servers = {
      "vimls",
      "ts_ls",
      "bashls",
      "cssls",
      "cssmodules_ls",
      "dockerls",
      "html",
      "jsonls",
      "marksman",
      "sqlls",
      "lemminx",
      "yamlls",
      "phpactor",
      "clangd",
      "pyright",
      "eslint",
      "emmet_ls",
      "ruff",
    }

    for _, name in ipairs(default_config_servers) do
      vim.lsp.config(name, { capabilities = capabilities })
      vim.lsp.enable(name)
    end

    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME },
          },
        },
      },
    })
    vim.lsp.enable("lua_ls")

    --------------------------------------------------
    --                AUTO COMMANDS                 --
    --------------------------------------------------

    -- set keymaps for buffers with attached LSP
    local lsp_keymaps_group = vim.api.nvim_create_augroup("LspKeymaps", {})
    vim.api.nvim_create_autocmd("LspAttach", {
      group = lsp_keymaps_group,
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
    local lsp_hover_diagnostics_group = vim.api.nvim_create_augroup("LspHoverDiagnostics", { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = lsp_hover_diagnostics_group,
      callback = function()
        vim.diagnostic.open_float(nil, {
          focusable = false,
          scope = "cursor",
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          source = "always",
        })
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
