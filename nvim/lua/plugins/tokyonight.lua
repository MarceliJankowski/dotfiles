return {
  "folke/tokyonight.nvim", -- color scheme
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
    on_colors = function(colors)
      colors.bg = "#000000"
      colors.bg_dark = "#000000"
      colors.bg_float = "#000000"
    end,
    on_highlights = function(hl)
      hl.CursorLine = {
        bg = "#0d0d0d",
      }
      hl.Cursor = {
        fg = "#000000",
        bg = "#ffcb6b",
      }
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd("colorscheme tokyonight-night")
  end,
}
