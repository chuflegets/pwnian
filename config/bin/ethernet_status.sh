#!/bin/sh

echo "%{F#2495e7} %{F#e2ee6a}$(ip -f inet addr show enp0s3 | grep inet | awk '{ print $2 }' | cut -d'/' -f1)%{u-}"
