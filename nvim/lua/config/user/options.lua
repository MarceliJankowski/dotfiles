--------------------------------------------------
--                   OPTIONS                    --
--------------------------------------------------

vim.opt.number = true -- display line numbers
vim.opt.relativenumber = true -- display relative (to the cursor) line numbers
vim.opt.mouse = "a" -- enable mouse support in every mode
vim.opt.ignorecase = true -- ignore character case when searching
vim.opt.smartcase = true -- ignore uppercase letters (unless the search term has an uppercase letter)
vim.opt.hlsearch = false -- don't highlight results of the previous match
vim.opt.clipboard = "unnamedplus" -- enable copying from and into system clipboard without explicitely interacting with '+' and/or '*' registers
vim.opt.hidden = true -- keep unsaved buffers in the background
vim.opt.background = "dark" -- tell vim whether background is dark or light (used by plugins to set their color schemes)
vim.opt.wrap = true -- wrap overflowing lines so that they're always visible
vim.opt.breakindent = true -- start every wrapped line with the same indentation
vim.opt.tabstop = 2 -- tab width in spaces
vim.opt.expandtab = true -- convert tabs into spaces
vim.opt.shiftwidth = 2 -- number of spaces used for indentation (impacts "shift" commands, like: '<<' or '>>')
vim.opt.pumheight = 10 -- maximum number of items to show in the popup menu
vim.opt.cmdheight = 1 -- number of lines that command-line should occupy
vim.opt.ruler = true -- show the line and column number of the cursor position
vim.opt.splitbelow = true -- horizontal splits are placed below the current pane
vim.opt.splitright = true -- vertical splits are placed on the right side of current pane
vim.opt.showtabline = 2 -- always display tabline
vim.opt.smarttab = true -- make tabbing smarter...
vim.opt.smartindent = true -- do smart autoindenting when starting a new line
vim.opt.autoindent = true -- copy indent from current line when starting a new line
vim.opt.termguicolors = true -- enables 24-bit RGB colors in the TUI
vim.opt.errorbells = false -- don't ring the bell (beep or screen flash) for error messages
vim.opt.cursorline = true -- highlight current line (the one with cursor on it) with CursorLine
vim.opt.showmode = false -- disable mode indicators (like: '-- INSERT --')
vim.opt.swapfile = false -- don't create swap files
vim.opt.incsearch = true -- show where the pattern matches, while typing a search command
vim.opt.conceallevel = 0 -- display normally text with 'conceal' syntax attribute
vim.opt.signcolumn = "yes:2" -- always display signcolumn/gutter, and set how much space/columns it should occupy
vim.opt.scrolloff = 5 -- minimal number of lines to keep above and below the cursor
vim.opt.fileencoding = "UTF-8" -- character encoding for current buffer
vim.opt.laststatus = 3 -- keep single, global statusline when multiple panes are open
vim.opt.updatetime = 10 -- write swap file after X miliseconds without typing (commonly used by plugins for setting refresh rate)
vim.opt.shortmess:append("c") -- don't pass messages to ins-completion-menu (required by some plugins)
vim.opt.timeoutlen = 400 -- time in milliseconds vim will wait for a mapped sequence to complete
vim.opt.backup = false -- don't create file backups
vim.opt.writebackup = false -- don't create backups whenever file is about to get overwritten

-- enable cursor blinking (kinda finicky in TMUX), and change cursor apperance in INSERT mode to thin beam ('|')
vim.opt.guicursor =
	"n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
