#!/usr/bin/env bash

set -o pipefail

# to get info on this script run it with '-h' flag

##################################################
#                GLOBAL VARIABLES                #
##################################################

readonly SCRIPT_NAME=$(basename "$0")

readonly TRUE=0
readonly FALSE=1

readonly INVALID_FLAG_ERROR_CODE=1
readonly INVALID_ARG_ERROR_CODE=2
readonly MISSING_ARG_ERROR_CODE=3
readonly TOO_MANY_ARGS_ERROR_CODE=4
readonly INTERNAL_ERROR_CODE=255

# use addInstalledConfig() to add configs
INSTALLED_CONFIGS=()

# configs which can be installed with this script (names need to be written in cammelCase)
readonly CONFIGS=(
	'alacritty'
	'awesome'
	'clangFormat'
	'fonts'
	'git'
	'grub'
	'nvim'
	'pacman'
	'picom'
	'prettier'
	'tmux'
	'xorg'
	'zsh'
)

readonly MAX_ARG_COUNT=${#CONFIGS[@]}

# options (can be set through CLI or TUI)
VERBOSE_MODE=$FALSE
DOTFILES="${HOME}/dotfiles"
ROOT_CMD='sudo'

readonly MANUAL="
NAME
      $SCRIPT_NAME - install dotfile configs

SYNOPSIS
      $SCRIPT_NAME [-h] [-v] [-d path] [-r cmd] [config]...

DESCRIPTION
      Install configs from dotfiles.
      Some configs require root privileges, in that case '${ROOT_CMD}' is used by default to install them.

      User can choose configs to install by either supplying them at the command-line (in cammelCase),
      or interactively through built-in TUI (default).

OPTIONS
      -h
          Get help, print out the manual and exit.

      -v
          Turn on VERBOSE_MODE (increases output).

      -d path
          Set path to dotfiles directory / Update DOTFILES variable with 'path'.

      -r cmd
          Set command for obtaining root privileges (defaults to '${ROOT_CMD}').

EXIT CODES
      Exit code indicates whether $SCRIPT_NAME successfully executed, or failed for some reason.
      Different exit codes indicate different failure causes:

      0  $SCRIPT_NAME successfully run, without raising any exceptions.

      $INVALID_FLAG_ERROR_CODE  Invalid flag supplied.

      $INVALID_ARG_ERROR_CODE  Invalid argument supplied.

      $MISSING_ARG_ERROR_CODE  Missing mandatory argument.

      $TOO_MANY_ARGS_ERROR_CODE  Too many arguments supplied (max number: ${MAX_ARG_COUNT}).

      $INTERNAL_ERROR_CODE  Developer fuc**d up, blame him!
"

##################################################
#               UTILITY FUNCTIONS                #
##################################################

# @desc print global MANUAL variable
printManual() {
	[[ $# -ne 0 ]] && throwInternalErr "printManual() expects no arguments"

	echo "$MANUAL" | sed -e '1d' -e '$d'
}

# @desc log `message` to stderr and exit with INTERNAL_ERROR_CODE
throwInternalErr() {
	local message="$1"

	[[ $# -ne 1 ]] && message="throwInternalErr() expects 'message' argument"

	echo -e "[INTERNAL_ERROR] - $message" 1>&2

	exit $INTERNAL_ERROR_CODE
}

# @desc log `message` to stderr
logErr() {
	[[ $# -ne 1 ]] && throwInternalErr "logErr() expects 'message' argument"

	local -r message="$1"
	echo -e "[ERROR] - $message" 1>&2
}

# @desc log warning `message` to stdout
logWarning() {
	[[ $# -ne 1 ]] && throwInternalErr "logWarning() expects 'message' argument"

	local -r message="$1"
	echo -e "[WARNING] - $message"
}

# @desc log `message` to stderr and exit with `exitCode`
throwErr() {
	[[ $# -ne 2 ]] && throwInternalErr "throwErr() expects 'message' and 'exitCode' arguments"

	local -r message="$1"
	local -r exit_code="$2"

	logErr "$message"
	exit "$exit_code"
}

# @desc log `message` to stdout if VERBOSE_MODE is on
logIfVerbose() {
	[[ $# -ne 1 ]] && throwInternalErr "logIfVerbose() expects 'message' argument"

	local -r message="$1"

	[[ $VERBOSE_MODE -eq $TRUE ]] && echo -e "[VERBOSE] - $message"
}

# @desc treat INSTALLED_CONFIGS array like a set (only add `config` if it isn't already there)
addInstalledConfig() {
	[[ $# -ne 1 ]] && throwInternalErr "addInstalledConfig() expects 'config' argument"

	local -r config="$1"
	local installed_config

	# check if INSTALLED_CONFIGS contains `config`
	for installed_config in "${INSTALLED_CONFIGS[@]}"; do
		[[ "${installed_config}" = "${config}" ]] && return
	done

	# it doesn't
	INSTALLED_CONFIGS+=("$config")
}

# @desc check if `cmd` is available on the system
# @return 0 if it's available, 1 otherwise
isCmdAvailable() {
	[[ $# -ne 1 ]] && throwInternalErr "isCmdAvailable() expects 'cmd' argument"

	local -r cmd="$1"
	command -v "$cmd" &>/dev/null || return 1 # unavailable

	return 0 # available
}

# @desc echo `input` string with trailing whitespace removed from both ends
trim() {
	[[ $# -ne 1 ]] && throwInternalErr "trim() expects 'input' argument"

	local -r input="$1"
	local -r trimmed_input=$(sed -e 's/^\s+//' -e 's/\s+$//' <<<"$input")

	echo "$trimmed_input"
}

# @desc ask user `question` and process answer into boolean
# @return TRUE if user agreed, FALSE otherwise
askBooleanQuestion() {
	[[ $# -ne 1 ]] && throwInternalErr "askBooleanQuestion() expects 'question' argument"

	local -r question="$1"

	local input
	read -p "$question [y/n] " input
	readonly input

	local -r lowercased_input=${input,,}
	local -r trimmed_lowercased_input=$(trim "$lowercased_input")

	if [[ "$trimmed_lowercased_input" = 'y' || "$trimmed_lowercased_input" = 'yes' ]]; then
		return $TRUE
	else
		return $FALSE
	fi
}

# @desc ask user to pick option and echo trimmed answer
askToPickOption() {
	[[ $# -ne 0 ]] && throwInternalErr "askToPickOption() expects no arguments"

	local option
	read -p "option: " option
	readonly option

	trimmed_option=$(trim "$option")

	echo "$trimmed_option"
}

# @desc format and print `menu`
printMenu() {
	[[ $# -ne 1 ]] && throwInternalErr "printMenu() expects 'menu' argument"

	local -r menu="$1"

	clear
	echo -e "$menu" | sed -e 's/^\s*//' -e '1d'
}

# @desc prompt user before proceeding
askToProceed() {
	[[ $# -ne 0 ]] && throwInternalErr "askToProceed() expects no arguments"

	echo -e "\n-- press 'Enter' to proceed --"
	read
}

# @desc clone git `repository` into `destination`
cloneGitRepo() {
	[[ $# -ne 2 ]] && throwInternalErr "cloneGitRepo() expects 'repository' and 'destination' arguments"

	local -r repo="$1"
	local -r destination="$2"

	logIfVerbose "cloning '${repo}' into '${destination}'..."

	local clone_git_repo_clone_log
	clone_git_repo_clone_log=$(git clone --depth 1 "$repo" "$destination" 2>&1)

	if [[ $? -eq 0 ]]; then
		echo "Successfully cloned '${repo}' into '${destination}'"
	else
		logErr "failed to clone '${repo}' into '${destination}'"
		logErr "$clone_git_repo_clone_log"
		return 1
	fi
}

# @decs create symbolic link between `symlinkOriginal` and `symlinkTarget`
# optional 'root' argument can be passed to denote permission level required for symlink creation
symlink() {
	[[ $# -lt 2 || $# -gt 3 ]] && throwInternalErr "symlink() expects 'symlinkOriginal', 'symlinkTarget' and optionally 'root' arguments"

	local -r symlink_original="${DOTFILES}/${1}"
	local -r symlink_target="$2"
	local -r permissions="$3"

	if [[ ! -e "$symlink_original" ]]; then
		logErr "symlinking failed: '${symlink_original}' doesn't exist!"
		return 1
	fi

	if [[ -e "$symlink_target" && ! -L "$symlink_target" ]]; then
		logErr "symlinking failed: '$symlink_target' already exists and is not a symbolic link (this requires manual intervention)"
		return 1
	fi

	if [[ -L "$symlink_target" ]]; then
		askBooleanQuestion "Symlinking target: '${symlink_target}' already exists and is a symbolic link. Would you like to replace it?"
		if [[ $? -eq $TRUE ]]; then
			logIfVerbose "removing ${symlink_target}..."

			if [[ "$permissions" = 'root' ]]; then
				"$ROOT_CMD" rm ${symlink_target}
			else
				rm ${symlink_target}
			fi
		else
			return 0
		fi
	fi

	logIfVerbose "creating symbolic link between '${symlink_original}' and '${symlink_target}'"

	if [[ "$permissions" = 'root' ]]; then
		"$ROOT_CMD" ln -s ${symlink_original} ${symlink_target}
	else
		ln -s ${symlink_original} ${symlink_target}
	fi

	if [[ $? -ne 0 ]]; then
		logErr "symlinking '${symlink_original}' with '${symlink_target}' has failed"
		return 1
	fi

	echo "Successfully symlinked '${symlink_original}' with '${symlink_target}'"
}

# @desc check if `dirPath` exists and create it (and its parent directories) if it doesn't
# optional 'root' argument can be passed to denote permission level required for directory creation
createDirIfItDoesntExist() {
	[[ $# -lt 1 || $# -gt 2 ]] && throwInternalErr "createDirIfItDoesntExist() expects 'dirPath' and optionally 'root' arguments"

	local -r dir_path="$1"
	local -r permissions="$2"

	if [[ -e "$dir_path" && ! -d "$dir_path" ]]; then
		logErr "'${dir_path}' already exists and is not a directory (this requires manual intervention)"
		return 1
	fi

	if [[ ! -d "$dir_path" ]]; then
		logIfVerbose "'${dir_path}' doesn't exist, creating it..."

		if [[ "$permissions" = 'root' ]]; then
			"$ROOT_CMD" mkdir -p "$dir_path"
		else
			mkdir -p "$dir_path"
		fi

		if [[ $? -ne 0 ]]; then
			logErr "creating '${dir_path}' directory failed"
			return 1
		fi

		echo "Successfully created '${dir_path}' directory"
	fi
}

##################################################
#               INSTALL FUNCTIONS                #
##################################################

installAlacritty() {
	[[ $# -ne 0 ]] && throwInternalErr "installAlacritty() expects no arguments"

	echo "Installing: alacritty config"

	local -r alacritty_dir=~/.config/alacritty

	createDirIfItDoesntExist "$alacritty_dir" &&
		symlink alacritty/alacritty.toml ${alacritty_dir}/alacritty.toml &&
		addInstalledConfig 'alacritty'
}

installAwesome() {
	[[ $# -ne 0 ]] && throwInternalErr "installAwesome() expects no arguments"

	echo "Installing: awesome config"

	local -r awesome_wm_dir=~/.config/awesome

	createDirIfItDoesntExist "$awesome_wm_dir" &&
		symlink awesome/rc.lua ${awesome_wm_dir}/rc.lua &&
		symlink awesome/theme.lua ${awesome_wm_dir}/theme.lua

	[[ $? -ne 0 ]] && return 1

	askBooleanQuestion "awesome WM config requires 'awesome-wm-widgets' plugin. Would you like to clone it?"
	if [[ $? -eq $TRUE ]]; then
		cloneGitRepo https://github.com/streetturtle/awesome-wm-widgets ~/.config/awesome/awesome-wm-widgets || return 1
	fi

	addInstalledConfig 'awesome'
}

installClangFormat() {
	[[ $# -ne 0 ]] && throwInternalErr "installClangFormat() expects no arguments"

	echo "Installing: clang-format config"

	symlink clang-format/clang-format.yml ~/.clang-format &&
		addInstalledConfig 'clang-format'
}

installFonts() {
	[[ $# -ne 0 ]] && throwInternalErr "installFonts() expects no arguments"

	echo "Installing: fonts config"

	local -r fonts_dir=~/.local/share/fonts

	createDirIfItDoesntExist "$fonts_dir" &&
		symlink fonts/nerdFonts ${fonts_dir}/nerdFonts &&
		addInstalledConfig 'fonts'
}

installGit() {
	[[ $# -ne 0 ]] && throwInternalErr "installGit() expects no arguments"

	echo "Installing: git config"

	symlink git/gitconfig ~/.gitconfig &&
		addInstalledConfig 'git'
}

installGrub() {
	[[ $# -ne 0 ]] && throwInternalErr "installGrub() expects no arguments"

	echo "Installing: GRUB config"

	symlink grub/grub /etc/default/grub 'root' || return 1

	askBooleanQuestion "Would you like to regenerate 'grub.cfg' (otherwise GRUB config changes won't take effect)?"
	if [[ $? -eq $TRUE ]]; then
		local -r regenerate_cmd="$ROOT_CMD grub-mkconfig -o /boot/grub/grub.cfg"
		regenerate_cmd

		if [[ $? -ne 0 ]]; then
			logErr "regenerating 'grub.cfg' failed (command: '${installGrubRegenerateCmd}')"
			return 1
		fi
	fi

	addInstalledConfig 'GRUB'
}

installNvim() {
	[[ $# -ne 0 ]] && throwInternalErr "installNvim() expects no arguments"

	echo "Installing: nvim config"

	symlink nvim ~/.config/nvim &&
		createDirIfItDoesntExist ~/notes && # my neovim config needs 'notes' directory
		addInstalledConfig 'nvim'
}

installPacman() {
	[[ $# -ne 0 ]] && throwInternalErr "installPacman() expects no arguments"

	echo "Installing: pacman config"

	symlink pacman/pacman.conf /etc/pacman.conf 'root' &&
		addInstalledConfig 'pacman'
}

installPicom() {
	[[ $# -ne 0 ]] && throwInternalErr "installPicom() expects no arguments"

	echo "Installing: picom config"

	local -r picom_dir=~/.config/picom

	createDirIfItDoesntExist "$picom_dir" &&
		symlink picom/picom.conf ${picom_dir}/picom.conf &&
		addInstalledConfig 'picom'
}

installPrettier() {
	[[ $# -ne 0 ]] && throwInternalErr "installPrettier() expects no arguments"

	echo "Installing: prettier config"
	echo "prettier doesn't require seperate installation (read 'prettier/info')"
}

installTmux() {
	[[ $# -ne 0 ]] && throwInternalErr "installTmux() expects no arguments"

	echo "Installing: tmux config"

	symlink tmux/tmux.conf ~/.tmux.conf || return 1

	askBooleanQuestion "tmux config requires 'tpm' plugin manager. Would you like to clone it?"
	if [[ $? -eq $TRUE ]]; then
		cloneGitRepo https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || return 1
	fi

	addInstalledConfig 'tmux'
}

installXorg() {
	[[ $# -ne 0 ]] && throwInternalErr "installXorg() expects no arguments"

	echo "Installing: xorg config"

	symlink xorg/xinitrc.sh ~/.xinitrc || return 1

	askBooleanQuestion "[ROOT] - Would you like to also symlink '10-keyboard.conf' (enables Polish character support)?"
	if [[ $? -eq $TRUE ]]; then
		symlink xorg/10-keyboard.conf /usr/share/X11/xorg.conf.d/10-keyboard.conf 'root' || return 1
	fi

	addInstalledConfig 'xorg'
}

installZsh() {
	[[ $# -ne 0 ]] && throwInternalErr "installZsh() expects no arguments"

	echo "Installing: zsh config"

	local -r zsh_configs_dir=~/.config/zsh

	symlink zsh/zshrc ~/.zshrc &&
		createDirIfItDoesntExist $zsh_configs_dir &&
		symlink zsh/aliases.zsh ${zsh_configs_dir}/aliases.zsh &&
		symlink zsh/exports.zsh ${zsh_configs_dir}/exports.zsh

	[[ $? -ne 0 ]] && return 1

	askBooleanQuestion "Would you like to also symlink 'zprofile' (automatically starts Xorg session)?"
	if [[ $? -eq $TRUE ]]; then
		symlink zsh/zprofile ~/.zprofile || return 1
	fi

	# dependency installations are treated as independent events, failure of one won't prevent others from prompting/happening (but it will prevent adding 'zsh' to INSTALLED_CONFIGS array)
	local is_installation_successful=$TRUE

	askBooleanQuestion "zsh config requires 'oh-my-zsh' framework. Would you like to install it?"
	if [[ $? -eq $TRUE ]]; then
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
		if [[ $? -ne 0 ]]; then
			logErr "'oh-my-zsh' installation failed"
			is_installation_successful=$FALSE
		fi
	fi

	askBooleanQuestion "zsh config requires 'zsh-syntax-highlighting' plugin. Would you like to clone it?"
	if [[ $? -eq $TRUE ]]; then
		cloneGitRepo https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
		[[ $? -ne 0 ]] && is_installation_successful=$FALSE
	fi

	askBooleanQuestion "zsh config requires 'zsh-autosuggestions' plugin. Would you like to clone it?"
	if [[ $? -eq $TRUE ]]; then
		cloneGitRepo https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
		[[ $? -ne 0 ]] && is_installation_successful=$FALSE
	fi

	[[ $is_installation_successful -eq $TRUE ]] && addInstalledConfig 'zsh'
}

installEverything() {
	[[ $# -ne 0 ]] && throwInternalErr "installEverything() expects no arguments"

	local config
	for config in "${CONFIGS[@]}"; do
		install${config^} && echo

		if [[ $? -ne 0 ]]; then
			logErr "$config installation failed"
			break
		fi
	done

	askToProceed
	viewInstalledConfigs
}

##################################################
#                 TUI FUNCTIONS                  #
##################################################

openManual() {
	[[ $# -ne 0 ]] && throwInternalErr "openManual() expects no arguments"

	printManual | "$PAGER"
}

openMainMenu() {
	[[ $# -ne 0 ]] && throwInternalErr "openMainMenu() expects no arguments"

	local -r menu="
    ##################################################
    #                   MAIN MENU                    #
    ##################################################
    # input symbol corresponding to desired action

    - 'q' quit/exit

    - 'h' open manual
    - 'o' view/edit options
    - 'v' view installed configs
    - 'i' install configs
    - '*' install EVERYTHING (asks for consent)
  "

	while true; do
		printMenu "$menu"
		local option=$(askToPickOption)
		clear

		case "$option" in
		'q') exit 0 ;;
		'h') openManual ;;
		'o') openOptionsMenu ;;
		'v') viewInstalledConfigs ;;
		'i') openInstallConfigsMenu ;;
		'*') installEverything ;;
		*) echo "Invalid option: '${option}'" && askToProceed ;;
		esac
	done
}

openOptionsMenu() {
	[[ $# -ne 0 ]] && throwInternalErr "openOptionsMenu() expects no arguments"

	while true; do
		local menu="
      ##################################################
      #                    OPTIONS                     #
      ##################################################
      DOTFILES=${DOTFILES}
      ROOT_CMD=${ROOT_CMD}
      VERBOSE_MODE=${VERBOSE_MODE}

      - 'u' go back to main menu

      - 'd' set DOTFILES path
      - 'r' set ROOT_CMD (used for gaining root privileges)
      - 'v' toggle VERBOSE_MODE (increases output)
    "

		printMenu "$menu"
		local option=$(askToPickOption)
		clear

		case "$option" in
		'u') return 0 ;;
		'd') openSetDotfilesPrompt ;;
		'r') openSetRootCmdPromp ;;
		'v') toggleVerboseMode ;;
		*) echo "Invalid option: '${option}'" && askToProceed ;;
		esac
	done
}

openSetDotfilesPrompt() {
	[[ $# -ne 0 ]] && throwInternalErr "openSetDotfilesPrompt() expects no arguments"

	clear
	local dotfiles_path
	read -p "Provide path to dotfiles directory: ~/" dotfiles_path
	readonly dotfiles_path

	DOTFILES="${HOME}/${dotfiles_path}"
}

openSetRootCmdPromp() {
	[[ $# -ne 0 ]] && throwInternalErr "openSetRootCmdPromp() expects no arguments"

	clear
	read -p "Provide command for gaining root privileges: " ROOT_CMD
	if ! isCmdAvailable "$ROOT_CMD"; then
		logWarning "provided command is not available on the system"
		askToProceed
	fi
}

toggleVerboseMode() {
	[[ $# -ne 0 ]] && throwInternalErr "toggleVerboseMode() expects no arguments"

	if [[ $VERBOSE_MODE -eq $FALSE ]]; then
		VERBOSE_MODE=$TRUE
	else
		VERBOSE_MODE=$FALSE
	fi
}

viewInstalledConfigs() {
	[[ $# -ne 0 ]] && throwInternalErr "viewInstalledConfigs() expects no arguments"

	local menu="
    ##################################################
    #               INSTALLED CONFIGS                #
    ##################################################
    # list of successfully installed configs during this session"

	[[ ${#INSTALLED_CONFIGS[@]} -ge 1 ]] && menu+="\n"

	for config in "${INSTALLED_CONFIGS[@]}"; do
		menu+="\n- $config"
	done

	printMenu "$menu"
	askToProceed
}

openInstallConfigsMenu() {
	[[ $# -ne 0 ]] && throwInternalErr "openInstallConfigsMenu() expects no arguments"

	local -r menu="
    ##################################################
    #                INSTALL CONFIGS                 #
    ##################################################
    # pick symbol/name corresponding to desired option/config

    - 'u' go back to main menu
    - 'v' view installed configs

    - '1' alacritty
    - '2' awesome
    - '3' clang-format
    - '4' fonts
    - '5' git
    - '6' grub ~ ROOT
    - '7' nvim
    - '8' pacman ~ ROOT
    - '9' picom
    - '10' tmux
    - '11' xorg
    - '12' zsh
  "

	while true; do
		printMenu "$menu"
		local option=$(askToPickOption)
		clear

		case "$option" in
		'u') return 0 ;;
		'v')
			viewInstalledConfigs
			continue
			;;
		'1' | 'alacritty') installAlacritty ;;
		'2' | 'awesome') installAwesome ;;
		'3' | 'clang-format') installClangFormat ;;
		'4' | 'fonts') installFonts ;;
		'5' | 'git') installGit ;;
		'6' | 'grub') installGrub ;;
		'7' | 'nvim') installNvim ;;
		'8' | 'pacman') installPacman ;;
		'9' | 'picom') installPicom ;;
		'10' | 'tmux') installTmux ;;
		'11' | 'xorg') installXorg ;;
		'12' | 'zsh') installZsh ;;
		*) echo "Invalid option: '${option}'" ;;
		esac

		askToProceed
	done
}

startTUI() {
	[[ $# -ne 0 ]] && throwInternalErr "startTUI() expects no arguments"

	openMainMenu
	exit 0
}

##################################################
#                 CLI FUNCTIONS                  #
##################################################

# @args config arguments passed to the script
ensureValidityOfConfigArgs() {
	[[ $# -eq 0 ]] && throwInternalErr "ensureValidityOfConfigArgs() expects config arguments"

	local are_all_config_args_valid=$TRUE
	local config_arg
	local config

	for config_arg in "$@"; do
		local is_valid=$FALSE

		for config in "${CONFIGS[@]}"; do
			if [[ "$config_arg" = "$config" ]]; then
				is_valid=$TRUE
				break
			fi
		done

		if [[ $is_valid -eq $FALSE ]]; then
			are_all_config_args_valid=$FALSE
			echo "Invalid config argument: '${config_arg}'"
		fi
	done

	[[ $are_all_config_args_valid -eq $FALSE ]] && exit $INVALID_ARG_ERROR_CODE
}

# @args config arguments passed to the script
processConfigArgs() {
	[[ $# -eq 0 ]] && throwInternalErr "processConfigArgs() expects config arguments"

	local config_arg

	for config_arg in "$@"; do
		install${config_arg^} && echo

		if [[ $? -ne 0 ]]; then
			logErr "$config installation failed"
			break
		fi
	done
}

# @args config arguments passed to the script
startCLI() {
	[[ $# -eq 0 ]] && throwInternalErr "startCLI() expects config arguments"

	ensureValidityOfConfigArgs "$@"
	processConfigArgs "$@"

	echo "Successfully installed configs: $INSTALLED_CONFIGS"
}

##################################################
#             EXECUTION ENTRY POINT              #
##################################################

# handle flags
while getopts ':hvd:r:' FLAG; do
	case "$FLAG" in
	h) printManual && exit 0 ;;
	v) VERBOSE_MODE=$TRUE ;;
	d) DOTFILES="$OPTARG" ;;
	r) ROOT_CMD="$OPTARG" ;;
	:) throwErr "flag '-${OPTARG}' requires argument" $MISSING_ARG_ERROR_CODE ;;
	?) throwErr "invalid flag '-${OPTARG}' supplied" $INVALID_FLAG_ERROR_CODE ;;
	esac
done

# remove flags, leaving script arguments
shift $((OPTIND - 1))

# check if too many arguments were supplied
[[ $# -gt $MAX_ARG_COUNT ]] &&
	throwErr "too many arguments supplied (max number: ${MAX_ARG_COUNT})" $TOO_MANY_ARGS_ERROR_CODE

# determine EXECUTION_MODE
if [[ $# -eq 0 ]]; then
	readonly EXECUTION_MODE='TUI'
else
	readonly EXECUTION_MODE='CLI'
fi

# check if ROOT_CMD is available and handle the case when it's not
if ! isCmdAvailable "$ROOT_CMD"; then
	[[ "$EXECUTION_MODE" = 'TUI' ]] && clear

	logWarning "ROOT_CMD: '${ROOT_CMD}' is not available on the system"
	logWarning "$SCRIPT_NAME won't be able to install configs requiring root permissions (denoted with '[ROOT]' or '~ ROOT')"

	[[ "$EXECUTION_MODE" = 'TUI' ]] && logWarning "you can change ROOT_CMD in the 'OPTIONS' menu" && askToProceed

	if [[ "$EXECUTION_MODE" = 'CLI' ]]; then
		read -p "Provide alternate command for gaining root privileges: " ROOT_CMD

		if ! isCmdAvailable "$ROOT_CMD"; then
			logWarning "provided command '$ROOT_CMD' is not available on the system"

			askBooleanQuestion "Do you want to proceed anyway?"
			[[ $? -eq $FALSE ]] && exit 0
		fi

		echo
	fi
fi

# run the damn thing!
[[ "$EXECUTION_MODE" = 'TUI' ]] && startTUI
[[ "$EXECUTION_MODE" = 'CLI' ]] && startCLI "$@"

exit 0
