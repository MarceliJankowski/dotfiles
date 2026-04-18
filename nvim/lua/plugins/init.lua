-- plugins with no/minimal config required
return {

  --------------------------------------------------
  --                  UTILITIES                   --
  --------------------------------------------------

  "ntpeters/vim-better-whitespace", -- highlights trailing whitespace

  "kevinhwang91/nvim-bqf", -- better quickfix window

  "kshenoy/vim-signature", -- displays and manages marks

  --------------------------------------------------
  --                    VISUAL                    --
  --------------------------------------------------

  {
    "nvim-tree/nvim-web-devicons", -- adds icons for plugins to use (requires Nerd Font)
    lazy = true,
  },

  --------------------------------------------------
  --                MOTION RELATED                --
  --------------------------------------------------

  "wellle/targets.vim", -- adds various text objects

  "tpope/vim-surround", -- keymaps to easily delete, change and add surroundings

  --------------------------------------------------
  --                   GIT                        --
  --------------------------------------------------

  {
    "lewis6991/gitsigns.nvim", -- git decorations (gutter ones)
    config = true, -- runs require("gitsigns").setup()
  },

  {
    "tpope/vim-fugitive", -- gateway to git
    cmd = { "Git", "G" },
  },
}
