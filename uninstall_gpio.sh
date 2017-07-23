#!/bin/bash

# uninstall_gpio.sh - RuneUI GPIO
# https://github.com/rern/RuneUI_GPIO

# (called by uninstall.sh)
# not installed
#	exit
# uninstall
#	remove files
#	disable service
#	remove gpio data
#	restore files
# success
#	clear opcache
#	restart local browser
#	info
# remove uninstall_gpio.sh

# import heading function
wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh
runegpio=$( tcolor "RuneUI GPIO" )

# check installed #######################################
if [[ ! -e /srv/http/assets/css/gpiosettings.css ]]; then
	title "$info $runegpio not found."
	exit
fi

# gpio off #######################################
./gpiooff.py &>/dev/null &

title -l = "$bar Uninstall $runegpio ..."
# uninstall packages #######################################
title $runegpio installed packages
pacman -Q python2-pip &>/dev/null && pip='Python-Pip,' || pip=''
echo 'Uninstall' $pip' Python-MPD and Python-Requests:'
echo -e '  \e[0;36m0\e[m Uninstall'
echo -e '  \e[0;36m1\e[m Keep'
echo
echo -e '\e[0;36m0\e[m / 1 ? '
read -n 1 answer
if [[ $answer != 1 ]]; then
		title "Uninstall packages ..."
		pip uninstall -y python-mpd2
		pip uninstall -y requests
		if pacman -Q python2-pip &>/dev/null; then
			pacman -Rs --noconfirm python2-pip
			rm /usr/bin/pip
		fi
fi

# remove files #######################################
title "Remove files ..."
rm -v /root/gpiooff.py
rm -v /root/gpioon.py
rm -v /root/gpioset.py
rm -v /root/gpiostatus.py
rm -v /root/gpiotimer.py
rm -v /root/poweroff.py
rm -v /root/reboot.py
path=/srv/http/
rm -v $path'gpiooff.php'
rm -v $path'gpioon.php'
rm -v $path'gpiosave.php'
rm -v $path'gpiosettings.php'
rm -v $path'gpiostatus.php'
rm -v $path'gpiotimerreset.php'
rm -v $path'poweroff.php'
rm -v $path'reboot.php'
path=/srv/http/assets/
rm -v $path'css/gpiosettings.css'
rm -v $path'img/RPi3_GPIOs.png'
rm -v $path'js/gpio.js'
rm -v $path'js/gpiosettings.js'
rm -v $path'js/vendor/bootstrap-select-1.12.1.min.js'

# if RuneUI enhancement not installed
[[ -e $path'css/custom.css' ]] && enh=true || enh=false
if ! $enh; then
	rm -v $path'css/pnotify.css'
	rm -v $path'js/vendor/pnotify3.custom.min.js'
fi

# restore modified files #######################################
title "Restore modified files ..."
header=/srv/http/app/templates/header.php
echo $header
sed -i -e '\|<?php // gpio|, /?>/ d
' -e '/id="ond"/, /id="offd"/ d
' -e '/id="gpio"/ d
' -e '/gpiosettings.php/ d
' $header
# no RuneUI enhancement
! $enh && sed -i -e '/pnotify.css/ d' $header

footer=/srv/http/app/templates/footer.php
echo $footer
sed -i -e 's/id="poweroff"/id="syscmd-poweroff"/
' -e 's/id="reboot"/id="syscmd-reboot"/
' -e '/gpio.js/ d
' $footer
# no RuneUI enhancement
! $enh && sed -i -e '/pnotify3.custom.min.js/ d' $footer

udev=/etc/udev/rules.d/rune_usb-audio.rules
echo $udev
sed -i '/SUBSYSTEM=="sound"/ s/^#//' $udev
udevadm control --reload

title "Remove service ..."
systemctl disable gpioset
rm -v /usr/lib/systemd/system/gpioset.service

cp -rfv /etc/mpd.conf.pacorig /etc/mpd.conf
systemctl restart mpd

rm -vrf /etc/sudoers.d

# skip if reinstall - gpiouninstall.sh re (any argument)
(( $# != 0 )) && exit

# refresh #######################################
title "Clear PHP OPcache ..."
curl '127.0.0.1/clear'
echo

if pgrep midori >/dev/null; then
	killall midori
	sleep 1
	xinit &>/dev/null &
	echo -e '\nLocal browser restarted.\n'
fi

title -l = "$bar $runegpio uninstalled successfully."
title -nt "$info Refresh browser for no $runegpio."

rm $0
