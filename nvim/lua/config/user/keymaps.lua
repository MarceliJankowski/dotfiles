--------------------------------------------------
--                    MODES                     --
--------------------------------------------------
-- normal: "n"
-- insert: "i"
-- visual: "v"
-- visual-block: "x"
-- command: "c"

--------------------------------------------------
--               LOCAL VARIABLES                --
--------------------------------------------------

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

--------------------------------------------------
--                   DISABLE                    --
--------------------------------------------------
-- most of these are disabled cause I typed them on accident...

-- performs keyword lookup
map("n", "K", "<Nop>", opts)

-- shell shortcut for suspending current process
map({ "n", "i", "v" }, "<C-z>", "<Nop>", opts)

-- prevent leader key from moving my cursor
map("n", vim.g.mapleader, "<Nop>", opts)

-- works like 'Enter' key
map("i", "<C-j>", "<Nop>", opts)

-- joins current line with the next one
map("n", "J", "<Nop>", opts)

-- this one's used in the 'RUN/EVAL' section
map("n", "<leader>r", "<Nop>", opts)

--------------------------------------------------
--                   RUN/EVAL                   --
--------------------------------------------------

-- evaluate current buffer with node
map("n", "<leader>rj", "<Cmd>write | !node %<CR>", opts)

-- evaluate current buffer with shell
map("n", "<leader>rs", "<Cmd>write | !./%<CR>", opts)

-- source current buffer
map("n", "<leader>rv", "<Cmd>source %<CR>", opts)

-- run make
map("n", "<leader>rm", "<Cmd>make<CR>", opts)

--------------------------------------------------
--                BUFFER RELATED                --
--------------------------------------------------

-- quit current buffer
map("n", "<C-q>", "<Cmd>q<CR>", opts)

-- forcefully quit current buffer (disregard unsaved changes)
map("n", "QQ", "<Cmd>q!<CR>", opts)

-- write to current buffer
map({ "n", "i", "x", "v" }, "<C-s>", "<Cmd>write<CR>", opts)

-- write to current buffer and delete every other unmodified buffer
map("n", "<leader>bo", "<Cmd>write | %bd | edit # | bd #<CR>", opts) -- '%bd' deletes all buffers

-- write to current buffer and edit new unnamed buffer
map({ "n", "i" }, "<C-t>", "<Cmd>write | enew<CR>", opts)

-- go to newer cursor position in jump list ('TAB' and 'CTRL-I' both correspond to the same keycode)
map("n", "<C-n>", "<C-i>", opts)

-- go to the next buffer
map("n", "<Tab>", "<Cmd>bnext<CR>", opts)

-- go to the previous buffer
map("n", "<S-Tab>", "<Cmd>bprevious<CR>", opts)

-- forcefully delete current buffer if it's unnamed
map("n", "<leader>w", function()
	local bufferName = vim.api.nvim_buf_get_name(0)

	if bufferName == "" then
		vim.cmd("bd!")
	else
		print("buffer: '" .. bufferName .. "' has a name!")
	end
end, opts)

--------------------------------------------------
--                 PANE RELATED                 --
--------------------------------------------------

-- open new horizontal split
map("n", "<leader>h", "<Cmd>split<CR>", opts)

-- open new vertical split
map("n", "<leader>v", "<Cmd>vsplit<CR>", opts)

-- resize panes / size them evenly (each one of them will take up 1 fraction of available space)
map("n", "<leader>=", "<C-w>=", opts)

-- close all panes except the current one
map("n", "<leader>o", "<Cmd>only<CR>", opts)

-- resize panes
map("n", "<M-j>", "<Cmd>resize -5<CR>", opts)
map("n", "<M-k>", "<Cmd>resize +5<CR>", opts)
map("n", "<M-h>", "<Cmd>vertical resize -5<CR>", opts)
map("n", "<M-l>", "<Cmd>vertical resize +5<CR>", opts)

-- swap panes
map("n", "<leader>[", "<C-w>H", opts)
map("n", "<leader>]", "<C-w>L", opts)
map("n", "<leader>{", "<C-w>K", opts)
map("n", "<leader>}", "<C-w>J", opts)

-- move between panes
map({ "n", "v" }, "<c-h>", "<c-w>h", opts)
map({ "n", "v" }, "<c-l>", "<c-w>l", opts)
map({ "n", "v" }, "<c-k>", "<c-w>k", opts)
map({ "n", "v" }, "<c-j>", "<c-w>j", opts)

--------------------------------------------------
--          QUICKFIX LIST IMPROVEMENTS          --
--------------------------------------------------

-- open quickfix window
map("n", "<M-q>", "<Cmd>copen<CR>")

-- close quickfix window
map("n", "<M-Q>", "<Cmd>cclose<CR>")

-- move through quickfix entries
map("n", "<M-n>", "<cmd>cnext<CR>zz")
map("n", "<M-N>", "<cmd>cprev<CR>zz")

--------------------------------------------------
--                 COMMAND LINE                 --
--------------------------------------------------

-- shrink command line to 1 unit of height (line), and increase current window's size by 100
map("n", "<leader>d", "<Cmd>set cmdheight=1 | resize +100<CR>", opts)

-- clear command line
map("n", "<leader>c", "<Cmd>echo ''<CR>", opts)

--------------------------------------------------
--           VISUAL MODE IMPROVEMENTS           --
--------------------------------------------------

-- shift selected text
map({ "v", "x" }, "<Tab>", ">gv", opts)
map({ "v", "x" }, "<S-Tab>", "<gv", opts)

-- I typed these accidentally...
map({ "v", "x" }, "K", "k", opts)
map({ "v", "x" }, "J", "j", opts)

--------------------------------------------------
--           INSERT MODE IMPROVEMENTS           --
--------------------------------------------------

-- delete preceding word
map("i", "<C-BS>", "<C-w>", opts)
map("i", "<C-h>", "<C-w>", opts) -- TMUX registers <C-BS> as <C-h>

-- shift tab
map("i", "<S-Tab>", "<C-d>", opts)

--------------------------------------------------
--           NORMAL MODE IMPROVEMENTS           --
--------------------------------------------------

-- center the screen and open just enough folds to make the cursor visible
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- center the screen
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

-- move to the end of the word
map("n", "gUiw", "gUiwe", opts)
map("n", "guiw", "guiwe", opts)

-- behave like other capital commands
map("n", "Y", "y$", opts)

--------------------------------------------------
--               OTHER SHORTCUTS                --
--------------------------------------------------

-- quickly edit 'nvim/init.lua'
map("n", "<leader>i", "<Cmd>edit ${DOTFILES}/nvim/init.lua<CR>", opts)

-- open netrw
map("n", "<leader>n", "<Cmd>Explore<CR>", opts)
