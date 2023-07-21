## Recording Device And System Information Data Blocks

---

| Block Code (uint16) | Definition Name | Description |
| - | - | - |
| 100 | [SYSTEM_TYPE](#block-code-100) | Vulintus system ID code (1 = MotoTrak, 2 = OmniTrak, 3 = HabiTrak, 4 = OmniHome, 5 = SensiTrak, 6 = Prototype). |
| 101 | [SYSTEM_NAME](#block-code-101) | System name. |
| 102 | [SYSTEM_HW_VER](#block-code-102) | Vulintus system hardware version. |
| 103 | [SYSTEM_FW_VER](#block-code-103) | System firmware version, written as characters. |
| 104 | [SYSTEM_SN](#block-code-104) | System serial number, written as characters. |
| 105 | [SYSTEM_MFR](#block-code-105) | Manufacturer name for non-Vulintus systems. |
| 106 | [COMPUTER_NAME](#block-code-106) | Windows PC computer name. |
| 107 | [COM_PORT](#block-code-107) | The COM port of a computer-connected system. |
| 108 | [DEVICE_ALIAS](#block-code-108) | Human-readable Adjective + Noun alias/name for the device, assigned by Vulintus during manufacturing |
| 110 | [PRIMARY_MODULE](#block-code-110) | Primary module name, for systems with interchangeable modules. |
| 111 | [PRIMARY_INPUT](#block-code-111) | Primary input name, for modules with multiple input signals. |
| 112 | [SAMD_CHIP_ID](#block-code-112) | The SAMD manufacturer's unique chip identifier. |
| 120 | [ESP8266_MAC_ADDR](#block-code-120) | The MAC address of the device's ESP8266 module. |
| 121 | [ESP8266_IP4_ADDR](#block-code-121) | The local IPv4 address of the device's ESP8266 module. |
| 122 | [ESP8266_CHIP_ID](#block-code-122) | The ESP8266 manufacturer's unique chip identifier |
| 123 | [ESP8266_FLASH_ID](#block-code-123) | The ESP8266 flash chip's unique chip identifier |
| 130 | [USER_SYSTEM_NAME](#block-code-130) | The user's name for the system, i.e. booth number. |
| 140 | [DEVICE_RESET_COUNT](#block-code-140) | The current reboot count saved in EEPROM or flash memory. |
| 141 | [CTRL_FW_FILENAME](#block-code-141) | Controller firmware filename, copied from the macro, written as characters. |
| 142 | [CTRL_FW_DATE](#block-code-142) | Controller firmware upload date, copied from the macro, written as characters. |
| 143 | [CTRL_FW_TIME](#block-code-143) | Controller firmware upload time, copied from the macro, written as characters. |
| 144 | [MODULE_FW_FILENAME](#block-code-144) | OTMP Module firmware filename, copied from the macro, written as characters. |
| 145 | [MODULE_FW_DATE](#block-code-145) | OTMP Module firmware upload date, copied from the macro, written as characters. |
| 146 | [MODULE_FW_TIME](#block-code-146) | OTMP Module firmware upload time, copied from the macro, written as characters. |
| 150 | [WINC1500_MAC_ADDR](#block-code-150) | The MAC address of the device's ATWINC1500 module. |
| 151 | [WINC1500_IP4_ADDR](#block-code-151) | The local IPv4 address of the device's ATWINC1500 module. |
| 170 | [BATTERY_SOC](#block-code-170) | Current battery state-of charge, in percent, measured the BQ27441 |
| 171 | [BATTERY_VOLTS](#block-code-171) | Current battery voltage, in millivolts, measured by the BQ27441 |
| 172 | [BATTERY_CURRENT](#block-code-172) | Average current draw from the battery, in milli-amps, measured by the BQ27441 |
| 173 | [BATTERY_FULL](#block-code-173) | Full capacity of the battery, in milli-amp hours, measured by the BQ27441 |
| 174 | [BATTERY_REMAIN](#block-code-174) | Remaining capacity of the battery, in milli-amp hours, measured by the BQ27441 |
| 175 | [BATTERY_POWER](#block-code-175) | Average power draw, in milliWatts, measured by the BQ27441 |
| 176 | [BATTERY_SOH](#block-code-176) | Battery state-of-health, in percent, measured by the BQ27441 |
| 177 | [BATTERY_STATUS](#block-code-177) | Combined battery state-of-charge, voltage, current, capacity, power, and state-of-health, measured by the BQ27441 |
| 190 | [FEED_SERVO_MAX_RPM](#block-code-190) | Actual rotation rate, in RPM, of the feeder servo (OmniHome) when set to 180 speed. |
| 191 | [FEED_SERVO_SPEED](#block-code-191) | Current speed setting (0-180) for the feeder servo (OmniHome). |

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
