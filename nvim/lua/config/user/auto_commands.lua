--------------------------------------------------
--               MODULE VARIABLES               --
--------------------------------------------------

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local opts = { clear = true }

--------------------------------------------------
--                REMEMBER FOLDS                --
--------------------------------------------------
-- 'pattern' field uses shell globs, not RegExpr ('?*' makes sure that buffer has a name)

do
  local remember_folds_group = augroup("rememberFolds", opts)

  autocmd("BufWinLeave", {
    desc = 'create a "snapshot" of current buffer (saves folds)',
    group = remember_folds_group,
    pattern = "?*",
    command = "mkview",
  })

  autocmd("BufWinEnter", {
    desc = 'load (if available) "snapshot" of the current buffer (restores folds)',
    group = remember_folds_group,
    pattern = "?*",
    command = "silent! loadview",
  })
end

--------------------------------------------------
--           PERMAMENTLY DELETE MARKS           --
--------------------------------------------------

autocmd("BufWritePre", {
  desc = "write to ShaDa file (deletes marks permamently)",
  group = augroup("deleteMarksPermamently", opts),
  command = "wshada!",
})

--------------------------------------------------
--            HIGHLIGHT YANKED TEXT             --
--------------------------------------------------

autocmd("TextYankPost", {
  desc = "highlight yanked text",
  group = augroup("highlightYankedText", opts),
  command = 'silent! lua vim.highlight.on_yank({ higroup="IncSearch", timeout=350 })',
})

--------------------------------------------------
--      STOP NEWLINE COMMENT CONTINUATION       --
--------------------------------------------------
-- 'formatoptions' setting gets overwritten by 'ftplugin' (internal vim plugin), I'm accounting for that by setting it inside of this autocommand
-- useful article: https://vim.fandom.com/wiki/Disable_automatic_comment_insertion

autocmd("FileType", {
  desc = "stop newline comment continuation",
  group = augroup("stopNewlineCommentContinuation", opts),
  command = "setlocal formatoptions-=cro",
})
