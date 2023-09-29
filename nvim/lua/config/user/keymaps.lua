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

-- disable 'K' (keyword lookup)
map("n", "K", "<Nop>", opts)

-- disable '<C-z>' (shell shortcut for suspending current process)
map({ "n", "i", "v" }, "<C-z>", "<Nop>", opts)

-- disable '<space>' (it's my leader key, hence I don't want it to move my cursor)
map("n", "<space>", "<Nop>", opts)

-- disable '<leader>x' (I'm using it to execute buffers)
map("n", "<leader>x", "<Nop>", opts)

-- disable '<C-j>' (I was typing it by accident)
map("i", "<C-j>", "<Nop>", opts)

-- disable 'J' (joins current line with the next one)
map("n", "J", "<Nop>", opts)

--------------------------------------------------
--                   EXECUTE                    --
--------------------------------------------------

-- execute currently open buffer with node
map("n", "<leader>xj", "<Cmd>write | !node %<CR>", opts)

-- execute currently open buffer with shell
map("n", "<leader>xs", "<Cmd>write | !%<CR>", opts)

-- execute/source currently open buffer with vim
map("n", "<leader>xv", "<Cmd>source %<CR>", opts)

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

-- delete word with <C-BS> (my terminal emulator registers <C-BS> as <C-h>)
map("i", "<C-h>", "<C-w>", opts)

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
