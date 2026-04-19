--------------------------------------------------
--               MODULE VARIABLES               --
--------------------------------------------------

local map = vim.keymap.set
local opts = { noremap = true, silent = true, buffer = true }
local opts_recursive = { remap = true, silent = true, buffer = true }

--------------------------------------------------
--       GLOBAL VARIABLES / NETRW OPTIONS       --
--------------------------------------------------

vim.g.netrw_liststyle = 0 -- use thin listing style (one file per line)
vim.g.netrw_fastbrowse = 0 -- slow browsing makes netrw consistent, as now it always closes itself after I open a file with it (previously that wasn't the case)
vim.g.netrw_banner = 0 -- disable netrw banner
vim.g.netrw_keepdir = 0 -- keep the current directory the same as the browsing directory
vim.g.netrw_bufsettings = "nomodifiable nomodified nobuflisted nowrap readonly number relativenumber" -- options for netrw buffer
vim.g.netrw_hide = 1 -- enable node hiding
vim.g.netrw_list_hide = "^\\./$" -- hide './' node (comma seperated list of Regular Expressions)

--------------------------------------------------
--                  FUNCTIONS                   --
--------------------------------------------------

local function get_cursor_position()
  local cursor_position = vim.api.nvim_win_get_cursor(0)
  local line = cursor_position[1]
  local column = cursor_position[2] + 1 -- add 1 to account for the fact that nvim_win_get_cursor() counts columns starting from 0, while vim's cursor() starts from 1

  local parsed_cursor_position = line .. "," .. column -- parsed to vim's cursor() format
  return parsed_cursor_position
end

local function apply_netrw_mappings()
  -- quit netrw
  map("n", "q", "<Cmd>bdelete<CR>", opts)
  map("n", "<C-q>", "<Cmd>bdelete<CR>", opts)
  map("n", "<leader>n", "<Cmd>bdelete<CR>", opts)

  -- navigate between panes
  map("n", "<C-l>", "<Cmd>wincmd l<CR>", opts)
  map("n", "<C-h>", "<Cmd>wincmd h<CR>", opts)
  map("n", "<C-j>", "<Cmd>wincmd j<CR>", opts)
  map("n", "<C-k>", "<Cmd>wincmd k<CR>", opts)

  -- display detailed info about currently viewed node
  map("n", "gh", "qf", opts_recursive)

  -- delete currently viewed file and buffer of said file (if exists)
  map("n", "D", "yy<del>:silent! bd <C-r>0<CR>", opts_recursive)

  -- create new file, come back to netrw, restore previous cursor position, delete new file's buffer (essentially create new file without editing it)
  map("n", "a", function()
    local cursor_position = get_cursor_position()

    vim.cmd("normal %") -- prompts user to create new file

    -- check if new file was created (and automatically opened) or user aborted (pressed 'ESC')
    if vim.bo.filetype ~= "netrw" then
      local created_file = vim.fn.getreg("%")

      vim.cmd("write | Explore | call cursor(" .. cursor_position .. ") | bd " .. created_file)
    else
      print("file creation aborted")

      -- restore cursor position (sometimes after aborting cursor moves to seemingly random line)
      vim.cmd("call cursor(" .. cursor_position .. ")")
    end
  end, opts_recursive)

  -- create new file and edit it
  map("n", "A", "%<Cmd>write<CR>", opts_recursive)

  -- disable 's' (it was driving me nuts)
  map("n", "s", "<Nop>", opts)

  -- go up one directory
  map("n", "u", "-", opts_recursive)

  -- rename currently viewed file and close buffer of said file (if exists)
  map("n", "r", "yyR:silent! bd <C-r>0<CR>", opts_recursive)

  -- open currently viewed node, come back to netrw, restore cursor position (essentially open a file without editing it)
  map("n", "i", function()
    local cursor_position = get_cursor_position()
    vim.cmd("normal \r") -- '\r' === <CR>
    vim.cmd("Explore | call cursor(" .. cursor_position .. ")")
  end, opts_recursive)
end

--------------------------------------------------
--                AUTO COMMANDS                 --
--------------------------------------------------

vim.api.nvim_create_autocmd("FileType", {
  desc = "apply netrw mappings",
  group = vim.api.nvim_create_augroup("applyNetrwMappings", { clear = true }),
  pattern = "netrw",
  callback = apply_netrw_mappings,
})
