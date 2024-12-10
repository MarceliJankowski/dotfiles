return {
  "airblade/vim-rooter", -- changes working directory to project root directory whenever file/directory is opened
  init = function()
    -- list of patterns identifying project root directory
    vim.g.rooter_patterns = {
      ".git",
    }

    -- change directories silently (without echoing)
    vim.g.rooter_silent_chdir = 1

    -- when there's no identified root directory, change to the current file directory
    vim.g.rooter_change_directory_for_non_project_files = "current"
  end,
}
