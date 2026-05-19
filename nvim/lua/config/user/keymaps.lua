--------------------------------------------------
--                    MODES                     --
--------------------------------------------------
-- normal: "n"
-- insert: "i"
-- visual: "v"
-- visual-block: "x"
-- command: "c"

--------------------------------------------------
--                   DISABLE                    --
--------------------------------------------------
-- most of these are disabled cause I typed them on accident...

-- performs keyword lookup
vim.keymap.set("n", "K", "<Nop>")

-- shell shortcut for suspending current process
vim.keymap.set({ "n", "i", "v" }, "<C-z>", "<Nop>")

-- prevent leader key from moving my cursor
vim.keymap.set("n", vim.g.mapleader, "<Nop>")

-- works like 'Enter' key
vim.keymap.set("i", "<C-j>", "<Nop>")

-- joins current line with the next one
vim.keymap.set("n", "J", "<Nop>")

-- these ones introduce delay to <C-w> (close current buffer) keymap
vim.api.nvim_del_keymap("n", "<C-w>d")
vim.api.nvim_del_keymap("n", "<C-w><C-d>")

--------------------------------------------------
--                BUFFER RELATED                --
--------------------------------------------------

-- delete current buffer
vim.keymap.set("n", "<C-w>", "<Cmd>bdelete<CR>")

-- forcefully quit current buffer (disregard unsaved changes)
vim.keymap.set("n", "QQ", "<Cmd>q!<CR>")

-- write to current buffer
vim.keymap.set({ "n", "i", "x", "v" }, "<C-s>", "<Cmd>write<CR>")

-- write to current buffer and delete every other unmodified buffer
vim.keymap.set("n", "<leader>bo", "<Cmd>write | %bd | edit # | bd #<CR>") -- '%bd' deletes all buffers

-- write to current buffer and edit new unnamed buffer
vim.keymap.set({ "n", "i" }, "<C-t>", "<Cmd>write | enew<CR>")

-- go to newer cursor position in jump list ('TAB' and 'CTRL-I' both correspond to the same keycode)
vim.keymap.set("n", "<C-n>", "<C-i>")

-- go to the next buffer
vim.keymap.set("n", "<Tab>", "<Cmd>bnext<CR>")

-- go to the previous buffer
vim.keymap.set("n", "<S-Tab>", "<Cmd>bprevious<CR>")

-- forcefully delete current buffer if it's unnamed
vim.keymap.set("n", "<leader>w", function()
  local buffer_name = vim.api.nvim_buf_get_name(0)

  if buffer_name == "" then
    vim.cmd("bd!")
  else
    print("buffer: '" .. buffer_name .. "' has a name!")
  end
end)

--------------------------------------------------
--                WINDOW RELATED                --
--------------------------------------------------

-- quit current window
vim.keymap.set("n", "<C-q>", "<Cmd>quit<CR>")

-- open new horizontal split
vim.keymap.set("n", "<leader>h", "<Cmd>split<CR>")

-- open new vertical split
vim.keymap.set("n", "<leader>v", "<Cmd>vsplit<CR>")

-- resize windows / size them evenly (each one of them will take up 1 fraction of available space)
vim.keymap.set("n", "<leader>=", "<C-w>=")

-- close all windows except the current one
vim.keymap.set("n", "<leader>o", "<Cmd>only<CR>")

-- resize windows
vim.keymap.set("n", "<M-j>", "<Cmd>resize -5<CR>")
vim.keymap.set("n", "<M-k>", "<Cmd>resize +5<CR>")
vim.keymap.set("n", "<M-h>", "<Cmd>vertical resize -5<CR>")
vim.keymap.set("n", "<M-l>", "<Cmd>vertical resize +5<CR>")

-- swap windows
vim.keymap.set("n", "<leader>[", "<C-w>H")
vim.keymap.set("n", "<leader>]", "<C-w>L")
vim.keymap.set("n", "<leader>{", "<C-w>K")
vim.keymap.set("n", "<leader>}", "<C-w>J")

-- move between windows
vim.keymap.set({ "n", "v" }, "<c-h>", "<c-w>h")
vim.keymap.set({ "n", "v" }, "<c-l>", "<c-w>l")
vim.keymap.set({ "n", "v" }, "<c-k>", "<c-w>k")
vim.keymap.set({ "n", "v" }, "<c-j>", "<c-w>j")

--------------------------------------------------
--          QUICKFIX LIST IMPROVEMENTS          --
--------------------------------------------------

-- open quickfix window
vim.keymap.set("n", "<M-q>", "<Cmd>copen<CR>")

-- close quickfix window
vim.keymap.set("n", "<M-Q>", "<Cmd>cclose<CR>")

-- move through quickfix entries
vim.keymap.set("n", "<M-n>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<M-N>", "<cmd>cprev<CR>zz")

--------------------------------------------------
--                 COMMAND LINE                 --
--------------------------------------------------

-- shrink command line to 1 unit of height (line), and increase current window's size by 100
vim.keymap.set("n", "<leader>d", "<Cmd>set cmdheight=1 | resize +100<CR>")

-- clear command line
vim.keymap.set("n", "<leader>c", "<Cmd>echo ''<CR>")

--------------------------------------------------
--           VISUAL MODE IMPROVEMENTS           --
--------------------------------------------------

-- shift selected text
vim.keymap.set({ "v", "x" }, "<Tab>", ">gv")
vim.keymap.set({ "v", "x" }, "<S-Tab>", "<gv")

-- I typed these accidentally...
vim.keymap.set({ "v", "x" }, "K", "k")
vim.keymap.set({ "v", "x" }, "J", "j")

-- comment/uncomment
vim.keymap.set({ "v", "x" }, "<leader>/", "gc", { remap = true })

--------------------------------------------------
--           INSERT MODE IMPROVEMENTS           --
--------------------------------------------------

-- delete preceding word
vim.keymap.set("i", "<C-BS>", "<C-w>")
vim.keymap.set("i", "<C-h>", "<C-w>") -- TMUX registers <C-BS> as <C-h>

-- shift tab
vim.keymap.set("i", "<S-Tab>", "<C-d>")

--------------------------------------------------
--           NORMAL MODE IMPROVEMENTS           --
--------------------------------------------------

-- center the screen and open just enough folds to make the cursor visible
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- center the screen
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- move to the end of the word
vim.keymap.set("n", "gUiw", "gUiwe")
vim.keymap.set("n", "guiw", "guiwe")

-- behave like other capital commands
vim.keymap.set("n", "Y", "y$")

-- comment/uncomment
vim.keymap.set("n", "<leader>/", "gcc", { remap = true })

--------------------------------------------------
--               OTHER SHORTCUTS                --
--------------------------------------------------

-- quickly edit 'nvim/init.lua'
vim.keymap.set("n", "<leader>i", "<Cmd>edit ${DOTFILES}/nvim/init.lua<CR>")

-- open netrw file explorer
vim.keymap.set("n", "<leader>e", "<Cmd>Explore<CR>")

-- open notes
vim.keymap.set("n", "<leader>n", "<Cmd>edit ${NOTES}<CR>")
