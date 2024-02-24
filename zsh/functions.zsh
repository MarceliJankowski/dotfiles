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
