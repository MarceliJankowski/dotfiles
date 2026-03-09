return {
  "NvChad/nvim-colorizer.lua", -- awesome colorizer
  init = function()
    vim.opt.termguicolors = true
  end,
  opts = {
    filetypes = {
      "*", -- highlight all filetypes
      "!netrw", -- exclude netrw
    },
  },
}
