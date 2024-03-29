##################################################
#                    EXPORTS                     #
##################################################

export readonly EDITOR='nvim'
export readonly VISUAL='nvim'
export readonly DOTFILES="${HOME}/dotfiles"
export readonly NOTES="${HOME}/notes"
export readonly FUZZY_FINDER='fzf'
export readonly FZF_DEFAULT_COMMAND="fd --type f --ignore --no-hidden --exclude={bin,build,node_modules}"
export readonly PRETTIERD_DEFAULT_CONFIG="${DOTFILES}/prettier/prettierrc.yaml"

# shell script variables
export readonly SHELL_SCRIPTS_PATH="${HOME}/shellScripts/scripts"
export readonly BROWSER='firefox'

 # path to cargo binaries
readonly CARGO_PATH="${HOME}/.cargo/bin"

# NOTE paths from PATH variable are NOT searched recursively
export PATH="${CARGO_PATH}:${SHELL_SCRIPTS_PATH}:${PATH}"
