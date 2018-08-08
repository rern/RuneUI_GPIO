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

if [[ -e $file.backup ]]; then
	appendAsset 'enhance.css' 'gpio.css'
	
	string=$( cat <<'EOF'
    <a id="gpio"><i class="fa fa-addons"></i>GPIO</a>
EOF
)
	appendH 'poweroff-modal'
	
	file=$file.backup
fi

appendAsset 'runeui.css' 'gpio.css'

string=$( cat <<'EOF'
    <li><a id="gpio"><i class="fa fa-addons"></i>GPIO</a></li>
EOF
)
appendH 'poweroff-modal'
#----------------------------------------------------------------------------------
file=/srv/http/app/templates/footer.php
echo $file

string=$( cat <<'EOF'
<input id="gpiosettingscss" type="hidden" value="<?=$this->asset('/css/gpiosettings.css')?>">
<input id="gpiosettingsjs" type="hidden" value="<?=$this->asset('/js/gpiosettings.js')?>">
<input id="gpiopin" type="hidden" value="<?=$this->asset('/img/RPi3_GPIO.svg')?>">
EOF
)

if [[ -e $file.backup ]]; then
	appendAsset 'enhance.js' 'gpio.js'
	
	appendH 'id="addonsinfojs"'
	
	file=$file.backup
fi

appendH 'id="addonsinfojs"'

appendAsset '$' 'gpio.js'
#----------------------------------------------------------------------------------
# Dual boot
if [[ -e /usr/local/bin/hardreset ]]; then
    file=/root/.xbindkeysrc
    echo $file

    commentS 'echo'

    string=$( cat <<'EOF'
"/root/gpiopower.py 6"
EOF
)
    appendS 'echo 6'

    string=$( cat <<'EOF'
"/root/gpiopower.py 8"
EOF
)
    appendS 'echo 8'
fi

# set initial gpio #######################################
echo -e "$bar GPIO service ..."

echo '[Unit]
Description=GPIO initial setup
[Service]
Type=idle
ExecStart=/usr/bin/python /root/gpio.py set
[Install]
WantedBy=multi-user.target
' > /etc/systemd/system/gpioset.service

systemctl enable gpioset
systemctl daemon-reload
/root/gpio.py set

# set permission #######################################
echo 'http ALL=NOPASSWD: ALL' > /etc/sudoers.d/http
chmod 4755 /usr/bin/sudo
usermod -a -G root http # add user osmc to group root to allow /dev/gpiomem access
#chmod g+rw /dev/gpiomem # allow group to access set in gpio.py set for every boot

installfinish $@

clearcache

title -nt "$info Menu > GPIO: long-press = setting, tap = on/off"
