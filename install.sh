#!/bin/bash

##################################################
#                   VARIABLES                    #
##################################################

readonly SCRIPT_NAME=$(basename "$0")
readonly SCRIPT_INTERNAL_ERROR=255

INSTALLED_CONFIGS=() # use addInstalledConfig() for adding elements

# options (user can tweak those)
VERBOSE_MODE='false'
DOTFILES=~/dotfiles

##################################################
#                   UTILITIES                    #
##################################################

# @desc log `message` to std error and exit with SCRIPT_INTERNAL_ERROR
throwInternalErr() {
	local MESSAGE="$1"

	[[ $# -ne 1 ]] && MESSAGE="throwInternalErr() expects 'message' argument"

	echo -e "[INTERNAL ERROR] - $MESSAGE" 1>&2

	exit $SCRIPT_INTERNAL_ERROR
}

# @desc log `message` to std error
logErr() {
	[[ $# -ne 1 ]] && throwInternalErr "logErr() expects 'message' argument"

	local readonly MESSAGE="$1"
	echo -e "[ERROR] - $MESSAGE" 1>&2
}

# @desc log `message` to std error and exit with `exitCode`
throwErr() {
	[[ $# -ne 2 ]] && throwInternalErr "throwErr() expects 'message' and 'exitCode' arguments"

	local readonly MESSAGE="$1"
	local readonly EXIT_CODE="$2"

	logErr "$MESSAGE"

	exit $EXIT_CODE
}

# @desc log `message` to std output if VERBOSE_MODE is on
logIfVerbose() {
	[[ $# -ne 1 ]] && throwInternalErr "logIfVerbose() expects 'message' argument"

	local readonly MESSAGE="$1"

	[[ "$VERBOSE_MODE" = 'true' ]] && echo "[VERBOSE] - $1"
}

# @desc treat INSTALLED_CONFIGS array like a set (only add `config` if it isn't already there)
addInstalledConfig() {
	[[ $# -ne 1 ]] && throwInternalErr "addInstalledConfig() expects 'config' argument"

	local readonly CONFIG="$1"

	for INSTALLED_CONFIG in "${INSTALLED_CONFIGS[@]}"; do
		[[ "$INSTALLED_CONFIG" = "$CONFIG" ]] && return 0
	done

	INSTALLED_CONFIGS+=("$CONFIG")
}

# @desc echo `input` string with trailing whitespace removed from both ends
trim() {
	[[ $# -ne 1 ]] && throwInternalErr "trim() expects 'input' argument"

	local readonly INPUT="$1"
	local readonly TRIMMED_INPUT=$(echo "$INPUT" | sed -e 's/^\s+//' -e 's/\s+$//')

	echo "$TRIMMED_INPUT"
}

# @desc ask user `question` and echo answer processed into boolean (true/false string)
askBooleanQuestion() {
	[[ $# -ne 1 ]] && throwInternalErr "askBooleanQuestion() expects 'question' argument"

	local readonly QUESTION="$1"

	read -p "$QUESTION [y/n] " INPUT

	local readonly LOWERCASED_INPUT=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]')
	local readonly TRIMMED_LOWERCASED_INPUT=$(trim "$LOWERCASED_INPUT")

	if [[ "$TRIMMED_LOWERCASED_INPUT" = 'y' || "$TRIMMED_LOWERCASED_INPUT" = 'yes' ]]; then
		echo 'true'
	else
		echo 'false'
	fi
}

# @desc ask user to pick option and echo trimmed answer
askToPickOption() {
	read -p 'option: ' OPTION
	TRIMMED_OPTION=$(trim "$OPTION")

	echo "$TRIMMED_OPTION"
}

# @desc format and print `menu`
printMenu() {
	[[ $# -ne 1 ]] && throwInternalErr "printMenu() expects 'menu' argument"

	local readonly MENU="$1"

	clear
	echo -e "$MENU" | sed -e 's/^\s*//' -e '1d'
}

# @desc prompt user before proceeding
askToProceed() {
	echo -e "\n-- press 'ENTER' to proceed --"
	read
}

# @desc clone git `repository` into `destination`
cloneGitRepo() {
	[[ $# -ne 2 ]] && throwInternalErr "cloneGitRepo() expects 'repository' and 'destination' arguments"

	local readonly REPO="$1"
	local readonly DESTINATION="$2"

	logIfVerbose "cloning '${REPO}' into '${DESTINATION}'..."

	# this variable is left in global scope on purpose, as 'local' messes with capturing exit status
	CLONE_GIT_REPO_CLONE_LOG=$(git clone --depth 1 "$REPO" "$DESTINATION" 2>&1)

	if [[ $? -eq 0 ]]; then
		echo "Successfully cloned '${REPO}' into '${DESTINATION}'"
	else
		logErr "failed to clone '${REPO}' into '${DESTINATION}'"
		logErr "$CLONE_GIT_REPO_CLONE_LOG"
		return 1
	fi
}

# @decs create symbolic link between `symlinkOriginal` and `symlinkTarget`
# optional 'root' argument can be passed to denote permission level required for symlink creation
symlink() {
	[[ $# -lt 2 || $# -gt 3 ]] && throwInternalErr "symlink() expects 'symlinkOriginal', 'symlinkTarget' and optionally 'root' arguments"

	local readonly SYMLINK_ORIGINAL=${DOTFILES}/${1}
	local readonly SYMLINK_TARGET=$2
	local readonly PERMISSIONS="$3"

	if [[ ! -e $SYMLINK_ORIGINAL ]]; then
		logErr "symlinking failed: '${SYMLINK_ORIGINAL}' doesn't exist!"
		return 1
	fi

	if [[ -e $SYMLINK_TARGET && ! -L $SYMLINK_TARGET ]]; then
		logErr "symlinking failed: '$SYMLINK_TARGET' already exists and is not a symbolic link (this requires manual intervention)"
		return 2
	fi

	if [[ -L $SYMLINK_TARGET ]]; then
		local readonly REPLACE=$(askBooleanQuestion "Symlinking target: '${SYMLINK_TARGET}' already exists and is a symbolic link. Would you like to replace it?")

		if [[ "$REPLACE" = 'true' ]]; then
			logIfVerbose "removing ${SYMLINK_TARGET}..."

			if [[ "$PERMISSIONS" = 'root' ]]; then
				sudo rm ${SYMLINK_TARGET}
			else
				rm ${SYMLINK_TARGET}
			fi
		else
			return 0
		fi
	fi

	logIfVerbose "creating symbolic link between '${SYMLINK_ORIGINAL}' and '${SYMLINK_TARGET}'"

	if [[ "$PERMISSIONS" = 'root' ]]; then
		sudo ln -s ${SYMLINK_ORIGINAL} ${SYMLINK_TARGET}
	else
		ln -s ${SYMLINK_ORIGINAL} ${SYMLINK_TARGET}
	fi

	if [[ $? -ne 0 ]]; then
		logErr "symlinking '${SYMLINK_ORIGINAL}' with '${SYMLINK_TARGET}' has failed"
		return 3
	fi

	echo "Successfully symlinked '${SYMLINK_ORIGINAL}' with '${SYMLINK_TARGET}'"
}

# @desc check if `dirPath` exists and create it (and its parent directories) if it doesn't
# optional 'root' argument can be passed to denote permission level required for directory creation
createDirIfItDoesntExist() {
	[[ $# -lt 1 || $# -gt 2 ]] && throwInternalErr "createDirIfItDoesntExist() expects 'dirPath' and optionally 'root' arguments"

	local readonly DIR_PATH=$1
	local readonly PERMISSIONS="$2"

	if [[ -e $DIR_PATH && ! -d $DIR_PATH ]]; then
		logErr "'${DIR_PATH}' already exists and is not a directory (this requires manual intervention)"
		return 1
	fi

	if [[ ! -d $DIR_PATH ]]; then
		logIfVerbose "'${DIR_PATH}' doesn't exist, creating it..."

		if [[ "$PERMISSIONS" = 'root' ]]; then
			sudo mkdir -p $DIR_PATH
		else
			mkdir -p $DIR_PATH
		fi

		if [[ $? -ne 0 ]]; then
			logErr "creating '${DIR_PATH}' directory failed"
			return 2
		fi

		echo "Successfully created '${DIR_PATH}' directory"
	fi
}

##################################################
#               INSTALL FUNCTIONS                #
##################################################

installAlacritty() {
	echo "Installing: alacritty config"

	local readonly ALACRITTY_DIR=${HOME}/.config/alacritty

	createDirIfItDoesntExist $ALACRITTY_DIR &&
		symlink alacritty/alacritty.yml ${ALACRITTY_DIR}/alacritty.yml &&
		addInstalledConfig 'alacritty'
}

installAwesome() {
	echo "Installing: awesome config"

	local readonly AWESOME_WM_DIR=~/.config/awesome

	createDirIfItDoesntExist $AWESOME_WM_DIR &&
		symlink awesome/rc.lua ${AWESOME_WM_DIR}/rc.lua &&
		symlink awesome/theme.lua ${AWESOME_WM_DIR}/theme.lua

	[[ $? -ne 0 ]] && return 1

	local readonly CLONE_WIDGETS=$(askBooleanQuestion "awesome WM config requires 'awesome-wm-widgets' plugin. Would you like to clone it?")

	if [[ "$CLONE_WIDGETS" = 'true' ]]; then
		cloneGitRepo https://github.com/streetturtle/awesome-wm-widgets ~/.config/awesome/awesome-wm-widgets &&
			addInstalledConfig 'awesome'
	else
		addInstalledConfig 'awesome'
	fi
}

installFonts() {
	echo "Installing: fonts config"

	local readonly FONTS_DIR=~/.local/share/fonts

	createDirIfItDoesntExist $FONTS_DIR &&
		symlink fonts/nerdFonts ${FONTS_DIR}/nerdFonts &&
		addInstalledConfig 'fonts'
}

installGit() {
	echo "Installing: git config"

	symlink git/gitconfig ${HOME}/.gitconfig &&
		addInstalledConfig 'git'
}

installGRUB() {
	echo "Installing: GRUB config"

	symlink grub/grub /etc/default/grub 'root'
	[[ $? -ne 0 ]] && return 1

	local readonly REGENERATE=$(askBooleanQuestion "Would you like to regenerate 'grub.cfg' (otherwise GRUB config changes won't take effect)?")

	if [[ "$REGENERATE" = 'true' ]]; then
		sudo grub-mkconfig -o /boot/grub/grub.cfg &&
			addInstalledConfig 'GRUB'

		if [[ $? -ne 0 ]]; then
			logErr "regenerating 'grub.cfg' failed (command: 'sudo grub-mkconfig -o /boot/grub/grub.cfg')"
			return 2
		fi

		return 0
	else
		addInstalledConfig 'GRUB'
	fi
}

installNvim() {
	echo "Installing: nvim config"

	symlink nvim ~/.config/nvim &&
		createDirIfItDoesntExist ~/notes && # my neovim config needs 'notes' directory
		addInstalledConfig 'nvim'
}

installPacman() {
	echo "Installing: pacman config"

	symlink pacman/pacman.conf /etc/pacman.conf 'root' &&
		addInstalledConfig 'pacman'
}

installPicom() {
	echo "Installing: picom config"

	local readonly PICOM_DIR=~/.config/picom

	createDirIfItDoesntExist $PICOM_DIR &&
		symlink picom/picom.conf ${PICOM_DIR}/picom.conf &&
		addInstalledConfig 'picom'
}

installTmux() {
	echo "Installing: tmux config"

	symlink tmux/tmux.conf ~/.tmux.conf
	[[ $? -ne 0 ]] && return 1

	local readonly CLONE=$(askBooleanQuestion "tmux config requires 'tpm' plugin manager. Would you like to clone it?")

	if [[ "$CLONE" = 'true' ]]; then
		cloneGitRepo https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm &&
			addInstalledConfig 'tmux'
	else
		addInstalledConfig 'tmux'
	fi
}

installXorg() {
	echo "Installing: xorg config"

	symlink xorg/xinitrc.sh ~/.xinitrc &&
		addInstalledConfig 'xorg'
}

installXorgPolishCharacterSupport() {
	echo "Installing: 10-keyboard config"

	symlink xorg/10-keyboard.conf /usr/share/X11/xorg.conf.d/10-keyboard.conf 'root' &&
		addInstalledConfig '10-keyboard.conf'
}

installZsh() {
	echo "Installing: zsh config"

	local readonly ZSH_CONFIGS_DIR=${HOME}/.config/zsh

	symlink zsh/zshrc ~/.zshrc &&
		createDirIfItDoesntExist $ZSH_CONFIGS_DIR &&
		symlink zsh/aliases.zsh ${ZSH_CONFIGS_DIR}/aliases.zsh &&
		symlink zsh/exports.zsh ${ZSH_CONFIGS_DIR}/exports.zsh

	[[ $? -ne 0 ]] && return 1

	local readonly SYMLINK_ZPROFILE=$(askBooleanQuestion "Would you like to also symlink 'zprofile' (automatically starts Xorg session)?")
	if [[ "$SYMLINK_ZPROFILE" = 'true' ]]; then
		symlink zsh/zprofile ~/.zprofile
		[[ $? -ne 0 ]] && return 1
	fi

	# dependency installations are treated as independent events, failure of one won't prevent others from prompting/happening (but it will prevent adding 'zsh' to INSTALLED_CONFIGS array)
	local INSTALL_STATUS

	local readonly INSTALL_OH_MY_ZSH=$(askBooleanQuestion "zsh config requires 'oh-my-zsh' framework. Would you like to install it?")
	if [[ "$INSTALL_OH_MY_ZSH" = 'true' ]]; then
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
		if [[ $? -ne 0 ]]; then
			logErr "'oh-my-zsh' installation failed"
			INSTALL_STATUS="fail"
		fi
	fi

	local readonly INSTALL_SYNTAX_HIGHLIGHTING=$(askBooleanQuestion "zsh config requires 'zsh-syntax-highlighting' plugin. Would you like to clone it?")
	if [[ "$INSTALL_SYNTAX_HIGHLIGHTING" = 'true' ]]; then
		cloneGitRepo https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
		[[ $? -ne 0 ]] && INSTALL_STATUS="fail"
	fi

	local readonly INSTALL_AUTOSUGGESTIONS=$(askBooleanQuestion "zsh config requires 'zsh-autosuggestions' plugin. Would you like to clone it?")
	if [[ "$INSTALL_AUTOSUGGESTIONS" = 'true' ]]; then
		cloneGitRepo https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
		[[ $? -ne 0 ]] && INSTALL_STATUS="fail"
	fi

	[[ "$INSTALL_STATUS" != 'fail' ]] && addInstalledConfig 'zsh'
}

installClangFormat() {
	echo "Installing: clang-format config"

	symlink clang-format/clang-format.yml ~/.clang-format && addInstalledConfig 'clang-format'
}

installEverything() {
	local readonly CONFIGS=("Alacritty" "Awesome" "Fonts" "Git" "GRUB" "Nvim" "Pacman" "Picom" "Tmux" "Xorg" "XorgPolishCharacterSupport" "Zsh", "ClangFormat")

	for CONFIG in "${CONFIGS[@]}"; do
		install"$CONFIG" && echo

		if [[ $? -ne 0 ]]; then
			logErr "$CONFIG installation failed"
			break
		fi
	done

	askToProceed
	viewInstalledConfigs
}

##################################################
#                 CORE FUNCTIONS                 #
##################################################

printManual() {
	local readonly MANUAL="
NAME
      $SCRIPT_NAME - installs configs from dotfiles

SYNOPSIS
      $SCRIPT_NAME [-h] [-v] [-d path]

DESCRIPTION
      Utility script meant for installing configs from dotfiles
      Some configs require root privileges, in that case 'sudo' is being used to install them

OPTIONS
      -h
          Get help, print out the manual and exit

      -v
          Turn on VERBOSE_MODE (increases output)

      -d path
          Set path to dotfiles directory / Update DOTFILES variable with 'path'

EXIT CODES
      Exit code indicates whether $SCRIPT_NAME successfully executed, or failed for some reason
      Different exit codes indicate different failure causes

      0  $SCRIPT_NAME successfully run, without raising any exceptions

      1  User didn't supply mandatory flag argument

      2  User supplied invalid option

      $SCRIPT_INTERNAL_ERROR  Developer fuc**d up, blame him!
"

	echo "$MANUAL" | sed -e '1d' -e '$d'
}

openManual() {
	printManual | less
}

openSetDotfilesPrompt() {
	clear
	read -p 'Provide path to dotfiles directory: ~/' DOTFILES_PATH
	DOTFILES=~/${DOTFILES_PATH}
}

toggleVerboseMode() {
	if [[ "$VERBOSE_MODE" = 'false' ]]; then
		VERBOSE_MODE='true'
	else
		VERBOSE_MODE='false'
	fi
}

openMainMenu() {
	local readonly MENU="
    ##################################################
    #                   MAIN MENU                    #
    ##################################################
    # input symbol corresponding to desired action

    - 'q' quit/exit

    - 'h' open manual
    - 'o' view/edit options
    - 'i' view installed configs
    - 'p' pick configs to install
    - '*' install EVERYTHING
  "

	while true; do
		printMenu "$MENU"
		local readonly OPTION=$(askToPickOption)
		clear

		case "$OPTION" in
		'q') exit 0 ;;
		'h') openManual ;;
		'o') openOptionsMenu ;;
		'i') viewInstalledConfigs ;;
		'p') openInstallConfigsMenu ;;
		'*') installEverything ;;
		*) echo "Invalid option: '${OPTION}'" && askToProceed ;;
		esac
	done
}

openOptionsMenu() {
	while true; do
		local readonly MENU="
      ##################################################
      #                    OPTIONS                     #
      ##################################################
      VERBOSE_MODE=${VERBOSE_MODE}
      DOTFILES=${DOTFILES}

      - 'u' go back to main menu

      - 'd' set DOTFILES path
      - 'v' toggle VERBOSE_MODE (increases output)
    "

		printMenu "$MENU"
		local readonly OPTION=$(askToPickOption)
		clear

		case "$OPTION" in
		'u') return 0 ;;
		'd') openSetDotfilesPrompt ;;
		'v') toggleVerboseMode ;;
		*) echo "Invalid option: '${OPTION}'" && askToProceed ;;
		esac
	done
}

viewInstalledConfigs() {
	local readonly MENU="
    ##################################################
    #               INSTALLED CONFIGS                #
    ##################################################
    # list of successfully installed configs during this session"

	[[ "${#INSTALLED_CONFIGS[@]}" -ge 1 ]] && MENU+="\n"

	for CONFIG in "${INSTALLED_CONFIGS[@]}"; do
		MENU+="\n- $CONFIG"
	done

	printMenu "$MENU"
	askToProceed
}

openInstallConfigsMenu() {
	local readonly MENU="
    ##################################################
    #                INSTALL CONFIGS                 #
    ##################################################
    # pick symbol/name corresponding to desired option/config

    - 'u' go back to main menu
    - 'i' view installed configs

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
    - '12' 10-keyboard.conf (xorg polish character support) ~ ROOT
    - '13' zsh
  "

	while true; do
		printMenu "$MENU"
		local readonly OPTION=$(askToPickOption)
		clear

		case "$OPTION" in
		'u') return 0 ;;
		'i')
			viewInstalledConfigs
			continue
			;;
		'1' | 'alacritty') installAlacritty ;;
		'2' | 'awesome') installAwesome ;;
		'3' | 'clang-format') installClangFormat ;;
		'4' | 'fonts') installFonts ;;
		'5' | 'git') installGit ;;
		'6' | 'grub') installGRUB ;;
		'7' | 'nvim') installNvim ;;
		'8' | 'pacman') installPacman ;;
		'9' | 'picom') installPicom ;;
		'10' | 'tmux') installTmux ;;
		'11' | 'xorg') installXorg ;;
		'12' | '10-keyboard.conf') installXorgPolishCharacterSupport ;;
		'13' | 'zsh') installZsh ;;
		*) echo "Invalid option: '${OPTION}'" ;;
		esac

		askToProceed
	done
}

##################################################
#              MAIN EXECUTION BLOCK              #
##################################################

# check if 'sudo' is available on the system
if ! command -v sudo 1>/dev/null; then
	clear
	echo "[WARNING] - 'sudo' is not available on the system"
	echo "[WARNING] - $SCRIPT_NAME won't be able to install configs requiring root permissions (denoted with: '~ ROOT' in the 'INSTALL CONFIGS' menu)"
	askToProceed
fi

# handle flags
while getopts ':hvd:' OPTION; do
	case "$OPTION" in
	h) printManual && exit 0 ;;
	v) VERBOSE_MODE='true' ;;
	d) DOTFILES="$OPTARG" ;;
	:) throwErr "flag '-${OPTARG}' requires argument" 1 ;;
	?) throwErr 'user supplied invalid option' 2 ;;
	esac
done

# remove flags, leaving only arguments
shift $((OPTIND - 1))

openMainMenu

exit 0
