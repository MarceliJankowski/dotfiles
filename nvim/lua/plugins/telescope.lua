return {
  "nvim-telescope/telescope.nvim", -- fuzzy finder
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim", -- collection of nvim lua functions
  },
  opts = {
    defaults = {
      layout_strategy = "horizontal",
      layout_config = {
        width = 0.92,
        height = 0.92,
        preview_width = function(_, columns)
          return math.floor(columns * 0.55) -- 55% of available columns / window width
        end,
      },
    },
    extensions = {},
  },
  config = function(_, opts)
    local telescope = require("telescope")
    local telescope_builtin = require("telescope.builtin")

    telescope.setup(opts)

    -- KEYMAPS
    vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files)
    vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep)
    vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers)
    vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags)

    -- show hidden files (except for '.git' directory), and hide blobs/trees from '.gitignore'
    vim.keymap.set(
      "n",
      "<leader>.",
      "<Cmd>lua require('telescope.builtin').find_files({ find_command = { 'rg', '--files', '--hidden', '-g', '!.git' } })<CR>"
    )
  end,
}
