return {
  "williamboman/mason.nvim", -- interface for managing external editor tooling (LSP, linters, formatters, etc.)
  opts = {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  },
}
