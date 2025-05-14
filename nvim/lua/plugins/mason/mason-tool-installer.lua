return {
  "WhoIsSethDaniel/mason-tool-installer.nvim", -- automatic third party tooling installation (through mason)
  dependencies = { "williamboman/mason.nvim" },
  opts = {
    ensure_installed = {
      -- formatters
      "stylua",
      "shfmt",
      "prettierd",
      "latexindent",
      -- "clang-format", -- use binary from PATH to ensure formatting consistency across nvim and other tooling

      -- linters
      "phpstan",

      -- language servers
      "vim-language-server",
      "typescript-language-server",
      "bash-language-server",
      "css-lsp",
      "cssmodules-language-server",
      "dockerfile-language-server",
      "html-lsp",
      "json-lsp",
      "marksman",
      "sqlls",
      "lemminx",
      "yaml-language-server",
      "phpactor",
      "clangd",
      "pyright",
      "eslint-lsp",
      "emmet-ls",
      "ruff",
      "lua-language-server",
    },
  },
}
