return {
  "WhoIsSethDaniel/mason-tool-installer.nvim", -- automatic third party tooling installation (through mason)
  dependencies = { "williamboman/mason.nvim" },
  opts = {
    ensure_installed = {
      -- language servers
      "clangd",
      "css-lsp",
      "cssmodules-language-server",
      "dockerfile-language-server",
      "emmet-ls",
      "eslint-lsp",
      "html-lsp",
      "json-lsp",
      "lemminx",
      "lua-language-server",
      "marksman",
      "phpactor",
      "pyright",
      "sqlls",
      "typescript-language-server",
      "vim-language-server",
      "yaml-language-server",
      "ruff",
      "bash-language-server",

      -- miscellaneous
      "stylua",
      "prettierd",
      "shfmt",
      "latexindent",
      "phpstan",
      -- "clang-format", -- use binary from PATH to ensure formatting consistency across nvim and other tooling
    },
  },
}
