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

# start ibus-daemon
ibus-daemon -dr

# set 'awesome' as the default WM in case no arguments were passed to this script
session=${1:-awesome}

case $session in
awesome) exec awesome ;;
bspwm) exec bspwm ;;
dwm) exec dwm ;;
i3 | i3wm) exec i3 ;;
xmonad) exec xmonad ;;

# unrecognized session, try running it as command
*) exec $1 ;;
esac
