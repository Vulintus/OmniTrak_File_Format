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

* #### Block Code: 111
  * Block Definition: PRIMARY_INPUT
  * Description: "Primary input name, for modules with multiple input signals."
  * Status:
  * Block Format:
    * 1x (uint8): number of characters to follow.
    * Nx (char): characters of the primary input name.

---

* #### Block Code: 112
  * Block Definition: SAMD_CHIP_ID
  * Description: "The unique chip identifier assigned and programmed to Atmel/Microchip SAMD microcontrollers during manufacturing."
  * Status:
  * Block Format:
    * 4x (uint32): blocks of the unique ID number.

---

* #### Block Code: 112
  * Block Definition: SAMD_CHIP_ID
  * Description: "The unique chip identifier assigned and programmed to Atmel/Microchip SAMD microcontrollers during manufacturing."
  * Status:
  * Block Format:
    * 4x (uint32): blocks of the unique ID number.

---

* #### Block Code: 120
  * Block Definition: WIFI_MAC_ADDR
  * Description: "The MAC address of the device's embedded WiFi module (formerly specific to the ESP8266, but now generalized to all systems with an embedded WiFi module)."
  * Status:
  * Block Format:
    * 6x (uint8): MAC address bytes.

---

* #### Block Code: 121
  * Block Definition: ESP8266_IP4_ADDR
  * Description: "The local IPv4 address of the device's embedded WiFi module (formerly specific to the ESP8266, but now generalized to all systems with an embedded WiFi module)."
  * Status:
  * Block Format:
    * 4x (uint8): fields of the IPv4 address.

---

* #### Block Code: 122
  * Block Definition: ESP8266_CHIP_ID
  * Description: "The ESP8266 manufacturer's unique chip identifier."
  * Status:
  * Block Format:
    * 1x (uint32): unique chip ID number.

---

* #### Block Code: 123
  * Block Definition: ESP8266_FLASH_ID
  * Description: "The ESP8266 flash chip's unique chip identifier."
  * Block Format:
    * 1x (uint32): unique chip ID number.

---

* #### Block Code: 130
  * Block Definition: USER_SYSTEM_NAME
  * Description: "The user's name for the system, i.e. cage/booth/arena number."
  * Status:
  * Block Format:
    * 1x (uint16): number of characters to follow.
    * Nx (char): characters of the user's name for the system.

---

* #### Block Code: 140
  * Block Definition: DEVICE_RESET_COUNT
  * Description: "The current reboot count saved in EEPROM or flash memory."
  * Status:
  * Block Format:
    * 1x (uint16): Number of reboots since programming, or since the last memory wipe.

---

* #### Block Code: 141
  * Block Definition: CTRL_FW_FILENAME
  * Description: "Controller firmware filename, copied from the macro, written as characters."
  * Status:
  * Block Format:
    * 1x (uint8): number of characters to follow.
    * Nx (char): characters of firmware filename.

---

* #### Block Code: 142
  * Block Definition: CTRL_FW_DATE
  * Description: "Controller firmware upload date, copied from the macro, written as characters."
  * Status:
  * Block Format:
    * 1x (uint8): number of characters to follow.
    * Nx (char): characters of firmware upload date.

---

* #### Block Code: 143
  * Block Definition: CTRL_FW_TIME
  * Description: "Controller firmware upload time, copied from the macro, written as characters."
  * Status:
  * Block Format:
    * 1x (uint8): number of characters to follow.
    * Nx (char): characters of firmware upload time.

---

* #### Block Code: 144
  * Block Definition: MODULE_FW_FILENAME
  * Description: "OTMP Module firmware filename, copied from the macro, written as characters."
  * Block Format:
    * 1x (uint8): module index.
    * 1x (uint8): number of characters to follow.
    * Nx (char): characters of the module firmware filename.

---

* #### Block Code: 145
  * Block Definition: MODULE_FW_DATE
  * Description: "OTMP Module firmware upload date, copied from the macro, written as characters."
  * Status:
  * Block Format:
    * 1x (uint8): module index.
    * 1x (uint8): number of characters to follow.
    * Nx (char): characters of the module firmware upload date.

---

* #### Block Code: 146
  * Block Definition: MODULE_FW_TIME
  * Description: "OTMP Module firmware upload time, copied from the macro, written as characters."
  * Status:
  * Block Format:
    * 1x (uint8): module index.
    * 1x (uint8): number of characters to follow.
    * Nx (char): characters of the module firmware upload time.

---

* #### Block Code: 150
  * Block Definition: ~~WINC1500_MAC_ADDR_DEPRECATED~~
  * Description: "The MAC address of the device's ATWINC1500 module."
  * Status: "**Deprecated.** Do not use in new programs. The WiFi MAC address is now written under block code 120 irrespective of the WiFi module make/model."
  * Block Format:
    * 6x (uint8): MAC address bytes.

---

* #### Block Code: 151
  * Block Definition: ~~WINC1500_IP4_ADDR_DEPRECATED~~
  * Description: "The local IPv4 address of the device's ATWINC1500 module."
  * Status: "**Deprecated.** Do not use in new programs. The WiFi IP4 address is now written under block code 121 irrespective of the WiFi module make/model."
  * Block Format:
    * 4x (uint8): fields of the IPv4 address.

---

* #### Block Code: 170
  * Block Definition: BATTERY_SOC
  * Description: "Current battery state-of-charge, in percent, typically measured by the BQ27441 in Vulintus devices."
  * Status:
  * Block Format:
    * 1x (uint32): millisecond timestamp.
    * 1x (uint16): state of charge, in percent. **WHY IS THIS A uint16?**

---

* #### Block Code: 171
  * Block Definition: BATTERY_VOLTS
  * Description: "Current battery voltage, in millivolts, typically measured by the BQ27441 in Vulintus devices."
  * Status:
  * Block Format:
    * 1x (uint32): millisecond timestamp.
    * 1x (uint16): battery voltage, in millivolts.

---

* #### Block Code: 172
  * Block Definition: BATTERY_CURRENT
  * Description: "Average current draw from the battery, in milli-amps, typically measured by the BQ27441 in Vulintus devices."
  * Status:
  * Block Format:
    * 1x (uint32): millisecond timestamp.
    * 1x (int16): current draw, in milli-amps, can be positive or negative depending on the charging/discharging status.

---

* #### Block Code: 173
  * Block Definition: BATTERY_FULL
  * Description: "Full capacity of the battery, in milli-amp hours, typically measured by the BQ27441 in Vulintus devices."
  * Status:
  * Block Format:
    * 1x (uint32): millisecond timestamp.
    * 1x (int16): full battery capacity, in milli-amp hours.

---

* #### Block Code: 174
  * Block Definition: BATTERY_REMAIN
  * Description: "Remaining capacity of the battery, in milli-amp hours, typically measured by the BQ27441 in Vulintus devices."
  * Status:
  * Block Format:
    * 1x (uint32): millisecond timestamp.
    * 1x (uint16): remaining battery capacity, in milli-amp hours.

---

* #### Block Code: 175
  * Block Definition: BATTERY_POWER
  * Description: "Average power draw, in milliWatts, typically measured by the BQ27441 in Vulintus devices."
  * Status:
  * Block Format:
    * 1x (uint32): millisecond timestamp.
    * 1x (int16): average power draw, in milliWatts, can be positive or negative depending on the charging/discharging status.

---

* #### Block Code: 176
  * Block Definition: BATTERY_SOH
  * Description: "Battery state-of-health, in percent, typically measured by the BQ27441 in Vulintus devices."
  * Status:
  * Block Format:
    * 1x (uint32): millisecond timestamp.
    * 1x (uint16): battery state-of-health, in percent.  **WHY IS THIS A uint16?**

---

* #### Block Code: 177
  * Block Definition: BATTERY_STATUS
  * Description: "Combined battery state-of-charge, voltage, current, capacity, power, and state-of-health, typically measured by the BQ27441 in Vulintus devices."
  * Status:
  * Block Format:
    * 1x (uint32): millisecond timestamp.
    * 1x (uint16): state of charge, in percent.
    * 1x (uint16): battery voltage, in millivolts.
    * 1x (int16): current draw, in milli-amps, can be positive or negative depending on the charging/discharging status.
    * 1x (uint16): full battery capacity, in milli-amp hours.
    * 1x (uint16): remaining battery capacity, in milli-amp hours.
    * 1x (int16): average power draw, in milliWatts, can be positive or negative depending on the charging/discharging status.
    * 1x (uint16): battery state-of-health, in percent.

---

* #### Block Code: 190
  * Block Definition: FEED_SERVO_MAX_RPM
  * Description: "Maximum rotation rate, in RPM, of the feeder disc. In OmniHome devices, this is measured when the servo is set to 180 speed."
  * Status:
  * Block Format:
    * 1x (uint8): dispenser index.
    * 1x (float32): rotation speed, in RPM.

---

* #### Block Code: 191
  * Block Definition: FEED_SERVO_SPEED
  * Description: "Current speed setting (0-180) for the feeder servo (OmniHome)."
  * Status:
  * Block Format:
    * 1x (uint8): dispenser index.
    * 1x (uint8): servo speed setting, 0-180.

---
