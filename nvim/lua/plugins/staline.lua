return {
  "tamton-aquib/staline.nvim",
  opts = {
    mode_icons = {
      n = "NORMAL",
      i = "INSERT",
      v = "VISUAL",
      V = "V-LINE",
      ["\22"] = "V-BLOCK",
      s = "SELECT",
      S = "S-LINE",
      ["\19"] = "S-BLOCK",
      c = "COMMAND",
      R = "REPLACE",
      t = "TERMINAL",
    },
    sections = {
      left = {
        "-mode",
        "left_sep",
        function()
          return " " .. vim.fn.expand("%")
        end,
      },
      mid = {},
      right = {
        "branch",
        "right_sep",
        "-cwd",
      },
    },
    defaults = {
      bg = "none",
      true_colors = true,
      branch_symbol = " ",
      line_column = "%l:%c",
      left_separator = "",
      right_separator = "",
    },
    mode_colors = {
      n = "#83acff",
      i = "#c4e98e",
      v = "#c893eb",
      V = "#c893eb",
      ["\22"] = "#c893eb",
      s = "#c893eb",
      S = "#c893eb",
      ["\19"] = "#c893eb",
      R = "#f07279",
      c = "#ffcb6b",
    },
  },
}
