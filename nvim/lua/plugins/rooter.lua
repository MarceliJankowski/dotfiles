return {
	"airblade/vim-rooter", -- changes working directory to the project root whenever file or directory is opened
	config = function()
		-- list of patterns identifying root directory
		vim.g.rooter_patterns = {
			".git",
			"README.md",
			"Makefile",
		}

		-- change directories silently (without echoing)
		vim.g.rooter_silent_chdir = 1

		-- when there's no identified root directory, change to the current file directory
		vim.g.rooter_change_directory_for_non_project_files = "current"
	end,
}
