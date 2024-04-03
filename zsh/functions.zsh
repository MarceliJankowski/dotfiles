##################################################
#                   FUNCTIONS                    #
##################################################

# @desc display current time in 24-hour format
clock() {
  date '+%H:%M:%S'
}

# @desc display current day
day() {
  echo "It's $(date '+%d %B'), $(date '+%A')."
}

# @desc display current month
month() {
  echo "It's $(date '+%B'), the $(date '+%m' | awk -F '0' '{ print $NF }') month of the year."
}

# @desc display current year
year() {
  date '+%Y'
}

# @desc find project root directory and cd into it (project must be managed with Git)
# @return 0 if all went well, 1 if root directory wasn't found
rdir() {
  local root_dir

  root_dir=$(git rev-parse --show-toplevel)
  [[ $? -ne 0 ]] && return 1

  cd "$root_dir"
}

# @desc filter list of CWD subdirectories, pipe them into FUZZY_FINDER and navigate into the chosen one
# @return 0 if all went well, 1 if FUZZY_FINDER failed
fdir() {
  local directory

  directory=$(fd --type d --ignore --no-hidden --exclude={bin,build,node_modules} | $FUZZY_FINDER)
  [[ $? -ne 0 ]] && return 1

  # wrap directory in quotes so that in case it wasn't found (is empty) cd doesn't navigate into '~/'
  cd "$directory"
}

# @desc run FUZZY_FINDER and open chosen file in EDITOR
# @return 0 if all went well, 1 if FUZZY_FINDER failed
ffilev() {
  local file

  file=$($FUZZY_FINDER)
  [[ $? -ne 0 ]] && return 1

  $EDITOR "$file"
}

# @desc invoke rdir followed by fdir; revert all side effects in case of failure
# @return 0 if all went well, 1 if rdir failed, 2 if fdir failed
rfdir() {
  rdir
  [[ $? -ne 0 ]] && return 1

  fdir
  if [[ $? -ne 0 ]]; then
    cd - 1>/dev/null # revert rdir side effect
    return 2
  fi
}

# @desc invoke rdir followed by ffilev; revert all side effects in case of failure
# @return 0 if all went well, 1 if rdir failed, 2 if ffilev failed
rffilev() {
  rdir
  [[ $? -ne 0 ]] && return 1

  ffilev
  if [[ $? -ne 0 ]]; then
    cd - 1>/dev/null # revert rdir side effect
    return 2
  fi
}
