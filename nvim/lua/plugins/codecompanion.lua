return {
  "olimorris/codecompanion.nvim",
  dependencies = { "echasnovski/mini.diff" },
  opts = {
    strategies = {
      chat = {
        adapter = "copilot",
      },
      inline = {
        adapter = "copilot",
      },
    },
  },
  keys = {
    { "<M-a>", "<cmd>CodeCompanionChat Toggle<CR>" },
  },
}
