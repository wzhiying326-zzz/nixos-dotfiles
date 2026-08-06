#! /usr/bin/env bash

swayidle -w \
	timeout 480 'systemctl suspend' \
	timeout 360 'niri msg action power-off-monitors' \
	timeout 180  'swaylock -f' \
	before-sleep 'swaylock -f'
