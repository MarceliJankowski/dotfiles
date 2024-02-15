##################################################
#                    EXPORTS                     #
##################################################

export readonly EDITOR='nvim'
export readonly VISUAL='nvim'
export readonly DOTFILES="${HOME}/dotfiles"
export readonly NOTES="${HOME}/notes"
export readonly PRETTIERD_DEFAULT_CONFIG="${DOTFILES}/prettier/prettierrc.yaml"

# variables used in my shell scripts
export readonly SHELL_SCRIPTS_PATH="${HOME}/shellScripts/scripts"
export readonly REMOTE_GIT_URL='https://github.com'
export readonly REMOTE_GIT_USERNAME='MarceliJankowski'
export readonly BROWSER='firefox'

 # path to cargo binaries
readonly CARGO_PATH="${HOME}/.cargo/bin"

# NOTE paths from PATH variable are NOT searched recursively
export PATH="${CARGO_PATH}:${SHELL_SCRIPTS_PATH}:${PATH}"
