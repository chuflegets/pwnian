#!/bin/sh

sxhkd &
compton --config %HOME%/.config/compton/compton.conf &
wmname LG3D &
feh --bg-fill %HOME%/Pictures/sakura.jpg &
~/.config/polybar/launch.sh &

bspc config pointer_modifier mod1

bspc monitor -d I II III IV V VI VII VIII IX X

bspc config border_width         2
bspc config window_gap          12

bspc config split_ratio          0.52
bspc config borderless_monocle   true
bspc config gapless_monocle      true

bspc rule -a Caja desktop='^8' state=floating follow=on
bspc rule -a Gimp desktop='^8' state=floating follow=on
bspc rule -a Chromium desktop='^2'
bspc rule -a mplayer2 state=floating
bspc rule -a Kupfer.py focus=on
bspc rule -a Screenkey manage=off
