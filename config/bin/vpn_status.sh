#!/bin/sh

iface=$(ip -br addr show tun0 2> /dev/null | awk '{ print $1 }')

if [ "$iface" = "tun0" ]; then
    echo "%{F#1bbf3e} %{F#e2ee6a}$(ip -br addr show tun0 | awk '{ print $3}' | cut -d'/' -f1)%{u-}"
else
    echo "%{F#1bbf3e}%{u-}%{F-}"
fi

