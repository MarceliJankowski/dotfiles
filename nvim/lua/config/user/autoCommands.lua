--------------------------------------------------
--               LOCAL VARIABLES                --
--------------------------------------------------

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local opts = { clear = true }

--------------------------------------------------
--                REMEMBER FOLDS                --
--------------------------------------------------
-- 'pattern' field uses shell globs, not RegExpr ('?*' makes sure that buffer has a name)

local rememberFoldsGroup = augroup("rememberFolds", opts)

autocmd("BufWinLeave", {
	pattern = "?*",
	command = "mkview",
	group = rememberFoldsGroup,
	desc = 'create a "snapshot" of current buffer (saves folds)',
})

autocmd("BufWinEnter", {
	pattern = "?*",
	command = "silent! loadview",
	group = rememberFoldsGroup,
	desc = 'load (if available) "snapshot" of the current buffer (restores folds)',
})

--------------------------------------------------
--           PERMAMENTLY DELETE MARKS           --
--------------------------------------------------

local deleteMarksPermamentlyGroup = augroup("deleteMarksPermamently", opts)

autocmd("BufWritePre", {
	command = "wshada!",
	group = deleteMarksPermamentlyGroup,
	desc = "write to ShaDa file (deletes marks permamently)",
})

--------------------------------------------------
--            HIGHLIGHT YANKED TEXT             --
--------------------------------------------------

local highlightYankedTextGroup = augroup("highlightYankedText", opts)

autocmd("TextYankPost", {
	command = 'silent! lua vim.highlight.on_yank({ higroup="IncSearch", timeout=350 })',
	group = highlightYankedTextGroup,
	desc = "highlight yanked text",
})

--------------------------------------------------
--      STOP NEWLINE COMMENT CONTINUATION       --
--------------------------------------------------
-- 'formatoptions' setting gets overwritten by 'ftplugin' (internal vim plugin), I'm accounting for that by setting it inside of this autocommand
-- useful article: https://vim.fandom.com/wiki/Disable_automatic_comment_insertion

local stopNewlineCommentContinuationGroup = augroup("stopNewlineCommentContinuation", opts)

autocmd("FileType", {
	command = "setlocal formatoptions-=cro",
	group = stopNewlineCommentContinuationGroup,
	desc = "stop newline comment continuation",
})
