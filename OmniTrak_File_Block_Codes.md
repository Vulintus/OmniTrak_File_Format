## *.OmniTrak File Block Codes (OFBC)

### Principal Data Block Code List

This is the principal list for *.OmniTrak File Block Codes (OFBC) data block codes. Values set in the following table will override and overwrite any changes made to any other file. **Edit this document first when adding new block codes.**

---

<!---The immediately following comment is necessary for programmatic library generation. DO NOT DELETE IT!--->
<!---table starts below--->
| Block Code (hex) | Block Code (uint16) | Definition Name | Description | MATLAB Scripts |
| :---: | :---: | :--- | :--- | :--- |
| 0xABCD | 43981 | [OMNITRAK_FILE_VERIFY](/Data%20Block%20Descriptions/0xAB00-0xABFF.md#block-code-0xABCD) | First unsigned 16-bit integer written to every *.OmniTrak file to identify the file type, has a hex value of 0xABCD. |
| 0x0001 | 1 | [FILE_VERSION](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0001) | The version of the file format used. |
| 0x0002 | 2 | [MS_FILE_START](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0002) | Value of the SoC millisecond clock at file creation. |
| 0x0003 | 3 | [MS_FILE_STOP](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0003) | Value of the SoC millisecond clock when the file is closed. |
| 0x0004 | 4 | [SUBJECT_DEPRECATED](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0004) | A single subject's name. |
||
||
| 0x0006 | 6 | [CLOCK_FILE_START](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0006) | Computer clock serial date number at file creation (local time). |
| 0x0007 | 7 | [CLOCK_FILE_STOP](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0007) | Computer clock serial date number when the file is closed (local time). |
||
||
| 0x000A | 10 | [DEVICE_FILE_INDEX](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x000A) | The device's current file index. |
||
||
| 0x0014 | 20 | [NTP_SYNC](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0014) | A fetched NTP time (seconds since January 1, 1900) at the specified SoC millisecond clock time. |
| 0x0015 | 21 | [NTP_SYNC_FAIL](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0015) | Indicates the an NTP synchonization attempt failed. |
| 0x0016 | 22 | [CLOCK_SYNC](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0016) | The current serial date number, millisecond clock reading, and/or microsecond clock reading at a single timepoint. |
| 0x0017 | 23 | [MS_TIMER_ROLLOVER](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0017) | Indicates that the millisecond timer rolled over since the last loop. |
| 0x0018 | 24 | [US_TIMER_ROLLOVER](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0018) | Indicates that the microsecond timer rolled over since the last loop. |
| 0x0019 | 25 | [TIME_ZONE_OFFSET](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0019) | Computer clock time zone offset from UTC. |
| 0x001A | 26 | [TIME_ZONE_OFFSET_HHMM](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x001A) | Computer clock time zone offset from UTC as two integers, one for hours, and the other for minutes |
||
||
| 0x001E | 30 | [RTC_STRING_DEPRECATED](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x001E) | Current date/time string from the real-time clock. |
| 0x001F | 31 | [RTC_STRING](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x001F) | Current date/time string from the real-time clock. |
| 0x0020 | 32 | [RTC_VALUES](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0020) | Current date/time values from the real-time clock. |
||
||
| 0x0028 | 40 | [ORIGINAL_FILENAME](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0028) | The original filename for the data file. |
| 0x0029 | 41 | [RENAMED_FILE](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0029) | A timestamped event to indicate when a file has been renamed by one of Vulintus' automatic data organizing programs. |
| 0x002A | 42 | [DOWNLOAD_TIME](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x002A) | A timestamp indicating when the data file was downloaded from the OmniTrak device to a computer. |
| 0x002B | 43 | [DOWNLOAD_SYSTEM](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x002B) | The computer system name and the COM port used to download the data file form the OmniTrak device. |
||
||
| 0x0032 | 50 | [INCOMPLETE_BLOCK](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0032) | Indicates that the file will end in an incomplete block. |
||
||
| 0x003C | 60 | [USER_TIME](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x003C) | Date/time values from a user-set timestamp. |
||
||
| 0x0064 | 100 | [SYSTEM_TYPE](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0064) | Vulintus system ID code (1 = MotoTrak, 2 = OmniTrak, 3 = HabiTrak, 4 = OmniHome, 5 = SensiTrak, 6 = Prototype). |
| 0x0065 | 101 | [SYSTEM_NAME](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0065) | Vulintus system name. |
| 0x0066 | 102 | [SYSTEM_HW_VER](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0066) | Vulintus system hardware version. |
| 0x0067 | 103 | [SYSTEM_FW_VER](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0067) | System firmware version, written as characters. |
| 0x0068 | 104 | [SYSTEM_SN](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0068) | System serial number, written as characters. |
| 0x0069 | 105 | [SYSTEM_MFR](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0069) | Manufacturer name for non-Vulintus systems. |
| 0x006A | 106 | [COMPUTER_NAME](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x006A) | Windows PC computer name. |
| 0x006B | 107 | [COM_PORT](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x006B) | The COM port of a computer-connected system. |
| 0x006C | 108 | [DEVICE_ALIAS](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x006C) | Human-readable Adjective + Noun alias/name for the device, assigned by Vulintus during manufacturing |
||
||
| 0x006E | 110 | [PRIMARY_MODULE](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x006E) | Primary module name, for systems with interchangeable modules. |
| 0x006F | 111 | [PRIMARY_INPUT](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x006F) | Primary input name, for modules with multiple input signals. |
| 0x0070 | 112 | [SAMD_CHIP_ID](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0070) | The SAMD manufacturer's unique chip identifier. |
||
||
| 0x0078 | 120 | [ESP8266_MAC_ADDR](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0078) | The MAC address of the device's ESP8266 module. |
| 0x0079 | 121 | [ESP8266_IP4_ADDR](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0079) | The local IPv4 address of the device's ESP8266 module. |
| 0x007A | 122 | [ESP8266_CHIP_ID](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x007A) | The ESP8266 manufacturer's unique chip identifier |
| 0x007B | 123 | [ESP8266_FLASH_ID](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x007B) | The ESP8266 flash chip's unique chip identifier |
||
||
| 0x0082 | 130 | [USER_SYSTEM_NAME](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0082) | The user's name for the system, i.e. booth number. |
||
||
| 0x008C | 140 | [DEVICE_RESET_COUNT](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x008C) | The current reboot count saved in EEPROM or flash memory. |
| 0x008D | 141 | [CTRL_FW_FILENAME](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x008D) | Controller firmware filename, copied from the macro, written as characters. |
| 0x008E | 142 | [CTRL_FW_DATE](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x008E) | Controller firmware upload date, copied from the macro, written as characters. |
| 0x008F | 143 | [CTRL_FW_TIME](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x008F) | Controller firmware upload time, copied from the macro, written as characters. |
| 0x0090 | 144 | [MODULE_FW_FILENAME](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0090) | OTMP Module firmware filename, copied from the macro, written as characters. |
| 0x0091 | 145 | [MODULE_FW_DATE](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0091) | OTMP Module firmware upload date, copied from the macro, written as characters. |
| 0x0092 | 146 | [MODULE_FW_TIME](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0092) | OTMP Module firmware upload time, copied from the macro, written as characters. |
||
||
| 0x0096 | 150 | [WINC1500_MAC_ADDR](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0096) | The MAC address of the device's ATWINC1500 module. |
| 0x0097 | 151 | [WINC1500_IP4_ADDR](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x0097) | The local IPv4 address of the device's ATWINC1500 module. |
||
||
| 0x00AA | 170 | [BATTERY_SOC](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x00AA) | Current battery state-of charge, in percent, measured the BQ27441 |
| 0x00AB | 171 | [BATTERY_VOLTS](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x00AB) | Current battery voltage, in millivolts, measured by the BQ27441 |
| 0x00AC | 172 | [BATTERY_CURRENT](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x00AC) | Average current draw from the battery, in milli-amps, measured by the BQ27441 |
| 0x00AD | 173 | [BATTERY_FULL](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x00AD) | Full capacity of the battery, in milli-amp hours, measured by the BQ27441 |
| 0x00AE | 174 | [BATTERY_REMAIN](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x00AE) | Remaining capacity of the battery, in milli-amp hours, measured by the BQ27441 |
| 0x00AF | 175 | [BATTERY_POWER](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x00AF) | Average power draw, in milliWatts, measured by the BQ27441 |
| 0x00B0 | 176 | [BATTERY_SOH](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x00B0) | Battery state-of-health, in percent, measured by the BQ27441 |
| 0x00B1 | 177 | [BATTERY_STATUS](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x00B1) | Combined battery state-of-charge, voltage, current, capacity, power, and state-of-health, measured by the BQ27441 |
||
||
| 0x00BE | 190 | [FEED_SERVO_MAX_RPM](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x00BE) | Actual rotation rate, in RPM, of the feeder servo (OmniHome) when set to 180 speed. |
| 0x00BF | 191 | [FEED_SERVO_SPEED](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x00BF) | Current speed setting (0-180) for the feeder servo (OmniHome). |
||
||
| 0x00C8 | 200 | [SUBJECT_NAME](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x00C8) | A single subject's name. |
| 0x00C9 | 201 | [GROUP_NAME](/Data%20Block%20Descriptions/0x0000-0x00FF.md#block-code-0x00C9) | The subject's or subjects' experimental group name. |
||
||
| 0x012C | 300 | [EXP_NAME](/Data%20Block%20Descriptions/0x0100-0x01FF.md#block-code-0x012C) | The user's name for the current experiment. |
| 0x012D | 301 | [TASK_TYPE](/Data%20Block%20Descriptions/0x0100-0x01FF.md#block-code-0x012D) | The user's name for task type, which can be a variant of the overall experiment type. |
||
||
| 0x0190 | 400 | [STAGE_NAME](/Data%20Block%20Descriptions/0x0100-0x01FF.md#block-code-0x0190) | The stage name for a behavioral session. |
| 0x0191 | 401 | [STAGE_DESCRIPTION](/Data%20Block%20Descriptions/0x0100-0x01FF.md#block-code-0x0191) | The stage description for a behavioral session. |
||
||
| 0x03E8 | 1000 | [AMG8833_ENABLED](/Data%20Block%20Descriptions/0x0300-0x03FF.md#block-code-0x03E8) | Indicates that an AMG8833 thermopile array sensor is present in the system. |
| 0x03E9 | 1001 | [BMP280_ENABLED](/Data%20Block%20Descriptions/0x0300-0x03FF.md#block-code-0x03E9) | Indicates that an BMP280 temperature/pressure sensor is present in the system. |
| 0x03EA | 1002 | [BME280_ENABLED](/Data%20Block%20Descriptions/0x0300-0x03FF.md#block-code-0x03EA) | Indicates that an BME280 temperature/pressure/humidty sensor is present in the system. |
| 0x03EB | 1003 | [BME680_ENABLED](/Data%20Block%20Descriptions/0x0300-0x03FF.md#block-code-0x03EB) | Indicates that an BME680 temperature/pressure/humidy/VOC sensor is present in the system. |
| 0x03EC | 1004 | [CCS811_ENABLED](/Data%20Block%20Descriptions/0x0300-0x03FF.md#block-code-0x03EC) | Indicates that an CCS811 VOC/eC02 sensor is present in the system. |
| 0x03ED | 1005 | [SGP30_ENABLED](/Data%20Block%20Descriptions/0x0300-0x03FF.md#block-code-0x03ED) | Indicates that an SGP30 VOC/eC02 sensor is present in the system. |
| 0x03EE | 1006 | [VL53L0X_ENABLED](/Data%20Block%20Descriptions/0x0300-0x03FF.md#block-code-0x03EE) | Indicates that an VL53L0X time-of-flight distance sensor is present in the system. |
| 0x03EF | 1007 | [ALSPT19_ENABLED](/Data%20Block%20Descriptions/0x0300-0x03FF.md#block-code-0x03EF) | Indicates that an ALS-PT19 ambient light sensor is present in the system. |
| 0x03F0 | 1008 | [MLX90640_ENABLED](/Data%20Block%20Descriptions/0x0300-0x03FF.md#block-code-0x03F0) | Indicates that an MLX90640 thermopile array sensor is present in the system. |
| 0x03F1 | 1009 | [ZMOD4410_ENABLED](/Data%20Block%20Descriptions/0x0300-0x03FF.md#block-code-0x03F1) | Indicates that an ZMOD4410 VOC/eC02 sensor is present in the system. |
||
||
| 0x0400 | 1024 | [AMBULATION_XY_THETA](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x0400) | A point in a tracked ambulation path, with absolute x- and y-coordinates in millimeters, with facing direction theta, in degrees. |
||
||
| 0x044C | 1100 | [AMG8833_THERM_CONV](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x044C) | The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature. |
| 0x044D | 1101 | [AMG8833_THERM_FL](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x044D) | The current AMG8833 thermistor reading as a converted float32 value, in Celsius. |
| 0x044E | 1102 | [AMG8833_THERM_INT](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x044E) | The current AMG8833 thermistor reading as a raw, signed 16-bit integer. |
||
||
| 0x0456 | 1110 | [AMG8833_PIXELS_CONV](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x0456) | The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature. |
| 0x0457 | 1111 | [AMG8833_PIXELS_FL](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x0457) | The current AMG8833 pixel readings as converted float32 values, in Celsius. |
| 0x0458 | 1112 | [AMG8833_PIXELS_INT](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x0458) | The current AMG8833 pixel readings as a raw, signed 16-bit integers. |
| 0x0459 | 1113 | [HTPA32X32_PIXELS_FP62](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x0459) | The current HTPA32x32 pixel readings as a fixed-point 6/2 type (6 bits for the unsigned integer part, 2 bits for the decimal part), in units of Celcius. This allows temperatures from 0 to 63.75 C. |
| 0x045A | 1114 | [HTPA32X32_PIXELS_INT_K](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x045A) | The current HTPA32x32 pixel readings represented as 16-bit unsigned integers in units of deciKelvin (dK, or Kelvin * 10). |
| 0x045B | 1115 | [HTPA32X32_AMBIENT_TEMP](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x045B) | The current ambient temperature measured by the HTPA32x32, represented as a 32-bit float, in units of Celcius. |
| 0x045C | 1116 | [HTPA32X32_PIXELS_INT12_C](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x045C) | The current HTPA32x32 pixel readings represented as 12-bit signed integers (2 pixels for every 3 bytes) in units of deciCelsius (dC, or Celsius * 10), with values under-range set to the minimum  (2048 dC) and values over-range set to the maximum (2047 dC). |
| 0x045D | 1117 | [HTPA32X32_HOTTEST_PIXEL_FP62](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x045D) | The location and temperature of the hottest pixel in the HTPA32x32 image. This may not be the raw hottest pixel. It may have gone through some processing and filtering to determine the true hottest pixel. The temperature will be in FP62 formatted Celsius. |
||
||
| 0x0460 | 1120 | [BH1749_RGB](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x0460) | The current red, green, blue, IR, and green2 sensor readings from the BH1749 sensor |
| 0x0461 | 1121 | [DEBUG_SANITY_CHECK](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x0461) | A special block acting as a sanity check, only used in cases of debugging |
||
||
| 0x04B0 | 1200 | [BME280_TEMP_FL](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x04B0) | The current BME280 temperature reading as a converted float32 value, in Celsius. |
| 0x04B1 | 1201 | [BMP280_TEMP_FL](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x04B1) | The current BMP280 temperature reading as a converted float32 value, in Celsius. |
| 0x04B2 | 1202 | [BME680_TEMP_FL](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x04B2) | The current BME680 temperature reading as a converted float32 value, in Celsius. |
||
||
| 0x04BA | 1210 | [BME280_PRES_FL](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x04BA) | The current BME280 pressure reading as a converted float32 value, in Pascals (Pa). |
| 0x04BB | 1211 | [BMP280_PRES_FL](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x04BB) | The current BMP280 pressure reading as a converted float32 value, in Pascals (Pa). |
| 0x04BC | 1212 | [BME680_PRES_FL](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x04BC) | The current BME680 pressure reading as a converted float32 value, in Pascals (Pa). |
||
||
| 0x04C4 | 1220 | [BME280_HUM_FL](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x04C4) | The current BM280 humidity reading as a converted float32 value, in percent (%). |
| 0x04C5 | 1221 | [BME680_HUM_FL](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x04C5) | The current BME680 humidity reading as a converted float32 value, in percent (%). |
||
||
| 0x04CE | 1230 | [BME680_GAS_FL](/Data%20Block%20Descriptions/0x0400-0x04FF.md#block-code-0x04CE) | The current BME680 gas resistance reading as a converted float32 value, in units of kOhms |
||
||
| 0x0514 | 1300 | [VL53L0X_DIST](/Data%20Block%20Descriptions/0x0500-0x05FF.md#block-code-0x0514) | The current VL53L0X distance reading as a 16-bit integer, in millimeters (-1 indicates out-of-range). |
| 0x0515 | 1301 | [VL53L0X_FAIL](/Data%20Block%20Descriptions/0x0500-0x05FF.md#block-code-0x0515) | Indicates the VL53L0X sensor experienced a range failure. |
||
||
| 0x0578 | 1400 | [SGP30_SN](/Data%20Block%20Descriptions/0x0500-0x05FF.md#block-code-0x0578) | The serial number of the SGP30. |
||
||
| 0x0582 | 1410 | [SGP30_EC02](/Data%20Block%20Descriptions/0x0500-0x05FF.md#block-code-0x0582) | The current SGp30 eCO2 reading distance reading as a 16-bit integer, in parts per million (ppm). |
||
||
| 0x058C | 1420 | [SGP30_TVOC](/Data%20Block%20Descriptions/0x0500-0x05FF.md#block-code-0x058C) | The current SGp30 TVOC reading distance reading as a 16-bit integer, in parts per million (ppm). |
||
||
| 0x05DC | 1500 | [MLX90640_DEVICE_ID](/Data%20Block%20Descriptions/0x0500-0x05FF.md#block-code-0x05DC) | The MLX90640 unique device ID saved in the device's EEPROM. |
| 0x05DD | 1501 | [MLX90640_EEPROM_DUMP](/Data%20Block%20Descriptions/0x0500-0x05FF.md#block-code-0x05DD) | Raw download of the entire MLX90640 EEPROM, as unsigned 16-bit integers. |
| 0x05DE | 1502 | [MLX90640_ADC_RES](/Data%20Block%20Descriptions/0x0500-0x05FF.md#block-code-0x05DE) | ADC resolution setting on the MLX90640 (16-, 17-, 18-, or 19-bit). |
| 0x05DF | 1503 | [MLX90640_REFRESH_RATE](/Data%20Block%20Descriptions/0x0500-0x05FF.md#block-code-0x05DF) | Current refresh rate on the MLX90640 (0.25, 0.5, 1, 2, 4, 8, 16, or 32 Hz). |
| 0x05E0 | 1504 | [MLX90640_I2C_CLOCKRATE](/Data%20Block%20Descriptions/0x0500-0x05FF.md#block-code-0x05E0) | Current I2C clock freqency used with the MLX90640 (100, 400, or 1000 kHz). |
||
||
| 0x05E6 | 1510 | [MLX90640_PIXELS_TO](/Data%20Block%20Descriptions/0x0500-0x05FF.md#block-code-0x05E6) | The current MLX90640 pixel readings as converted float32 values, in Celsius. |
| 0x05E7 | 1511 | [MLX90640_PIXELS_IM](/Data%20Block%20Descriptions/0x0500-0x05FF.md#block-code-0x05E7) | The current MLX90640 pixel readings as converted, but uncalibrationed, float32 values. |
| 0x05E8 | 1512 | [MLX90640_PIXELS_INT](/Data%20Block%20Descriptions/0x0500-0x05FF.md#block-code-0x05E8) | The current MLX90640 pixel readings as a raw, unsigned 16-bit integers. |
||
||
| 0x05F0 | 1520 | [MLX90640_I2C_TIME](/Data%20Block%20Descriptions/0x0500-0x05FF.md#block-code-0x05F0) | The I2C transfer time of the frame data from the MLX90640 to the microcontroller, in milliseconds. |
| 0x05F1 | 1521 | [MLX90640_CALC_TIME](/Data%20Block%20Descriptions/0x0500-0x05FF.md#block-code-0x05F1) | The calculation time for the uncalibrated or calibrated image captured by the MLX90640. |
| 0x05F2 | 1522 | [MLX90640_IM_WRITE_TIME](/Data%20Block%20Descriptions/0x0500-0x05FF.md#block-code-0x05F2) | The SD card write time for the MLX90640 float32 image data. |
| 0x05F3 | 1523 | [MLX90640_INT_WRITE_TIME](/Data%20Block%20Descriptions/0x0500-0x05FF.md#block-code-0x05F3) | The SD card write time for the MLX90640 raw uint16 data. |
||
||
| 0x0640 | 1600 | [ALSPT19_LIGHT](/Data%20Block%20Descriptions/0x0600-0x06FF.md#block-code-0x0640) | The current analog value of the ALS-PT19 ambient light sensor, as an unsigned integer ADC value. |
||
||
| 0x06A4 | 1700 | [ZMOD4410_MOX_BOUND](/Data%20Block%20Descriptions/0x0600-0x06FF.md#block-code-0x06A4) | The current lower and upper bounds for the ZMOD4410 ADC reading used in calculations. |
| 0x06A5 | 1701 | [ZMOD4410_CONFIG_PARAMS](/Data%20Block%20Descriptions/0x0600-0x06FF.md#block-code-0x06A5) | Current configuration values for the ZMOD4410. |
| 0x06A6 | 1702 | [ZMOD4410_ERROR](/Data%20Block%20Descriptions/0x0600-0x06FF.md#block-code-0x06A6) | Timestamped ZMOD4410 error event. |
| 0x06A7 | 1703 | [ZMOD4410_READING_FL](/Data%20Block%20Descriptions/0x0600-0x06FF.md#block-code-0x06A7) | Timestamped ZMOD4410 reading calibrated and converted to float32. |
| 0x06A8 | 1704 | [ZMOD4410_READING_INT](/Data%20Block%20Descriptions/0x0600-0x06FF.md#block-code-0x06A8) | Timestamped ZMOD4410 reading saved as the raw uint16 ADC value. |
||
||
| 0x06AE | 1710 | [ZMOD4410_ECO2](/Data%20Block%20Descriptions/0x0600-0x06FF.md#block-code-0x06AE) | Timestamped ZMOD4410 eCO2 reading. |
| 0x06AF | 1711 | [ZMOD4410_IAQ](/Data%20Block%20Descriptions/0x0600-0x06FF.md#block-code-0x06AF) | Timestamped ZMOD4410 indoor air quality reading. |
| 0x06B0 | 1712 | [ZMOD4410_TVOC](/Data%20Block%20Descriptions/0x0600-0x06FF.md#block-code-0x06B0) | Timestamped ZMOD4410 total volatile organic compound reading. |
| 0x06B1 | 1713 | [ZMOD4410_R_CDA](/Data%20Block%20Descriptions/0x0600-0x06FF.md#block-code-0x06B1) | Timestamped ZMOD4410 total volatile organic compound reading. |
||
||
| 0x0708 | 1800 | [LSM303_ACC_SETTINGS](/Data%20Block%20Descriptions/0x0700-0x07FF.md#block-code-0x0708) | Current accelerometer reading settings on any enabled LSM303. |
| 0x0709 | 1801 | [LSM303_MAG_SETTINGS](/Data%20Block%20Descriptions/0x0700-0x07FF.md#block-code-0x0709) | Current magnetometer reading settings on any enabled LSM303. |
| 0x070A | 1802 | [LSM303_ACC_FL](/Data%20Block%20Descriptions/0x0700-0x07FF.md#block-code-0x070A) | Current readings from the LSM303 accelerometer, as float values in m/s^2. |
| 0x070B | 1803 | [LSM303_MAG_FL](/Data%20Block%20Descriptions/0x0700-0x07FF.md#block-code-0x070B) | Current readings from the LSM303 magnetometer, as float values in uT. |
| 0x070C | 1804 | [LSM303_TEMP_FL](/Data%20Block%20Descriptions/0x0700-0x07FF.md#block-code-0x070C) | Current readings from the LSM303 temperature sensor, as float value in degrees Celcius |
||
||
| 0x076C | 1900 | [SPECTRO_WAVELEN](/Data%20Block%20Descriptions/0x0700-0x07FF.md#block-code-0x076C) | Spectrometer wavelengths, in nanometers. |
| 0x076D | 1901 | [SPECTRO_TRACE](/Data%20Block%20Descriptions/0x0700-0x07FF.md#block-code-0x076D) | Spectrometer measurement trace. |
||
||
| 0x07D0 | 2000 | [PELLET_DISPENSE](/Data%20Block%20Descriptions/0x0700-0x07FF.md#block-code-0x07D0) | Timestamped event for feeding/pellet dispensing. |
| 0x07D1 | 2001 | [PELLET_FAILURE](/Data%20Block%20Descriptions/0x0700-0x07FF.md#block-code-0x07D1) | Timestamped event for feeding/pellet dispensing in which no pellet was detected. |
||
||
| 0x07DA | 2010 | [HARD_PAUSE_START](/Data%20Block%20Descriptions/0x0700-0x07FF.md#block-code-0x07DA) | Timestamped event marker for the start of a session pause, with no events recorded during the pause. |
| 0x07DB | 2011 | [HARD_PAUSE_STOP](/Data%20Block%20Descriptions/0x0700-0x07FF.md#block-code-0x07DB) | Timestamped event marker for the stop of a session pause, with no events recorded during the pause. |
| 0x07DC | 2012 | [SOFT_PAUSE_START](/Data%20Block%20Descriptions/0x0700-0x07FF.md#block-code-0x07DC) | Timestamped event marker for the start of a session pause, with non-operant events recorded during the pause. |
| 0x07DD | 2013 | [SOFT_PAUSE_STOP](/Data%20Block%20Descriptions/0x0700-0x07FF.md#block-code-0x07DD) | Timestamped event marker for the stop of a session pause, with non-operant events recorded during the pause. |
| 0x07DE | 2014 | [TRIAL_START_SERIAL_DATE](/Data%20Block%20Descriptions/0x0700-0x07FF.md#block-code-0x07DE) | Timestamped event marker for the start of a trial, with accompanying microsecond clock reading |
||
||
| 0x07E4 | 2020 | [POSITION_START_X](/Data%20Block%20Descriptions/0x0700-0x07FF.md#block-code-0x07E4) | Starting position of an autopositioner in just the x-direction, with distance in millimeters. |
| 0x07E5 | 2021 | [POSITION_MOVE_X](/Data%20Block%20Descriptions/0x0700-0x07FF.md#block-code-0x07E5) | Timestamped movement of an autopositioner in just the x-direction, with distance in millimeters. |
| 0x07E6 | 2022 | [POSITION_START_XY](/Data%20Block%20Descriptions/0x0700-0x07FF.md#block-code-0x07E6) | Starting position of an autopositioner in just the x- and y-directions, with distance in millimeters. |
| 0x07E7 | 2023 | [POSITION_MOVE_XY](/Data%20Block%20Descriptions/0x0700-0x07FF.md#block-code-0x07E7) | Timestamped movement of an autopositioner in just the x- and y-directions, with distance in millimeters. |
| 0x07E8 | 2024 | [POSITION_START_XYZ](/Data%20Block%20Descriptions/0x0700-0x07FF.md#block-code-0x07E8) | Starting position of an autopositioner in the x-, y-, and z- directions, with distance in millimeters. |
| 0x07E9 | 2025 | [POSITION_MOVE_XYZ](/Data%20Block%20Descriptions/0x0700-0x07FF.md#block-code-0x07E9) | Timestamped movement of an autopositioner in the x-, y-, and z- directions, with distance in millimeters. |
||
||
| 0x0800 | 2048 | [TTL_PULSE](/Data%20Block%20Descriptions/0x0800-0x08FF.md#block-code-0x0800) | Timestamped event for a TTL pulse output, with channel number, voltage, and duration. |
||
||
| 0x0834 | 2100 | [STREAM_INPUT_NAME](/Data%20Block%20Descriptions/0x0800-0x08FF.md#block-code-0x0834) | Stream input name for the specified input index. |
||
||
| 0x0898 | 2200 | [CALIBRATION_BASELINE](/Data%20Block%20Descriptions/0x0800-0x08FF.md#block-code-0x0898) | Starting calibration baseline coefficient, for the specified module index. |
| 0x0899 | 2201 | [CALIBRATION_SLOPE](/Data%20Block%20Descriptions/0x0800-0x08FF.md#block-code-0x0899) | Starting calibration slope coefficient, for the specified module index. |
| 0x089A | 2202 | [CALIBRATION_BASELINE_ADJUST](/Data%20Block%20Descriptions/0x0800-0x08FF.md#block-code-0x089A) | Timestamped in-session calibration baseline coefficient adjustment, for the specified module index. |
| 0x089B | 2203 | [CALIBRATION_SLOPE_ADJUST](/Data%20Block%20Descriptions/0x0800-0x08FF.md#block-code-0x089B) | Timestamped in-session calibration slope coefficient adjustment, for the specified module index. |
||
||
| 0x08FC | 2300 | [HIT_THRESH_TYPE](/Data%20Block%20Descriptions/0x0800-0x08FF.md#block-code-0x08FC) | Type of hit threshold (i.e. peak force), for the specified input. |
||
||
| 0x0906 | 2310 | [SECONDARY_THRESH_NAME](/Data%20Block%20Descriptions/0x0900-0x09FF.md#block-code-0x0906) | A name/description of secondary thresholds used in the behavior. |
||
||
| 0x0910 | 2320 | [INIT_THRESH_TYPE](/Data%20Block%20Descriptions/0x0900-0x09FF.md#block-code-0x0910) | Type of initation threshold (i.e. force or touch), for the specified input. |
||
||
| 0x0960 | 2400 | [REMOTE_MANUAL_FEED](/Data%20Block%20Descriptions/0x0900-0x09FF.md#block-code-0x0960) | A timestamped manual feed event, triggered remotely. |
| 0x0961 | 2401 | [HWUI_MANUAL_FEED](/Data%20Block%20Descriptions/0x0900-0x09FF.md#block-code-0x0961) | A timestamped manual feed event, triggered from the hardware user interface. |
| 0x0962 | 2402 | [FW_RANDOM_FEED](/Data%20Block%20Descriptions/0x0900-0x09FF.md#block-code-0x0962) | A timestamped manual feed event, triggered randomly by the firmware. |
| 0x0963 | 2403 | [SWUI_MANUAL_FEED_DEPRECATED](/Data%20Block%20Descriptions/0x0900-0x09FF.md#block-code-0x0963) | A timestamped manual feed event, triggered from a computer software user interface. |
| 0x0964 | 2404 | [FW_OPERANT_FEED](/Data%20Block%20Descriptions/0x0900-0x09FF.md#block-code-0x0964) | A timestamped operant-rewarded feed event, trigged by the OmniHome firmware, with the possibility of multiple feedings. |
| 0x0965 | 2405 | [SWUI_MANUAL_FEED](/Data%20Block%20Descriptions/0x0900-0x09FF.md#block-code-0x0965) | A timestamped manual feed event, triggered from a computer software user interface. |
| 0x0966 | 2406 | [SW_RANDOM_FEED](/Data%20Block%20Descriptions/0x0900-0x09FF.md#block-code-0x0966) | A timestamped manual feed event, triggered randomly by computer software. |
| 0x0967 | 2407 | [SW_OPERANT_FEED](/Data%20Block%20Descriptions/0x0900-0x09FF.md#block-code-0x0967) | A timestamped operant-rewarded feed event, trigged by the PC-based behavioral software, with the possibility of multiple feedings. |
||
||
| 0x09C4 | 2500 | [MOTOTRAK_V3P0_OUTCOME](/Data%20Block%20Descriptions/0x0900-0x09FF.md#block-code-0x09C4) | MotoTrak version 3.0 trial outcome data. |
| 0x09C5 | 2501 | [MOTOTRAK_V3P0_SIGNAL](/Data%20Block%20Descriptions/0x0900-0x09FF.md#block-code-0x09C5) | MotoTrak version 3.0 trial stream signal. |
||
||
| 0x0A00 | 2560 | [POKE_BITMASK](/Data%20Block%20Descriptions/0x0A00-0x0AFF.md#block-code-0x0A00) | Nosepoke status bitmask, typically written only when it changes. |
||
||
| 0x0A28 | 2600 | [OUTPUT_TRIGGER_NAME](/Data%20Block%20Descriptions/0x0A00-0x0AFF.md#block-code-0x0A28) | Name/description of the output trigger type for the given index. |
||
||
| 0x0A8C | 2700 | [VIBRATION_TASK_TRIAL_OUTCOME](/Data%20Block%20Descriptions/0x0A00-0x0AFF.md#block-code-0x0A8C) | Vibration task trial outcome data. |
| 0x0A8D | 2701 | [VIBROTACTILE_DETECTION_TASK_TRIAL](/Data%20Block%20Descriptions/0x0A00-0x0AFF.md#block-code-0x0A8D) | Vibrotactile detection task trial data. |
||
||
| 0x0A96 | 2710 | [LED_DETECTION_TASK_TRIAL_OUTCOME](/Data%20Block%20Descriptions/0x0A00-0x0AFF.md#block-code-0x0A96) | LED detection task trial outcome data. |
| 0x0A97 | 2711 | [LIGHT_SRC_MODEL](/Data%20Block%20Descriptions/0x0A00-0x0AFF.md#block-code-0x0A97) | Light source model name. |
| 0x0A98 | 2712 | [LIGHT_SRC_TYPE](/Data%20Block%20Descriptions/0x0A00-0x0AFF.md#block-code-0x0A98) | Light source type (i.e. LED, LASER, etc). |
||
||
| 0x0AA0 | 2720 | [STTC_2AFC_TRIAL_OUTCOME](/Data%20Block%20Descriptions/0x0A00-0x0AFF.md#block-code-0x0AA0) | SensiTrak tactile discrimination task trial outcome data. |
| 0x0AA1 | 2721 | [STTC_NUM_PADS](/Data%20Block%20Descriptions/0x0A00-0x0AFF.md#block-code-0x0AA1) | Number of pads on the SensiTrak Tactile Carousel module. |
| 0x0AA2 | 2722 | [MODULE_MICROSTEP](/Data%20Block%20Descriptions/0x0A00-0x0AFF.md#block-code-0x0AA2) | Microstep setting on the specified OTMP module. |
| 0x0AA3 | 2723 | [MODULE_STEPS_PER_ROT](/Data%20Block%20Descriptions/0x0A00-0x0AFF.md#block-code-0x0AA3) | Steps per rotation on the specified OTMP module. |
||
||
| 0x0AAA | 2730 | [MODULE_PITCH_CIRC](/Data%20Block%20Descriptions/0x0A00-0x0AFF.md#block-code-0x0AAA) | Pitch circumference, in millimeters, of the driving gear on the specified OTMP module. |
| 0x0AAB | 2731 | [MODULE_CENTER_OFFSET](/Data%20Block%20Descriptions/0x0A00-0x0AFF.md#block-code-0x0AAB) | Center offset, in millimeters, for the specified OTMP module. |
||
||
| 0x0AB4 | 2740 | [STAP_2AFC_TRIAL_OUTCOME](/Data%20Block%20Descriptions/0x0A00-0x0AFF.md#block-code-0x0AB4) | SensiTrak proprioception discrimination task trial outcome data. |
||
||
| 0x0AF0 | 2800 | [FR_TASK_TRIAL](/Data%20Block%20Descriptions/0x0A00-0x0AFF.md#block-code-0x0AF0) | Fixed reinforcement task trial data. |
