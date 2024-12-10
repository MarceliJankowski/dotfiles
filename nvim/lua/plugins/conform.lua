local function get_js_ts_formatter()
  local cwd = vim.fn.getcwd()

  -- this project uses eslint formatter
  if cwd:match("/home/%w+/adtran/distra%-sense/?%w*") ~= nil then
    return { "eslint_lsp" }
  else
    return { "prettierd" }
  end
end

return {
  "stevearc/conform.nvim", -- lightweight yet powerful formatter plugin
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_format" },
      javascript = get_js_ts_formatter,
      typescript = get_js_ts_formatter,
      javascriptreact = get_js_ts_formatter,
      typescriptreact = get_js_ts_formatter,
      css = { "prettierd" },
      scss = { "prettierd" },
      html = { "prettierd" },
      json = { "prettierd" },
      yaml = { "prettierd" },
      markdown = { "prettierd" },
      sh = { "shfmt" },
      php = { "php_cs_fixer" },
      c = { "clang_format" },
      cpp = { "clang_format" },
      cs = { "clang_format" },
      tex = { "latexindent" },
    },
    formatters = {
      clang_format = {
        command = "clang-format",
        prepend_args = { "--style=file", "--fallback-style=chromium" },
      },
      eslint_lsp = {
        command = "EslintFixAll",
      },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true, -- fallback to formatting with LSP if the formatter is not available
    },
  },
}
