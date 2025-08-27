function block_read = OmniTrakFileRead_ReadBlock_Dictionary(fid)

%
% OmniTrakFileRead_ReadBlock_Dictionary.m
%
%	copyright 2025, Vulintus, Inc.
%
%	OmniTrak file data block read subfunction router.
%
%	Library documentation:
%	https://github.com/Vulintus/OmniTrak_File_Format
%
%	This function was programmatically generated: 2025-08-26, 07:46:19 (UTC)
%

block_read = dictionary;


% The version of the file format used.
block_read(1) = struct('def_name', 'FILE_VERSION', 'fcn', @(data)OmniTrakFileRead_ReadBlock_FILE_VERSION(fid,data));

% Value of the SoC millisecond clock at file creation.
block_read(2) = struct('def_name', 'MS_FILE_START', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MS_FILE_START(fid,data));

% Value of the SoC millisecond clock when the file is closed.
block_read(3) = struct('def_name', 'MS_FILE_STOP', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MS_FILE_STOP(fid,data));

% A single subject's name.
block_read(4) = struct('def_name', 'SUBJECT_DEPRECATED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SUBJECT_DEPRECATED(fid,data));


% Computer clock serial date number at file creation (local time).
block_read(6) = struct('def_name', 'CLOCK_FILE_START', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CLOCK_FILE_START(fid,data));

% Computer clock serial date number when the file is closed (local time).
block_read(7) = struct('def_name', 'CLOCK_FILE_STOP', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CLOCK_FILE_STOP(fid,data));


% The device's current file index.
block_read(10) = struct('def_name', 'DEVICE_FILE_INDEX', 'fcn', @(data)OmniTrakFileRead_ReadBlock_DEVICE_FILE_INDEX(fid,data));


% A fetched NTP time (seconds since January 1, 1900) at the specified SoC millisecond clock time.
block_read(20) = struct('def_name', 'NTP_SYNC', 'fcn', @(data)OmniTrakFileRead_ReadBlock_NTP_SYNC(fid,data));

% Indicates the an NTP synchonization attempt failed.
block_read(21) = struct('def_name', 'NTP_SYNC_FAIL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_NTP_SYNC_FAIL(fid,data));

% The current serial date number, millisecond clock reading, and/or microsecond clock reading at a single timepoint.
block_read(22) = struct('def_name', 'CLOCK_SYNC', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CLOCK_SYNC(fid,data));

% Indicates that the millisecond timer rolled over since the last loop.
block_read(23) = struct('def_name', 'MS_TIMER_ROLLOVER', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MS_TIMER_ROLLOVER(fid,data));

% Indicates that the microsecond timer rolled over since the last loop.
block_read(24) = struct('def_name', 'US_TIMER_ROLLOVER', 'fcn', @(data)OmniTrakFileRead_ReadBlock_US_TIMER_ROLLOVER(fid,data));

% Computer clock time zone offset from UTC.
block_read(25) = struct('def_name', 'TIME_ZONE_OFFSET', 'fcn', @(data)OmniTrakFileRead_ReadBlock_TIME_ZONE_OFFSET(fid,data));

% Computer clock time zone offset from UTC as two integers, one for hours, and the other for minutes
block_read(26) = struct('def_name', 'TIME_ZONE_OFFSET_HHMM', 'fcn', @(data)OmniTrakFileRead_ReadBlock_TIME_ZONE_OFFSET_HHMM(fid,data));


% Current date/time string from the real-time clock.
block_read(30) = struct('def_name', 'RTC_STRING_DEPRECATED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_RTC_STRING_DEPRECATED(fid,data));

% Current date/time string from the real-time clock.
block_read(31) = struct('def_name', 'RTC_STRING', 'fcn', @(data)OmniTrakFileRead_ReadBlock_RTC_STRING(fid,data));

% Current date/time values from the real-time clock.
block_read(32) = struct('def_name', 'RTC_VALUES', 'fcn', @(data)OmniTrakFileRead_ReadBlock_RTC_VALUES(fid,data));


% The original filename for the data file.
block_read(40) = struct('def_name', 'ORIGINAL_FILENAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ORIGINAL_FILENAME(fid,data));

% A timestamped event to indicate when a file has been renamed by one of Vulintus' automatic data organizing programs.
block_read(41) = struct('def_name', 'RENAMED_FILE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_RENAMED_FILE(fid,data));

% A timestamp indicating when the data file was downloaded from the OmniTrak device to a computer.
block_read(42) = struct('def_name', 'DOWNLOAD_TIME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_DOWNLOAD_TIME(fid,data));

% The computer system name and the COM port used to download the data file form the OmniTrak device.
block_read(43) = struct('def_name', 'DOWNLOAD_SYSTEM', 'fcn', @(data)OmniTrakFileRead_ReadBlock_DOWNLOAD_SYSTEM(fid,data));


% Indicates that the file will end in an incomplete block.
block_read(50) = struct('def_name', 'INCOMPLETE_BLOCK', 'fcn', @(data)OmniTrakFileRead_ReadBlock_INCOMPLETE_BLOCK(fid,data));


% Date/time values from a user-set timestamp.
block_read(60) = struct('def_name', 'USER_TIME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_USER_TIME(fid,data));


% Vulintus system ID code (1 = MotoTrak, 2 = OmniTrak, 3 = HabiTrak, 4 = OmniHome, 5 = SensiTrak, 6 = Prototype).
block_read(100) = struct('def_name', 'SYSTEM_TYPE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SYSTEM_TYPE(fid,data));

% Vulintus system name.
block_read(101) = struct('def_name', 'SYSTEM_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SYSTEM_NAME(fid,data));

% Vulintus system hardware version.
block_read(102) = struct('def_name', 'SYSTEM_HW_VER', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SYSTEM_HW_VER(fid,data));

% System firmware version, written as characters.
block_read(103) = struct('def_name', 'SYSTEM_FW_VER', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SYSTEM_FW_VER(fid,data));

% System serial number, written as characters.
block_read(104) = struct('def_name', 'SYSTEM_SN', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SYSTEM_SN(fid,data));

% Manufacturer name for non-Vulintus systems.
block_read(105) = struct('def_name', 'SYSTEM_MFR', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SYSTEM_MFR(fid,data));

% Windows PC computer name.
block_read(106) = struct('def_name', 'COMPUTER_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_COMPUTER_NAME(fid,data));

% The COM port of a computer-connected system.
block_read(107) = struct('def_name', 'COM_PORT', 'fcn', @(data)OmniTrakFileRead_ReadBlock_COM_PORT(fid,data));

% Human-readable Adjective + Noun alias/name for the device, assigned by Vulintus during manufacturing.
block_read(108) = struct('def_name', 'DEVICE_ALIAS', 'fcn', @(data)OmniTrakFileRead_ReadBlock_DEVICE_ALIAS(fid,data));


% Primary module name, for systems with interchangeable modules.
block_read(110) = struct('def_name', 'PRIMARY_MODULE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_PRIMARY_MODULE(fid,data));

% Primary input name, for modules with multiple input signals.
block_read(111) = struct('def_name', 'PRIMARY_INPUT', 'fcn', @(data)OmniTrakFileRead_ReadBlock_PRIMARY_INPUT(fid,data));

% The SAMD manufacturer's unique chip identifier.
block_read(112) = struct('def_name', 'SAMD_CHIP_ID', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SAMD_CHIP_ID(fid,data));


% The MAC address of the device's ESP8266 module.
block_read(120) = struct('def_name', 'ESP8266_MAC_ADDR', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ESP8266_MAC_ADDR(fid,data));

% The local IPv4 address of the device's ESP8266 module.
block_read(121) = struct('def_name', 'ESP8266_IP4_ADDR', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ESP8266_IP4_ADDR(fid,data));

% The ESP8266 manufacturer's unique chip identifier
block_read(122) = struct('def_name', 'ESP8266_CHIP_ID', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ESP8266_CHIP_ID(fid,data));

% The ESP8266 flash chip's unique chip identifier
block_read(123) = struct('def_name', 'ESP8266_FLASH_ID', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ESP8266_FLASH_ID(fid,data));


% The user's name for the system, i.e. booth number.
block_read(130) = struct('def_name', 'USER_SYSTEM_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_USER_SYSTEM_NAME(fid,data));


% The current reboot count saved in EEPROM or flash memory.
block_read(140) = struct('def_name', 'DEVICE_RESET_COUNT', 'fcn', @(data)OmniTrakFileRead_ReadBlock_DEVICE_RESET_COUNT(fid,data));

% Controller firmware filename, copied from the macro, written as characters.
block_read(141) = struct('def_name', 'CTRL_FW_FILENAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CTRL_FW_FILENAME(fid,data));

% Controller firmware upload date, copied from the macro, written as characters.
block_read(142) = struct('def_name', 'CTRL_FW_DATE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CTRL_FW_DATE(fid,data));

% Controller firmware upload time, copied from the macro, written as characters.
block_read(143) = struct('def_name', 'CTRL_FW_TIME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CTRL_FW_TIME(fid,data));

% OTMP Module firmware filename, copied from the macro, written as characters.
block_read(144) = struct('def_name', 'MODULE_FW_FILENAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MODULE_FW_FILENAME(fid,data));

% OTMP Module firmware upload date, copied from the macro, written as characters.
block_read(145) = struct('def_name', 'MODULE_FW_DATE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MODULE_FW_DATE(fid,data));

% OTMP Module firmware upload time, copied from the macro, written as characters.
block_read(146) = struct('def_name', 'MODULE_FW_TIME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MODULE_FW_TIME(fid,data));

% OTMP module name, written as characters.
block_read(147) = struct('def_name', 'MODULE_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MODULE_NAME(fid,data));

% OTMP Module SKU, typically written as 4 characters.
block_read(148) = struct('def_name', 'MODULE_SKU', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MODULE_SKU(fid,data));


% OTMP Module serial number, written as characters.
block_read(153) = struct('def_name', 'MODULE_SN', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MODULE_SN(fid,data));


% The MAC address of the device's ATWINC1500 module.
block_read(150) = struct('def_name', 'WINC1500_MAC_ADDR', 'fcn', @(data)OmniTrakFileRead_ReadBlock_WINC1500_MAC_ADDR(fid,data));

% The local IPv4 address of the device's ATWINC1500 module.
block_read(151) = struct('def_name', 'WINC1500_IP4_ADDR', 'fcn', @(data)OmniTrakFileRead_ReadBlock_WINC1500_IP4_ADDR(fid,data));


% Current battery state-of charge, in percent.
block_read(170) = struct('def_name', 'BATTERY_SOC', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BATTERY_SOC(fid,data));

% Current battery voltage, in millivolts.
block_read(171) = struct('def_name', 'BATTERY_VOLTS', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BATTERY_VOLTS(fid,data));

% Average current draw from the battery, in milli-amps.
block_read(172) = struct('def_name', 'BATTERY_CURRENT', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BATTERY_CURRENT(fid,data));

% Full capacity of the battery, in milli-amp hours.
block_read(173) = struct('def_name', 'BATTERY_FULL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BATTERY_FULL(fid,data));

% Remaining capacity of the battery, in milli-amp hours.
block_read(174) = struct('def_name', 'BATTERY_REMAIN', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BATTERY_REMAIN(fid,data));

% Average power draw, in milliWatts.
block_read(175) = struct('def_name', 'BATTERY_POWER', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BATTERY_POWER(fid,data));

% Battery state-of-health, in percent.
block_read(176) = struct('def_name', 'BATTERY_SOH', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BATTERY_SOH(fid,data));

% Combined battery state-of-charge, voltage, current, capacity, power, and state-of-health.
block_read(177) = struct('def_name', 'BATTERY_STATUS', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BATTERY_STATUS(fid,data));


% Actual rotation rate, in RPM, of the feeder servo (OmniHome) when set to 180 speed.
block_read(190) = struct('def_name', 'FEED_SERVO_MAX_RPM', 'fcn', @(data)OmniTrakFileRead_ReadBlock_FEED_SERVO_MAX_RPM(fid,data));

% Current speed setting (0-180) for the feeder servo (OmniHome).
block_read(191) = struct('def_name', 'FEED_SERVO_SPEED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_FEED_SERVO_SPEED(fid,data));


% A single subject's name.
block_read(200) = struct('def_name', 'SUBJECT_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SUBJECT_NAME(fid,data));

% The subject's or subjects' experimental group name.
block_read(201) = struct('def_name', 'GROUP_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_GROUP_NAME(fid,data));


% Test administrator's name.
block_read(224) = struct('def_name', 'ADMIN_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ADMIN_NAME(fid,data));


% The user's name for the current experiment.
block_read(300) = struct('def_name', 'EXP_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_EXP_NAME(fid,data));

% The user's name for task type, which can be a variant of the overall experiment type.
block_read(301) = struct('def_name', 'TASK_TYPE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_TASK_TYPE(fid,data));


% The stage name for a behavioral session.
block_read(400) = struct('def_name', 'STAGE_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_STAGE_NAME(fid,data));

% The stage description for a behavioral session.
block_read(401) = struct('def_name', 'STAGE_DESCRIPTION', 'fcn', @(data)OmniTrakFileRead_ReadBlock_STAGE_DESCRIPTION(fid,data));


% Behavioral session parameters structure encoded in JSON format text.
block_read(512) = struct('def_name', 'SESSION_PARAMS_JSON', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SESSION_PARAMS_JSON(fid,data));

% Behavioral trial parameters structure encoded in JSON format text.
block_read(513) = struct('def_name', 'TRIAL_PARAMS_JSON', 'fcn', @(data)OmniTrakFileRead_ReadBlock_TRIAL_PARAMS_JSON(fid,data));


% Indicates that an AMG8833 thermopile array sensor is present in the system.
block_read(1000) = struct('def_name', 'AMG8833_ENABLED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_AMG8833_ENABLED(fid,data));

% Indicates that an BMP280 temperature/pressure sensor is present in the system.
block_read(1001) = struct('def_name', 'BMP280_ENABLED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BMP280_ENABLED(fid,data));

% Indicates that an BME280 temperature/pressure/humidty sensor is present in the system.
block_read(1002) = struct('def_name', 'BME280_ENABLED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BME280_ENABLED(fid,data));

% Indicates that an BME680 temperature/pressure/humidy/VOC sensor is present in the system.
block_read(1003) = struct('def_name', 'BME680_ENABLED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BME680_ENABLED(fid,data));

% Indicates that an CCS811 VOC/eC02 sensor is present in the system.
block_read(1004) = struct('def_name', 'CCS811_ENABLED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CCS811_ENABLED(fid,data));

% Indicates that an SGP30 VOC/eC02 sensor is present in the system.
block_read(1005) = struct('def_name', 'SGP30_ENABLED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SGP30_ENABLED(fid,data));

% Indicates that an VL53L0X time-of-flight distance sensor is present in the system.
block_read(1006) = struct('def_name', 'VL53L0X_ENABLED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_VL53L0X_ENABLED(fid,data));

% Indicates that an ALS-PT19 ambient light sensor is present in the system.
block_read(1007) = struct('def_name', 'ALSPT19_ENABLED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ALSPT19_ENABLED(fid,data));

% Indicates that an MLX90640 thermopile array sensor is present in the system.
block_read(1008) = struct('def_name', 'MLX90640_ENABLED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_ENABLED(fid,data));

% Indicates that an ZMOD4410 VOC/eC02 sensor is present in the system.
block_read(1009) = struct('def_name', 'ZMOD4410_ENABLED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ZMOD4410_ENABLED(fid,data));


% A point in a tracked ambulation path, with absolute x- and y-coordinates in millimeters, with facing direction theta, in degrees.
block_read(1024) = struct('def_name', 'AMBULATION_XY_THETA', 'fcn', @(data)OmniTrakFileRead_ReadBlock_AMBULATION_XY_THETA(fid,data));


% The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature.
block_read(1100) = struct('def_name', 'AMG8833_THERM_CONV', 'fcn', @(data)OmniTrakFileRead_ReadBlock_AMG8833_THERM_CONV(fid,data));

% The current AMG8833 thermistor reading as a converted float32 value, in Celsius.
block_read(1101) = struct('def_name', 'AMG8833_THERM_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_AMG8833_THERM_FL(fid,data));

% The current AMG8833 thermistor reading as a raw, signed 16-bit integer.
block_read(1102) = struct('def_name', 'AMG8833_THERM_INT', 'fcn', @(data)OmniTrakFileRead_ReadBlock_AMG8833_THERM_INT(fid,data));


% The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature.
block_read(1110) = struct('def_name', 'AMG8833_PIXELS_CONV', 'fcn', @(data)OmniTrakFileRead_ReadBlock_AMG8833_PIXELS_CONV(fid,data));

% The current AMG8833 pixel readings as converted float32 values, in Celsius.
block_read(1111) = struct('def_name', 'AMG8833_PIXELS_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_AMG8833_PIXELS_FL(fid,data));

% The current AMG8833 pixel readings as a raw, signed 16-bit integers.
block_read(1112) = struct('def_name', 'AMG8833_PIXELS_INT', 'fcn', @(data)OmniTrakFileRead_ReadBlock_AMG8833_PIXELS_INT(fid,data));

% The current HTPA32x32 pixel readings as a fixed-point 6/2 type (6 bits for the unsigned integer part, 2 bits for the decimal part), in units of Celcius. This allows temperatures from 0 to 63.75 C.
block_read(1113) = struct('def_name', 'HTPA32X32_PIXELS_FP62', 'fcn', @(data)OmniTrakFileRead_ReadBlock_HTPA32X32_PIXELS_FP62(fid,data));

% The current HTPA32x32 pixel readings represented as 16-bit unsigned integers in units of deciKelvin (dK, or Kelvin * 10).
block_read(1114) = struct('def_name', 'HTPA32X32_PIXELS_INT_K', 'fcn', @(data)OmniTrakFileRead_ReadBlock_HTPA32X32_PIXELS_INT_K(fid,data));

% The current ambient temperature measured by the HTPA32x32, represented as a 32-bit float, in units of Celcius.
block_read(1115) = struct('def_name', 'HTPA32X32_AMBIENT_TEMP', 'fcn', @(data)OmniTrakFileRead_ReadBlock_HTPA32X32_AMBIENT_TEMP(fid,data));

% The current HTPA32x32 pixel readings represented as 12-bit signed integers (2 pixels for every 3 bytes) in units of deciCelsius (dC, or Celsius * 10), with values under-range set to the minimum  (2048 dC) and values over-range set to the maximum (2047 dC).
block_read(1116) = struct('def_name', 'HTPA32X32_PIXELS_INT12_C', 'fcn', @(data)OmniTrakFileRead_ReadBlock_HTPA32X32_PIXELS_INT12_C(fid,data));

% The location and temperature of the hottest pixel in the HTPA32x32 image. This may not be the raw hottest pixel. It may have gone through some processing and filtering to determine the true hottest pixel. The temperature will be in FP62 formatted Celsius.
block_read(1117) = struct('def_name', 'HTPA32X32_HOTTEST_PIXEL_FP62', 'fcn', @(data)OmniTrakFileRead_ReadBlock_HTPA32X32_HOTTEST_PIXEL_FP62(fid,data));


% The current red, green, blue, IR, and green2 sensor readings from the BH1749 sensor
block_read(1120) = struct('def_name', 'BH1749_RGB', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BH1749_RGB(fid,data));

% A special block acting as a sanity check, only used in cases of debugging
block_read(1121) = struct('def_name', 'DEBUG_SANITY_CHECK', 'fcn', @(data)OmniTrakFileRead_ReadBlock_DEBUG_SANITY_CHECK(fid,data));


% The current BME280 temperature reading as a converted float32 value, in Celsius.
block_read(1200) = struct('def_name', 'BME280_TEMP_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BME280_TEMP_FL(fid,data));

% The current BMP280 temperature reading as a converted float32 value, in Celsius.
block_read(1201) = struct('def_name', 'BMP280_TEMP_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BMP280_TEMP_FL(fid,data));

% The current BME680 temperature reading as a converted float32 value, in Celsius.
block_read(1202) = struct('def_name', 'BME680_TEMP_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BME680_TEMP_FL(fid,data));


% The current BME280 pressure reading as a converted float32 value, in Pascals (Pa).
block_read(1210) = struct('def_name', 'BME280_PRES_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BME280_PRES_FL(fid,data));

% The current BMP280 pressure reading as a converted float32 value, in Pascals (Pa).
block_read(1211) = struct('def_name', 'BMP280_PRES_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BMP280_PRES_FL(fid,data));

% The current BME680 pressure reading as a converted float32 value, in Pascals (Pa).
block_read(1212) = struct('def_name', 'BME680_PRES_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BME680_PRES_FL(fid,data));


% The current BM280 humidity reading as a converted float32 value, in percent (%).
block_read(1220) = struct('def_name', 'BME280_HUM_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BME280_HUM_FL(fid,data));

% The current BME680 humidity reading as a converted float32 value, in percent (%).
block_read(1221) = struct('def_name', 'BME680_HUM_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BME680_HUM_FL(fid,data));


% The current BME680 gas resistance reading as a converted float32 value, in units of kOhms
block_read(1230) = struct('def_name', 'BME680_GAS_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BME680_GAS_FL(fid,data));


% The current VL53L0X distance reading as a 16-bit integer, in millimeters (-1 indicates out-of-range).
block_read(1300) = struct('def_name', 'VL53L0X_DIST', 'fcn', @(data)OmniTrakFileRead_ReadBlock_VL53L0X_DIST(fid,data));

% Indicates the VL53L0X sensor experienced a range failure.
block_read(1301) = struct('def_name', 'VL53L0X_FAIL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_VL53L0X_FAIL(fid,data));


% The serial number of the SGP30.
block_read(1400) = struct('def_name', 'SGP30_SN', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SGP30_SN(fid,data));


% The current SGp30 eCO2 reading distance reading as a 16-bit integer, in parts per million (ppm).
block_read(1410) = struct('def_name', 'SGP30_EC02', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SGP30_EC02(fid,data));


% The current SGp30 TVOC reading distance reading as a 16-bit integer, in parts per million (ppm).
block_read(1420) = struct('def_name', 'SGP30_TVOC', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SGP30_TVOC(fid,data));


% The MLX90640 unique device ID saved in the device's EEPROM.
block_read(1500) = struct('def_name', 'MLX90640_DEVICE_ID', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_DEVICE_ID(fid,data));

% Raw download of the entire MLX90640 EEPROM, as unsigned 16-bit integers.
block_read(1501) = struct('def_name', 'MLX90640_EEPROM_DUMP', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_EEPROM_DUMP(fid,data));

% ADC resolution setting on the MLX90640 (16-, 17-, 18-, or 19-bit).
block_read(1502) = struct('def_name', 'MLX90640_ADC_RES', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_ADC_RES(fid,data));

% Current refresh rate on the MLX90640 (0.25, 0.5, 1, 2, 4, 8, 16, or 32 Hz).
block_read(1503) = struct('def_name', 'MLX90640_REFRESH_RATE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_REFRESH_RATE(fid,data));

% Current I2C clock freqency used with the MLX90640 (100, 400, or 1000 kHz).
block_read(1504) = struct('def_name', 'MLX90640_I2C_CLOCKRATE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_I2C_CLOCKRATE(fid,data));


% The current MLX90640 pixel readings as converted float32 values, in Celsius.
block_read(1510) = struct('def_name', 'MLX90640_PIXELS_TO', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_PIXELS_TO(fid,data));

% The current MLX90640 pixel readings as converted, but uncalibrationed, float32 values.
block_read(1511) = struct('def_name', 'MLX90640_PIXELS_IM', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_PIXELS_IM(fid,data));

% The current MLX90640 pixel readings as a raw, unsigned 16-bit integers.
block_read(1512) = struct('def_name', 'MLX90640_PIXELS_INT', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_PIXELS_INT(fid,data));


% The I2C transfer time of the frame data from the MLX90640 to the microcontroller, in milliseconds.
block_read(1520) = struct('def_name', 'MLX90640_I2C_TIME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_I2C_TIME(fid,data));

% The calculation time for the uncalibrated or calibrated image captured by the MLX90640.
block_read(1521) = struct('def_name', 'MLX90640_CALC_TIME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_CALC_TIME(fid,data));

% The SD card write time for the MLX90640 float32 image data.
block_read(1522) = struct('def_name', 'MLX90640_IM_WRITE_TIME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_IM_WRITE_TIME(fid,data));

% The SD card write time for the MLX90640 raw uint16 data.
block_read(1523) = struct('def_name', 'MLX90640_INT_WRITE_TIME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_INT_WRITE_TIME(fid,data));


% The current analog value of the ALS-PT19 ambient light sensor, as an unsigned integer ADC value.
block_read(1600) = struct('def_name', 'ALSPT19_LIGHT', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ALSPT19_LIGHT(fid,data));


% The current lower and upper bounds for the ZMOD4410 ADC reading used in calculations.
block_read(1700) = struct('def_name', 'ZMOD4410_MOX_BOUND', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ZMOD4410_MOX_BOUND(fid,data));

% Current configuration values for the ZMOD4410.
block_read(1701) = struct('def_name', 'ZMOD4410_CONFIG_PARAMS', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ZMOD4410_CONFIG_PARAMS(fid,data));

% Timestamped ZMOD4410 error event.
block_read(1702) = struct('def_name', 'ZMOD4410_ERROR', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ZMOD4410_ERROR(fid,data));

% Timestamped ZMOD4410 reading calibrated and converted to float32.
block_read(1703) = struct('def_name', 'ZMOD4410_READING_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ZMOD4410_READING_FL(fid,data));

% Timestamped ZMOD4410 reading saved as the raw uint16 ADC value.
block_read(1704) = struct('def_name', 'ZMOD4410_READING_INT', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ZMOD4410_READING_INT(fid,data));


% Timestamped ZMOD4410 eCO2 reading.
block_read(1710) = struct('def_name', 'ZMOD4410_ECO2', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ZMOD4410_ECO2(fid,data));

% Timestamped ZMOD4410 indoor air quality reading.
block_read(1711) = struct('def_name', 'ZMOD4410_IAQ', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ZMOD4410_IAQ(fid,data));

% Timestamped ZMOD4410 total volatile organic compound reading.
block_read(1712) = struct('def_name', 'ZMOD4410_TVOC', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ZMOD4410_TVOC(fid,data));

% Timestamped ZMOD4410 total volatile organic compound reading.
block_read(1713) = struct('def_name', 'ZMOD4410_R_CDA', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ZMOD4410_R_CDA(fid,data));


% Current accelerometer reading settings on any enabled LSM303.
block_read(1800) = struct('def_name', 'LSM303_ACC_SETTINGS', 'fcn', @(data)OmniTrakFileRead_ReadBlock_LSM303_ACC_SETTINGS(fid,data));

% Current magnetometer reading settings on any enabled LSM303.
block_read(1801) = struct('def_name', 'LSM303_MAG_SETTINGS', 'fcn', @(data)OmniTrakFileRead_ReadBlock_LSM303_MAG_SETTINGS(fid,data));

% Current readings from the LSM303 accelerometer, as float values in m/s^2.
block_read(1802) = struct('def_name', 'LSM303_ACC_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_LSM303_ACC_FL(fid,data));

% Current readings from the LSM303 magnetometer, as float values in uT.
block_read(1803) = struct('def_name', 'LSM303_MAG_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_LSM303_MAG_FL(fid,data));

% Current readings from the LSM303 temperature sensor, as float value in degrees Celcius
block_read(1804) = struct('def_name', 'LSM303_TEMP_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_LSM303_TEMP_FL(fid,data));


% Spectrometer wavelengths, in nanometers.
block_read(1900) = struct('def_name', 'SPECTRO_WAVELEN', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SPECTRO_WAVELEN(fid,data));

% Spectrometer measurement trace.
block_read(1901) = struct('def_name', 'SPECTRO_TRACE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SPECTRO_TRACE(fid,data));


% Timestamped event for feeding/pellet dispensing.
block_read(2000) = struct('def_name', 'PELLET_DISPENSE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_PELLET_DISPENSE(fid,data));

% Timestamped event for feeding/pellet dispensing in which no pellet was detected.
block_read(2001) = struct('def_name', 'PELLET_FAILURE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_PELLET_FAILURE(fid,data));


% Timestamped event marker for the start of a session pause, with no events recorded during the pause.
block_read(2010) = struct('def_name', 'HARD_PAUSE_START', 'fcn', @(data)OmniTrakFileRead_ReadBlock_HARD_PAUSE_START(fid,data));

% Timestamped event marker for the stop of a session pause, with no events recorded during the pause.
block_read(2011) = struct('def_name', 'HARD_PAUSE_STOP', 'fcn', @(data)OmniTrakFileRead_ReadBlock_HARD_PAUSE_STOP(fid,data));

% Timestamped event marker for the start of a session pause, with non-operant events recorded during the pause.
block_read(2012) = struct('def_name', 'SOFT_PAUSE_START', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SOFT_PAUSE_START(fid,data));

% Timestamped event marker for the stop of a session pause, with non-operant events recorded during the pause.
block_read(2013) = struct('def_name', 'SOFT_PAUSE_STOP', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SOFT_PAUSE_STOP(fid,data));

% Timestamped event marker for the start of a trial, with accompanying microsecond clock reading
block_read(2014) = struct('def_name', 'TRIAL_START_SERIAL_DATE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_TRIAL_START_SERIAL_DATE(fid,data));


% Starting position of an autopositioner in just the x-direction, with distance in millimeters.
block_read(2020) = struct('def_name', 'POSITION_START_X', 'fcn', @(data)OmniTrakFileRead_ReadBlock_POSITION_START_X(fid,data));

% Timestamped movement of an autopositioner in just the x-direction, with distance in millimeters.
block_read(2021) = struct('def_name', 'POSITION_MOVE_X', 'fcn', @(data)OmniTrakFileRead_ReadBlock_POSITION_MOVE_X(fid,data));

% Starting position of an autopositioner in just the x- and y-directions, with distance in millimeters.
block_read(2022) = struct('def_name', 'POSITION_START_XY', 'fcn', @(data)OmniTrakFileRead_ReadBlock_POSITION_START_XY(fid,data));

% Timestamped movement of an autopositioner in just the x- and y-directions, with distance in millimeters.
block_read(2023) = struct('def_name', 'POSITION_MOVE_XY', 'fcn', @(data)OmniTrakFileRead_ReadBlock_POSITION_MOVE_XY(fid,data));

% Starting position of an autopositioner in the x-, y-, and z- directions, with distance in millimeters.
block_read(2024) = struct('def_name', 'POSITION_START_XYZ', 'fcn', @(data)OmniTrakFileRead_ReadBlock_POSITION_START_XYZ(fid,data));

% Timestamped movement of an autopositioner in the x-, y-, and z- directions, with distance in millimeters.
block_read(2025) = struct('def_name', 'POSITION_MOVE_XYZ', 'fcn', @(data)OmniTrakFileRead_ReadBlock_POSITION_MOVE_XYZ(fid,data));


% Timestamped event for a single TTL pulse output, with channel number, voltage, pulse duration, inter-pulse period, and number of pulses.
block_read(2048) = struct('def_name', 'TTL_PULSETRAIN', 'fcn', @(data)OmniTrakFileRead_ReadBlock_TTL_PULSETRAIN(fid,data));

% Timestamped event for when a TTL pulsetrain is canceled before completion.
block_read(2049) = struct('def_name', 'TTL_PULSETRAIN_ABORT', 'fcn', @(data)OmniTrakFileRead_ReadBlock_TTL_PULSETRAIN_ABORT(fid,data));


% Stream input name for the specified input index.
block_read(2100) = struct('def_name', 'STREAM_INPUT_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_STREAM_INPUT_NAME(fid,data));


% Starting calibration baseline coefficient, for the specified module index.
block_read(2200) = struct('def_name', 'CALIBRATION_BASELINE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CALIBRATION_BASELINE(fid,data));

% Starting calibration slope coefficient, for the specified module index.
block_read(2201) = struct('def_name', 'CALIBRATION_SLOPE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CALIBRATION_SLOPE(fid,data));

% Timestamped in-session calibration baseline coefficient adjustment, for the specified module index.
block_read(2202) = struct('def_name', 'CALIBRATION_BASELINE_ADJUST', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CALIBRATION_BASELINE_ADJUST(fid,data));

% Timestamped in-session calibration slope coefficient adjustment, for the specified module index.
block_read(2203) = struct('def_name', 'CALIBRATION_SLOPE_ADJUST', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CALIBRATION_SLOPE_ADJUST(fid,data));

% Most recent calibration date/time, for the specified module index.
block_read(2204) = struct('def_name', 'CALIBRATION_DATE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CALIBRATION_DATE(fid,data));


% Type of hit threshold (i.e. peak force), for the specified input.
block_read(2300) = struct('def_name', 'HIT_THRESH_TYPE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_HIT_THRESH_TYPE(fid,data));


% A name/description of secondary thresholds used in the behavior.
block_read(2310) = struct('def_name', 'SECONDARY_THRESH_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SECONDARY_THRESH_NAME(fid,data));


% Type of initation threshold (i.e. force or touch), for the specified input.
block_read(2320) = struct('def_name', 'INIT_THRESH_TYPE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_INIT_THRESH_TYPE(fid,data));


% A timestamped manual feed event, triggered remotely.
block_read(2400) = struct('def_name', 'REMOTE_MANUAL_FEED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_REMOTE_MANUAL_FEED(fid,data));

% A timestamped manual feed event, triggered from the hardware user interface.
block_read(2401) = struct('def_name', 'HWUI_MANUAL_FEED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_HWUI_MANUAL_FEED(fid,data));

% A timestamped manual feed event, triggered randomly by the firmware.
block_read(2402) = struct('def_name', 'FW_RANDOM_FEED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_FW_RANDOM_FEED(fid,data));

% A timestamped manual feed event, triggered from a computer software user interface.
block_read(2403) = struct('def_name', 'SWUI_MANUAL_FEED_DEPRECATED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SWUI_MANUAL_FEED_DEPRECATED(fid,data));

% A timestamped operant-rewarded feed event, trigged by the OmniHome firmware, with the possibility of multiple feedings.
block_read(2404) = struct('def_name', 'FW_OPERANT_FEED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_FW_OPERANT_FEED(fid,data));

% A timestamped manual feed event, triggered from a computer software user interface.
block_read(2405) = struct('def_name', 'SWUI_MANUAL_FEED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SWUI_MANUAL_FEED(fid,data));

% A timestamped manual feed event, triggered randomly by computer software.
block_read(2406) = struct('def_name', 'SW_RANDOM_FEED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SW_RANDOM_FEED(fid,data));

% A timestamped operant-rewarded feed event, trigged by the PC-based behavioral software, with the possibility of multiple feedings.
block_read(2407) = struct('def_name', 'SW_OPERANT_FEED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SW_OPERANT_FEED(fid,data));


% MotoTrak version 3.0 trial outcome data.
block_read(2500) = struct('def_name', 'MOTOTRAK_V3P0_OUTCOME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MOTOTRAK_V3P0_OUTCOME(fid,data));

% MotoTrak version 3.0 trial stream signal.
block_read(2501) = struct('def_name', 'MOTOTRAK_V3P0_SIGNAL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MOTOTRAK_V3P0_SIGNAL(fid,data));


% Nosepoke status bitmask, typically written only when it changes.
block_read(2560) = struct('def_name', 'POKE_BITMASK', 'fcn', @(data)OmniTrakFileRead_ReadBlock_POKE_BITMASK(fid,data));


% Capacitive sensor status bitmask, typically written only when it changes.
block_read(2576) = struct('def_name', 'CAPSENSE_BITMASK', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CAPSENSE_BITMASK(fid,data));

% Capacitive sensor reading for one sensor, in ADC ticks or clock cycles.
block_read(2577) = struct('def_name', 'CAPSENSE_VALUE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CAPSENSE_VALUE(fid,data));


% Name/description of the output trigger type for the given index.
block_read(2600) = struct('def_name', 'OUTPUT_TRIGGER_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_OUTPUT_TRIGGER_NAME(fid,data));


% Vibration task trial outcome data.
block_read(2700) = struct('def_name', 'VIBRATION_TASK_TRIAL_OUTCOME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_VIBRATION_TASK_TRIAL_OUTCOME(fid,data));

% Vibrotactile detection task trial data.
block_read(2701) = struct('def_name', 'VIBROTACTILE_DETECTION_TASK_TRIAL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_VIBROTACTILE_DETECTION_TASK_TRIAL(fid,data));


% LED detection task trial outcome data.
block_read(2710) = struct('def_name', 'LED_DETECTION_TASK_TRIAL_OUTCOME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_LED_DETECTION_TASK_TRIAL_OUTCOME(fid,data));

% Light source model name.
block_read(2711) = struct('def_name', 'LIGHT_SRC_MODEL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_LIGHT_SRC_MODEL(fid,data));

% Light source type (i.e. LED, LASER, etc).
block_read(2712) = struct('def_name', 'LIGHT_SRC_TYPE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_LIGHT_SRC_TYPE(fid,data));


% SensiTrak tactile discrimination task trial outcome data.
block_read(2720) = struct('def_name', 'STTC_2AFC_TRIAL_OUTCOME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_STTC_2AFC_TRIAL_OUTCOME(fid,data));

% Number of pads on the SensiTrak Tactile Carousel module.
block_read(2721) = struct('def_name', 'STTC_NUM_PADS', 'fcn', @(data)OmniTrakFileRead_ReadBlock_STTC_NUM_PADS(fid,data));

% Microstep setting on the specified OTMP module.
block_read(2722) = struct('def_name', 'MODULE_MICROSTEP', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MODULE_MICROSTEP(fid,data));

% Steps per rotation on the specified OTMP module.
block_read(2723) = struct('def_name', 'MODULE_STEPS_PER_ROT', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MODULE_STEPS_PER_ROT(fid,data));


% Pitch circumference, in millimeters, of the driving gear on the specified OTMP module.
block_read(2730) = struct('def_name', 'MODULE_PITCH_CIRC', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MODULE_PITCH_CIRC(fid,data));

% Center offset, in millimeters, for the specified OTMP module.
block_read(2731) = struct('def_name', 'MODULE_CENTER_OFFSET', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MODULE_CENTER_OFFSET(fid,data));


% SensiTrak proprioception discrimination task trial outcome data.
block_read(2740) = struct('def_name', 'STAP_2AFC_TRIAL_OUTCOME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_STAP_2AFC_TRIAL_OUTCOME(fid,data));


% Fixed reinforcement task trial data.
block_read(2800) = struct('def_name', 'FR_TASK_TRIAL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_FR_TASK_TRIAL(fid,data));


% An oscilloscope recording, in units of volts, from one or multiple channels, with time units, in seconds, along with a variable number of parameters describing the recording conditions.
block_read(3072) = struct('def_name', 'SCOPE_TRACE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SCOPE_TRACE(fid,data));
