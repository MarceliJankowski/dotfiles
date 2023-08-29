vim.g.material_terminal_italics = 0 -- disable italics
vim.g.material_theme_style = "ocean"

vim.cmd("colorscheme material")
vim.cmd("highlight Normal guibg=NONE ctermbg=NONE") -- transparent background

-- set rainbow-delimiters colors (for some reason this code needed to run after 'colorscheme material')
vim.cmd("highlight RainbowDelimiterGold guifg=#f8b46c")
vim.cmd("highlight RainbowDelimiterPink guifg=#fb78b5")
vim.cmd("highlight RainbowDelimiterPurple guifg=#b98bf5")
vim.cmd("highlight RainbowDelimiterBlue guifg=#4aacfb")
vim.cmd("highlight RainbowDelimiterCyan guifg=#18eece")
vim.cmd("highlight RainbowDelimiterGray guifg=#dad8d8")
