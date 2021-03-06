+R GPIO
---
Control GPIO-connected relay module for power on / off audio equipments.  

As of 20200717, this has been integrated to [**RuneAudio+R e4**](https://www.runeaudio.com/forum/runeaudio-r-e4-t7084.html)

>[Features](#features)  
>[Things to get](#things-to-get)  
>[Things to do](#things-to-do)  
>[Before install](#before-install)  
>[Install](#install)  

![settings](https://github.com/rern/_assets/blob/master/RuneUI_GPIO/gpio.gif)  

Features
---

**Power `on` `off` audio equipments in sequence**
- up to 4 equipments(relays)
- delay setting for each equipment(relay)
- Notification broadcast for `on` `off`

**Idle timer power off**
- polling 'play' status every minute
- idle time setting
- notification last minute warning with countdown
- reset on play or `reset` button during warning

**Integrated into existing RuneUI**
- `GPIO` (speaker icon) button on the left of top bar
- change button icon and color on `on` `off`
- show button only when enable
- setting in `Menu` > `GPIO`
- instantly update all fields on changing pins or names
- `RPi J8` pin numbering diagram included, show / hide on click
- Auto power off on reboot / shutdown
- Can be used with [**USB PC Remote**](https://github.com/rern/Rune_USB_PC_Remote)

<hr>

![warning](https://github.com/rern/_assets/blob/master/RuneUI_GPIO/warning_el.png) **Warning**
- A relay module can be connected to GPIO, to see how it works, by anyone with basic skill.  
- Wrong connection may just damage your RPi. (only 5V)  
- Requires **electrical skill and knowledge** to connect these relays as power switches. (110V / 220V)  
- **Electric shock can kill.**  

<hr>

### Things to get
Dirt cheap on ebay

![relay](https://github.com/rern/_assets/raw/master/RuneUI_GPIO/relay.jpg)  
![relay](https://github.com/rern/_assets/raw/master/RuneUI_GPIO/relay_module_circuit.png)

- [Relay module](https://www.ebay.com/sch/i.html?_from=R40&_trksid=p2055119.m570.l1313.TR0.TRC0.H0.Xrelay+low+high+trigger.TRS0&_nkw=relay+low+high+trigger&_sacat=0)
	- **low trigger** causes on-off flash at boot
    - use **high/low level trigger** and set to **high**
	- For complete isolation:
		- Remove all jumpers
		- Connect all center pins to RPi ground
		- Power relay module with a separated 5V power supply
- [GPIO jumper wires](http://www.ebay.com/sch/i.html?_from=R40&_trksid=p2047675.m570.l1313.TR0.TRC0.H0.X10pcs+2pin+jumper.TRS0&_nkw=10pcs+2pin+jumper&_sacat=0)
- Power cables
- DIY enclosure

### The box
- LEDs for GPIO 3.3V status
- Switches
	- Normal : GPIO 3.3V > LED ON, relay ON
	- Off : GPIO 3.3V > LED ON, relay OFF
	- Bypass : Direct 5V > LED OFF, relay ON
	
[![11](https://github.com/rern/_assets/blob/master/RuneUI_GPIO/GPIOs/11.jpg)](https://github.com/rern/_assets/blob/master/RuneUI_GPIO/11.jpg?raw=1)
[![8](https://github.com/rern/_assets/blob/master/RuneUI_GPIO/GPIOs/08.jpg)](https://github.com/rern/_assets/blob/master/RuneUI_GPIO/08.jpg?raw=1)
[![9](https://github.com/rern/_assets/blob/master/RuneUI_GPIO/GPIOs/09.jpg)](https://github.com/rern/_assets/blob/master/RuneUI_GPIO/09.jpg?raw=1)
[![10](https://github.com/rern/_assets/blob/master/RuneUI_GPIO/GPIOs/10.jpg)](https://github.com/rern/_assets/blob/master/RuneUI_GPIO/10.jpg?raw=1)

### Software
from [**Addons Menu**](https://github.com/rern/RuneAudio_Addons)  
