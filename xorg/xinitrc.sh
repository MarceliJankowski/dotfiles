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

{ # configure GUI apps to use IBus, and start its daemon
  export GTK_IM_MODULE="ibus"
  export QT_IM_MODULE="ibus"
  export XMODIFIERS="@im=ibus"

  ibus-daemon --xim --replace --daemonize &
}

# start awesome WM
exec awesome
