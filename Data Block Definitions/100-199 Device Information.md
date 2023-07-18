## Recording Device And System Information Data Blocks

---

* #### Block Code: 100
  * Block Definition: SYSTEM_TYPE
  * Description: "Vulintus system ID code (1 = MotoTrak, 2 = OmniTrak, 3 = HabiTrak, 4 = OmniHome, 5 = SensiTrak, 6 = Prototype)."
  * Status:
  * Block Format:
    * 1x (uint8): Vulintus system ID number.

---

* #### Block Code: 101
  * Block Definition: SYSTEM_NAME
  * Description: "Vulintus system name (a.k.a. the overall Vulintus product family name, NOT a name set by the user)."
  * Status:
  * Block Format:
    * 1x (uint8): number of characters to follow.
    * Nx (char): characters of the system name.

---

* #### Block Code: 102
  * Block Definition: SYSTEM_HW_VER
  * Description: "Vulintus system hardware version."
  * Status:
  * Block Format:
    * 1x (float32): hardware version number.

---

* #### Block Code: 103
  * Block Definition: SYSTEM_FW_VER
  * Description: "Vulintus system firmware version, written as characters."
  * Status:
  * Block Format:
    * 1x (uint8): number of characters to follow.
    * Nx (char): characters of the firmware version.
   
---

* #### Block Code: 104
  * Block Definition: SYSTEM_SN
  * Description: "Vulintus system firmware version, written as characters."
  * Status:
  * Block Format:
    * 1x (uint8): number of characters to follow.
    * Nx (char): characters of the firmware version.

---

* #### Block Code: 105
  * Block Definition: SYSTEM_MFR
  * Description: "Manufacturer name for non-Vulintus systems."
  * Status:
  * Block Format:
    * 1x (uint8): number of characters to follow.
    * Nx (char): characters of the manufacturer name.
 
---

* #### Block Code: 106
  * Block Definition: COMPUTER_NAME
  * Description: "Windows PC computer name."
  * Status:
  * Block Format:
    * 1x (uint8): number of characters to follow.
    * Nx (char): characters of the computer name.
   
---

* #### Block Code: 107
  * Block Definition: COM_PORT
  * Description: "The COM port of a computer-connected system."
  * Status:
  * Block Format:
    * 1x (uint8): number of characters to follow.
    * Nx (char): characters of the COM port name.

---

* #### Block Code: 108
  * Block Definition: DEVICE_ALIAS
  * Description: "Human-readable Adjective + Noun alias/name for the device, assigned by Vulintus during manufacturing."
  * Status:
  * Block Format:
    * 1x (uint8): number of characters to follow.
    * Nx (char): characters of the alias.

---

* #### Block Code: 110
  * Block Definition: PRIMARY_MODULE
  * Description: "Primary module name, for systems with interchangeable modules."
  * Status:
  * Block Format:
    * 1x (uint8): number of characters to follow.
    * Nx (char): characters of the primary module name.

---


111,PRIMARY_INPUT,"Primary input name, for modules with multiple input signals.",(1x uint8 number of characters) - (Nx characters)
112,SAMD_CHIP_ID,The SAMD manufacturer's unique chip identifier.,(4x uint32)

120,ESP8266_MAC_ADDR,The MAC address of the device's ESP8266 module.,(6x uint8 MAC address)
121,ESP8266_IP4_ADDR,The local IPv4 address of the device's ESP8266 module.,(4x uint8)
122,ESP8266_CHIP_ID,The ESP8266 manufacturer's unique chip identifier,(1x uint32)
123,ESP8266_FLASH_ID,The ESP8266 flash chip's unique chip identifier,(1x uint32)

130,USER_SYSTEM_NAME,"The user's name for the system, i.e. booth number.",(1x uint16 number of characters) - (Nx characters)

140,DEVICE_RESET_COUNT,The current reboot count saved in EEPROM or flash memory.,(1x uint16)
141,CTRL_FW_FILENAME,"Controller firmware filename, copied from the macro, written as characters.",(1x uint8 number of characters) - (Nx characters)
142,CTRL_FW_DATE,"Controller firmware upload date, copied from the macro, written as characters.",(1x uint8 number of characters) - (Nx characters)
143,CTRL_FW_TIME,"Controller firmware upload time, copied from the macro, written as characters.",(1x uint8 number of characters) - (Nx characters)
144,MODULE_FW_FILENAME,"OTMP Module firmware filename, copied from the macro, written as characters.",(1x uint8 module index) - (1x uint8 number of characters) - (Nx characters)
145,MODULE_FW_DATE,"OTMP Module firmware upload date, copied from the macro, written as characters.",(1x uint8 module index) - (1x uint8 number of characters) - (Nx characters)
146,MODULE_FW_TIME,"OTMP Module firmware upload time, copied from the macro, written as characters.",(1x uint8 module index) - (1x uint8 number of characters) - (Nx characters)

150,WINC1500_MAC_ADDR,The MAC address of the device's ATWINC1500 module.,(6x uint8 MAC address)
151,WINC1500_IP4_ADDR,The local IPv4 address of the device's ATWINC1500 module.,(4x uint8)

170,BATTERY_SOC,"Current battery state-of charge, in percent, measured the BQ27441",(1x uint32 millisecond timestamp) - (1x uint16 state of charge)
171,BATTERY_VOLTS,"Current battery voltage, in millivolts, measured by the BQ27441",(1x uint32 millisecond timestamp) - (1x uint16 battery voltage)
172,BATTERY_CURRENT,"Average current draw from the battery, in milli-amps, measured by the BQ27441",(1x uint32 millisecond timestamp) - (1x int16 current draw)
173,BATTERY_FULL,"Full capacity of the battery, in milli-amp hours, measured by the BQ27441",(1x uint32 millisecond timestamp) - (1x uint16)
174,BATTERY_REMAIN,"Remaining capacity of the battery, in milli-amp hours, measured by the BQ27441",(1x uint32 millisecond timestamp) - (1x uint16)
175,BATTERY_POWER,"Average power draw, in milliWatts, measured by the BQ27441",(1x uint32 millisecond timestamp) - (1x int16)
176,BATTERY_SOH,"Battery state-of-health, in percent, measured by the BQ27441",(1x uint32 millisecond timestamp) - (1x int16)
177,BATTERY_STATUS,"Combined battery state-of-charge, voltage, current, capacity, power, and state-of-health, measured by the BQ27441","(1x uint32 millisecond timestamp) - (1x uint16 state-of-charge, in %) - (1x uint16 voltage, in mV) -(1x int16 current, in mA) - (1x uint16 full capacity, in mAh) - (1x uint16 remaining capacity, in mAh) - (1x int16 average power, in mW) - (1x int16 state-of-health, in %)"

190,FEED_SERVO_MAX_RPM,"Actual rotation rate, in RPM, of the feeder servo (OmniHome) when set to 180 speed.",(1x uint8 dispenser index) - (1x float32)
191,FEED_SERVO_SPEED,Current speed setting (0-180) for the feeder servo (OmniHome).,(1x uint8 dispenser index) - (1x uint8)
