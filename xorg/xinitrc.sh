#!/bin/sh

# execute scripts in /etc/X11/xinit/xinitrc.d directory
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*.sh; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# start compositor
picom &

# bind capslock to escape
setxkbmap -option "caps:escape"

# start awesome WM
exec awesome
