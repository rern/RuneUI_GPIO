#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=gpio

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

ln -sf /usr/bin/python{2.7,}

mv /srv/http/gpio.json{,.backup} &> /dev/null

getinstallzip

mv /srv/http/gpio.json{.backup,} &> /dev/null

# modify files #######################################
echo -e "$bar Modify files ..."

#----------------------------------------------------------------------------------
file=/srv/http/app/templates/header.php
echo $file

[[ -e $file.backup ]] && file=$file.backup

appendAsset 'runeui.css' 'gpio.css'

string=$( cat <<'EOF'
    <li><a id="gpio"><i class="fa fa-gpio"></i>GPIO</a></li>
EOF
)
appendH 'poweroff-modal'
#----------------------------------------------------------------------------------
file=/srv/http/app/templates/footer.php
echo $file

[[ -e $file.backup ]] && file=$file.backup

string=$( cat <<'EOF'
<input id="bootstrapmincss" type="hidden" value="<?=$this->asset('/css/bootstrap.min.css')?>">
<input id="bootstrapselectmincss" type="hidden" value="<?=$this->asset('/css/bootstrap-select.min.css')?>">
<input id="gpiosettingscss" type="hidden" value="<?=$this->asset('/css/gpiosettings.css')?>">
<input id="gpiosettingsjs" type="hidden" value="<?=$this->asset('/js/gpiosettings.js')?>">
<input id="gpiopin" type="hidden" value="<?=$this->asset('/img/RPi3_GPIO.svg')?>">
EOF
)
insertH 'jquery-2.1.0.min.js'

appendAsset 'fastclick.min.js' 'gpio.js'
#----------------------------------------------------------------------------------
# Dual boot
if [[ -e /usr/local/bin/hardreset ]]; then
    file=/root/.xbindkeysrc
    echo $file

    commentS 'echo'

    string=$( cat <<'EOF'
"/root/gpiooff.py; echo 6 > /sys/module/bcm2709/parameters/reboot_part; /var/www/command/rune_shutdown; reboot"
EOF
)
    appendS 'echo 6'

    string=$( cat <<'EOF'
"/root/gpiooff.py; echo 8 > /sys/module/bcm2709/parameters/reboot_part; /var/www/command/rune_shutdown; reboot"
EOF
)
    appendS 'echo 8'
fi

# set initial gpio #######################################
echo -e "$bar GPIO service ..."

string=$( cat <<'EOF'
[Unit]
Description=GPIO initial setup
[Service]
Type=idle
ExecStart=/usr/bin/python /root/gpio.py set
[Install]
WantedBy=multi-user.target
EOF
)
echo "$string" > /etc/systemd/system/gpioset.service

systemctl enable gpioset
systemctl daemon-reload
/root/gpio.py set

# set permission #######################################
usermod -a -G root http # add user osmc to group root to allow /dev/gpiomem access
#chmod g+rw /dev/gpiomem # allow group to access set in gpio.py set for every boot

installfinish $@

title -nt "$info Menu > GPIO: long-press = setting, tap = on/off"

restartlocalbrowser
