return {
  "WhoIsSethDaniel/mason-tool-installer.nvim", -- installs (through mason) specified third party tools automatically
  dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
  opts = {
    ensure_installed = {
      -- "clang-format", -- use binary from PATH to ensure formatting consistency across nvim and other tooling
      "stylua",
      "prettierd",
      "shfmt",
      "php-cs-fixer",
      "latexindent",
      "phpstan",
      "ruff",
    },
  },
}
