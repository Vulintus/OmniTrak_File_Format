function ofbc = Load_OmniTrak_File_Block_Codes

%
% Load_OmniTrak_File_Block_Codes.m
%
%	copyright 2025, Vulintus, Inc.
%
%	OmniTrak File Format Block Codes (OFBC) library.
%
%	Library documentation:
%	https://github.com/Vulintus/OmniTrak_File_Format
%
%	This function was programmatically generated: 2025-08-26, 07:46:18 (UTC)
%

ofbc = dictionary;

ofbc('OMNITRAK_FILE_VERIFY') = 43981;                 %First unsigned 16-bit integer written to every *.OmniTrak file to identify the file type, has a hex value of 0xABCD.
ofbc('FILE_VERSION') = 1;                             %The version of the file format used.
ofbc('MS_FILE_START') = 2;                            %Value of the SoC millisecond clock at file creation.
ofbc('MS_FILE_STOP') = 3;                             %Value of the SoC millisecond clock when the file is closed.
ofbc('SUBJECT_DEPRECATED') = 4;                       %A single subject's name.

ofbc('CLOCK_FILE_START') = 6;                         %Computer clock serial date number at file creation (local time).
ofbc('CLOCK_FILE_STOP') = 7;                          %Computer clock serial date number when the file is closed (local time).

ofbc('DEVICE_FILE_INDEX') = 10;                       %The device's current file index.

ofbc('NTP_SYNC') = 20;                                %A fetched NTP time (seconds since January 1, 1900) at the specified SoC millisecond clock time.
ofbc('NTP_SYNC_FAIL') = 21;                           %Indicates the an NTP synchonization attempt failed.
ofbc('CLOCK_SYNC') = 22;                              %The current serial date number, millisecond clock reading, and/or microsecond clock reading at a single timepoint.
ofbc('MS_TIMER_ROLLOVER') = 23;                       %Indicates that the millisecond timer rolled over since the last loop.
ofbc('US_TIMER_ROLLOVER') = 24;                       %Indicates that the microsecond timer rolled over since the last loop.
ofbc('TIME_ZONE_OFFSET') = 25;                        %Computer clock time zone offset from UTC.
ofbc('TIME_ZONE_OFFSET_HHMM') = 26;                   %Computer clock time zone offset from UTC as two integers, one for hours, and the other for minutes

ofbc('RTC_STRING_DEPRECATED') = 30;                   %Current date/time string from the real-time clock.
ofbc('RTC_STRING') = 31;                              %Current date/time string from the real-time clock.
ofbc('RTC_VALUES') = 32;                              %Current date/time values from the real-time clock.

ofbc('ORIGINAL_FILENAME') = 40;                       %The original filename for the data file.
ofbc('RENAMED_FILE') = 41;                            %A timestamped event to indicate when a file has been renamed by one of Vulintus' automatic data organizing programs.
ofbc('DOWNLOAD_TIME') = 42;                           %A timestamp indicating when the data file was downloaded from the OmniTrak device to a computer.
ofbc('DOWNLOAD_SYSTEM') = 43;                         %The computer system name and the COM port used to download the data file form the OmniTrak device.

ofbc('INCOMPLETE_BLOCK') = 50;                        %Indicates that the file will end in an incomplete block.

ofbc('USER_TIME') = 60;                               %Date/time values from a user-set timestamp.

ofbc('SYSTEM_TYPE') = 100;                            %Vulintus system ID code (1 = MotoTrak, 2 = OmniTrak, 3 = HabiTrak, 4 = OmniHome, 5 = SensiTrak, 6 = Prototype).
ofbc('SYSTEM_NAME') = 101;                            %Vulintus system name.
ofbc('SYSTEM_HW_VER') = 102;                          %Vulintus system hardware version.
ofbc('SYSTEM_FW_VER') = 103;                          %System firmware version, written as characters.
ofbc('SYSTEM_SN') = 104;                              %System serial number, written as characters.
ofbc('SYSTEM_MFR') = 105;                             %Manufacturer name for non-Vulintus systems.
ofbc('COMPUTER_NAME') = 106;                          %Windows PC computer name.
ofbc('COM_PORT') = 107;                               %The COM port of a computer-connected system.
ofbc('DEVICE_ALIAS') = 108;                           %Human-readable Adjective + Noun alias/name for the device, assigned by Vulintus during manufacturing.

ofbc('PRIMARY_MODULE') = 110;                         %Primary module name, for systems with interchangeable modules.
ofbc('PRIMARY_INPUT') = 111;                          %Primary input name, for modules with multiple input signals.
ofbc('SAMD_CHIP_ID') = 112;                           %The SAMD manufacturer's unique chip identifier.

ofbc('ESP8266_MAC_ADDR') = 120;                       %The MAC address of the device's ESP8266 module.
ofbc('ESP8266_IP4_ADDR') = 121;                       %The local IPv4 address of the device's ESP8266 module.
ofbc('ESP8266_CHIP_ID') = 122;                        %The ESP8266 manufacturer's unique chip identifier
ofbc('ESP8266_FLASH_ID') = 123;                       %The ESP8266 flash chip's unique chip identifier

ofbc('USER_SYSTEM_NAME') = 130;                       %The user's name for the system, i.e. booth number.

ofbc('DEVICE_RESET_COUNT') = 140;                     %The current reboot count saved in EEPROM or flash memory.
ofbc('CTRL_FW_FILENAME') = 141;                       %Controller firmware filename, copied from the macro, written as characters.
ofbc('CTRL_FW_DATE') = 142;                           %Controller firmware upload date, copied from the macro, written as characters.
ofbc('CTRL_FW_TIME') = 143;                           %Controller firmware upload time, copied from the macro, written as characters.
ofbc('MODULE_FW_FILENAME') = 144;                     %OTMP Module firmware filename, copied from the macro, written as characters.
ofbc('MODULE_FW_DATE') = 145;                         %OTMP Module firmware upload date, copied from the macro, written as characters.
ofbc('MODULE_FW_TIME') = 146;                         %OTMP Module firmware upload time, copied from the macro, written as characters.
ofbc('MODULE_NAME') = 147;                            %OTMP module name, written as characters.
ofbc('MODULE_SKU') = 148;                             %OTMP Module SKU, typically written as 4 characters.

ofbc('MODULE_SN') = 153;                              %OTMP Module serial number, written as characters.
ofbc('WINC1500_MAC_ADDR') = 150;                      %The MAC address of the device's ATWINC1500 module.
ofbc('WINC1500_IP4_ADDR') = 151;                      %The local IPv4 address of the device's ATWINC1500 module.

ofbc('BATTERY_SOC') = 170;                            %Current battery state-of charge, in percent.
ofbc('BATTERY_VOLTS') = 171;                          %Current battery voltage, in millivolts.
ofbc('BATTERY_CURRENT') = 172;                        %Average current draw from the battery, in milli-amps.
ofbc('BATTERY_FULL') = 173;                           %Full capacity of the battery, in milli-amp hours.
ofbc('BATTERY_REMAIN') = 174;                         %Remaining capacity of the battery, in milli-amp hours.
ofbc('BATTERY_POWER') = 175;                          %Average power draw, in milliWatts.
ofbc('BATTERY_SOH') = 176;                            %Battery state-of-health, in percent.
ofbc('BATTERY_STATUS') = 177;                         %Combined battery state-of-charge, voltage, current, capacity, power, and state-of-health.

ofbc('FEED_SERVO_MAX_RPM') = 190;                     %Actual rotation rate, in RPM, of the feeder servo (OmniHome) when set to 180 speed.
ofbc('FEED_SERVO_SPEED') = 191;                       %Current speed setting (0-180) for the feeder servo (OmniHome).

ofbc('SUBJECT_NAME') = 200;                           %A single subject's name.
ofbc('GROUP_NAME') = 201;                             %The subject's or subjects' experimental group name.

ofbc('ADMIN_NAME') = 224;                             %Test administrator's name.

ofbc('EXP_NAME') = 300;                               %The user's name for the current experiment.
ofbc('TASK_TYPE') = 301;                              %The user's name for task type, which can be a variant of the overall experiment type.

ofbc('STAGE_NAME') = 400;                             %The stage name for a behavioral session.
ofbc('STAGE_DESCRIPTION') = 401;                      %The stage description for a behavioral session.

ofbc('SESSION_PARAMS_JSON') = 512;                    %Behavioral session parameters structure encoded in JSON format text.
ofbc('TRIAL_PARAMS_JSON') = 513;                      %Behavioral trial parameters structure encoded in JSON format text.

ofbc('AMG8833_ENABLED') = 1000;                       %Indicates that an AMG8833 thermopile array sensor is present in the system.
ofbc('BMP280_ENABLED') = 1001;                        %Indicates that an BMP280 temperature/pressure sensor is present in the system.
ofbc('BME280_ENABLED') = 1002;                        %Indicates that an BME280 temperature/pressure/humidty sensor is present in the system.
ofbc('BME680_ENABLED') = 1003;                        %Indicates that an BME680 temperature/pressure/humidy/VOC sensor is present in the system.
ofbc('CCS811_ENABLED') = 1004;                        %Indicates that an CCS811 VOC/eC02 sensor is present in the system.
ofbc('SGP30_ENABLED') = 1005;                         %Indicates that an SGP30 VOC/eC02 sensor is present in the system.
ofbc('VL53L0X_ENABLED') = 1006;                       %Indicates that an VL53L0X time-of-flight distance sensor is present in the system.
ofbc('ALSPT19_ENABLED') = 1007;                       %Indicates that an ALS-PT19 ambient light sensor is present in the system.
ofbc('MLX90640_ENABLED') = 1008;                      %Indicates that an MLX90640 thermopile array sensor is present in the system.
ofbc('ZMOD4410_ENABLED') = 1009;                      %Indicates that an ZMOD4410 VOC/eC02 sensor is present in the system.

ofbc('AMBULATION_XY_THETA') = 1024;                   %A point in a tracked ambulation path, with absolute x- and y-coordinates in millimeters, with facing direction theta, in degrees.

ofbc('AMG8833_THERM_CONV') = 1100;                    %The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature.
ofbc('AMG8833_THERM_FL') = 1101;                      %The current AMG8833 thermistor reading as a converted float32 value, in Celsius.
ofbc('AMG8833_THERM_INT') = 1102;                     %The current AMG8833 thermistor reading as a raw, signed 16-bit integer.

ofbc('AMG8833_PIXELS_CONV') = 1110;                   %The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature.
ofbc('AMG8833_PIXELS_FL') = 1111;                     %The current AMG8833 pixel readings as converted float32 values, in Celsius.
ofbc('AMG8833_PIXELS_INT') = 1112;                    %The current AMG8833 pixel readings as a raw, signed 16-bit integers.
ofbc('HTPA32X32_PIXELS_FP62') = 1113;                 %The current HTPA32x32 pixel readings as a fixed-point 6/2 type (6 bits for the unsigned integer part, 2 bits for the decimal part), in units of Celcius. This allows temperatures from 0 to 63.75 C.
ofbc('HTPA32X32_PIXELS_INT_K') = 1114;                %The current HTPA32x32 pixel readings represented as 16-bit unsigned integers in units of deciKelvin (dK, or Kelvin * 10).
ofbc('HTPA32X32_AMBIENT_TEMP') = 1115;                %The current ambient temperature measured by the HTPA32x32, represented as a 32-bit float, in units of Celcius.
ofbc('HTPA32X32_PIXELS_INT12_C') = 1116;              %The current HTPA32x32 pixel readings represented as 12-bit signed integers (2 pixels for every 3 bytes) in units of deciCelsius (dC, or Celsius * 10), with values under-range set to the minimum  (2048 dC) and values over-range set to the maximum (2047 dC).
ofbc('HTPA32X32_HOTTEST_PIXEL_FP62') = 1117;          %The location and temperature of the hottest pixel in the HTPA32x32 image. This may not be the raw hottest pixel. It may have gone through some processing and filtering to determine the true hottest pixel. The temperature will be in FP62 formatted Celsius.

ofbc('BH1749_RGB') = 1120;                            %The current red, green, blue, IR, and green2 sensor readings from the BH1749 sensor
ofbc('DEBUG_SANITY_CHECK') = 1121;                    %A special block acting as a sanity check, only used in cases of debugging

ofbc('BME280_TEMP_FL') = 1200;                        %The current BME280 temperature reading as a converted float32 value, in Celsius.
ofbc('BMP280_TEMP_FL') = 1201;                        %The current BMP280 temperature reading as a converted float32 value, in Celsius.
ofbc('BME680_TEMP_FL') = 1202;                        %The current BME680 temperature reading as a converted float32 value, in Celsius.

ofbc('BME280_PRES_FL') = 1210;                        %The current BME280 pressure reading as a converted float32 value, in Pascals (Pa).
ofbc('BMP280_PRES_FL') = 1211;                        %The current BMP280 pressure reading as a converted float32 value, in Pascals (Pa).
ofbc('BME680_PRES_FL') = 1212;                        %The current BME680 pressure reading as a converted float32 value, in Pascals (Pa).

ofbc('BME280_HUM_FL') = 1220;                         %The current BM280 humidity reading as a converted float32 value, in percent (%).
ofbc('BME680_HUM_FL') = 1221;                         %The current BME680 humidity reading as a converted float32 value, in percent (%).

ofbc('BME680_GAS_FL') = 1230;                         %The current BME680 gas resistance reading as a converted float32 value, in units of kOhms

ofbc('VL53L0X_DIST') = 1300;                          %The current VL53L0X distance reading as a 16-bit integer, in millimeters (-1 indicates out-of-range).
ofbc('VL53L0X_FAIL') = 1301;                          %Indicates the VL53L0X sensor experienced a range failure.

ofbc('SGP30_SN') = 1400;                              %The serial number of the SGP30.

ofbc('SGP30_EC02') = 1410;                            %The current SGp30 eCO2 reading distance reading as a 16-bit integer, in parts per million (ppm).

ofbc('SGP30_TVOC') = 1420;                            %The current SGp30 TVOC reading distance reading as a 16-bit integer, in parts per million (ppm).

ofbc('MLX90640_DEVICE_ID') = 1500;                    %The MLX90640 unique device ID saved in the device's EEPROM.
ofbc('MLX90640_EEPROM_DUMP') = 1501;                  %Raw download of the entire MLX90640 EEPROM, as unsigned 16-bit integers.
ofbc('MLX90640_ADC_RES') = 1502;                      %ADC resolution setting on the MLX90640 (16-, 17-, 18-, or 19-bit).
ofbc('MLX90640_REFRESH_RATE') = 1503;                 %Current refresh rate on the MLX90640 (0.25, 0.5, 1, 2, 4, 8, 16, or 32 Hz).
ofbc('MLX90640_I2C_CLOCKRATE') = 1504;                %Current I2C clock freqency used with the MLX90640 (100, 400, or 1000 kHz).

ofbc('MLX90640_PIXELS_TO') = 1510;                    %The current MLX90640 pixel readings as converted float32 values, in Celsius.
ofbc('MLX90640_PIXELS_IM') = 1511;                    %The current MLX90640 pixel readings as converted, but uncalibrationed, float32 values.
ofbc('MLX90640_PIXELS_INT') = 1512;                   %The current MLX90640 pixel readings as a raw, unsigned 16-bit integers.

ofbc('MLX90640_I2C_TIME') = 1520;                     %The I2C transfer time of the frame data from the MLX90640 to the microcontroller, in milliseconds.
ofbc('MLX90640_CALC_TIME') = 1521;                    %The calculation time for the uncalibrated or calibrated image captured by the MLX90640.
ofbc('MLX90640_IM_WRITE_TIME') = 1522;                %The SD card write time for the MLX90640 float32 image data.
ofbc('MLX90640_INT_WRITE_TIME') = 1523;               %The SD card write time for the MLX90640 raw uint16 data.

ofbc('ALSPT19_LIGHT') = 1600;                         %The current analog value of the ALS-PT19 ambient light sensor, as an unsigned integer ADC value.

ofbc('ZMOD4410_MOX_BOUND') = 1700;                    %The current lower and upper bounds for the ZMOD4410 ADC reading used in calculations.
ofbc('ZMOD4410_CONFIG_PARAMS') = 1701;                %Current configuration values for the ZMOD4410.
ofbc('ZMOD4410_ERROR') = 1702;                        %Timestamped ZMOD4410 error event.
ofbc('ZMOD4410_READING_FL') = 1703;                   %Timestamped ZMOD4410 reading calibrated and converted to float32.
ofbc('ZMOD4410_READING_INT') = 1704;                  %Timestamped ZMOD4410 reading saved as the raw uint16 ADC value.

ofbc('ZMOD4410_ECO2') = 1710;                         %Timestamped ZMOD4410 eCO2 reading.
ofbc('ZMOD4410_IAQ') = 1711;                          %Timestamped ZMOD4410 indoor air quality reading.
ofbc('ZMOD4410_TVOC') = 1712;                         %Timestamped ZMOD4410 total volatile organic compound reading.
ofbc('ZMOD4410_R_CDA') = 1713;                        %Timestamped ZMOD4410 total volatile organic compound reading.

ofbc('LSM303_ACC_SETTINGS') = 1800;                   %Current accelerometer reading settings on any enabled LSM303.
ofbc('LSM303_MAG_SETTINGS') = 1801;                   %Current magnetometer reading settings on any enabled LSM303.
ofbc('LSM303_ACC_FL') = 1802;                         %Current readings from the LSM303 accelerometer, as float values in m/s^2.
ofbc('LSM303_MAG_FL') = 1803;                         %Current readings from the LSM303 magnetometer, as float values in uT.
ofbc('LSM303_TEMP_FL') = 1804;                        %Current readings from the LSM303 temperature sensor, as float value in degrees Celcius

ofbc('SPECTRO_WAVELEN') = 1900;                       %Spectrometer wavelengths, in nanometers.
ofbc('SPECTRO_TRACE') = 1901;                         %Spectrometer measurement trace.

ofbc('PELLET_DISPENSE') = 2000;                       %Timestamped event for feeding/pellet dispensing.
ofbc('PELLET_FAILURE') = 2001;                        %Timestamped event for feeding/pellet dispensing in which no pellet was detected.

ofbc('HARD_PAUSE_START') = 2010;                      %Timestamped event marker for the start of a session pause, with no events recorded during the pause.
ofbc('HARD_PAUSE_STOP') = 2011;                       %Timestamped event marker for the stop of a session pause, with no events recorded during the pause.
ofbc('SOFT_PAUSE_START') = 2012;                      %Timestamped event marker for the start of a session pause, with non-operant events recorded during the pause.
ofbc('SOFT_PAUSE_STOP') = 2013;                       %Timestamped event marker for the stop of a session pause, with non-operant events recorded during the pause.
ofbc('TRIAL_START_SERIAL_DATE') = 2014;               %Timestamped event marker for the start of a trial, with accompanying microsecond clock reading

ofbc('POSITION_START_X') = 2020;                      %Starting position of an autopositioner in just the x-direction, with distance in millimeters.
ofbc('POSITION_MOVE_X') = 2021;                       %Timestamped movement of an autopositioner in just the x-direction, with distance in millimeters.
ofbc('POSITION_START_XY') = 2022;                     %Starting position of an autopositioner in just the x- and y-directions, with distance in millimeters.
ofbc('POSITION_MOVE_XY') = 2023;                      %Timestamped movement of an autopositioner in just the x- and y-directions, with distance in millimeters.
ofbc('POSITION_START_XYZ') = 2024;                    %Starting position of an autopositioner in the x-, y-, and z- directions, with distance in millimeters.
ofbc('POSITION_MOVE_XYZ') = 2025;                     %Timestamped movement of an autopositioner in the x-, y-, and z- directions, with distance in millimeters.

ofbc('TTL_PULSETRAIN') = 2048;                        %Timestamped event for a single TTL pulse output, with channel number, voltage, pulse duration, inter-pulse period, and number of pulses.
ofbc('TTL_PULSETRAIN_ABORT') = 2049;                  %Timestamped event for when a TTL pulsetrain is canceled before completion.

ofbc('STREAM_INPUT_NAME') = 2100;                     %Stream input name for the specified input index.

ofbc('CALIBRATION_BASELINE') = 2200;                  %Starting calibration baseline coefficient, for the specified module index.
ofbc('CALIBRATION_SLOPE') = 2201;                     %Starting calibration slope coefficient, for the specified module index.
ofbc('CALIBRATION_BASELINE_ADJUST') = 2202;           %Timestamped in-session calibration baseline coefficient adjustment, for the specified module index.
ofbc('CALIBRATION_SLOPE_ADJUST') = 2203;              %Timestamped in-session calibration slope coefficient adjustment, for the specified module index.
ofbc('CALIBRATION_DATE') = 2204;                      %Most recent calibration date/time, for the specified module index.

ofbc('HIT_THRESH_TYPE') = 2300;                       %Type of hit threshold (i.e. peak force), for the specified input.

ofbc('SECONDARY_THRESH_NAME') = 2310;                 %A name/description of secondary thresholds used in the behavior.

ofbc('INIT_THRESH_TYPE') = 2320;                      %Type of initation threshold (i.e. force or touch), for the specified input.

ofbc('REMOTE_MANUAL_FEED') = 2400;                    %A timestamped manual feed event, triggered remotely.
ofbc('HWUI_MANUAL_FEED') = 2401;                      %A timestamped manual feed event, triggered from the hardware user interface.
ofbc('FW_RANDOM_FEED') = 2402;                        %A timestamped manual feed event, triggered randomly by the firmware.
ofbc('SWUI_MANUAL_FEED_DEPRECATED') = 2403;           %A timestamped manual feed event, triggered from a computer software user interface.
ofbc('FW_OPERANT_FEED') = 2404;                       %A timestamped operant-rewarded feed event, trigged by the OmniHome firmware, with the possibility of multiple feedings.
ofbc('SWUI_MANUAL_FEED') = 2405;                      %A timestamped manual feed event, triggered from a computer software user interface.
ofbc('SW_RANDOM_FEED') = 2406;                        %A timestamped manual feed event, triggered randomly by computer software.
ofbc('SW_OPERANT_FEED') = 2407;                       %A timestamped operant-rewarded feed event, trigged by the PC-based behavioral software, with the possibility of multiple feedings.

ofbc('MOTOTRAK_V3P0_OUTCOME') = 2500;                 %MotoTrak version 3.0 trial outcome data.
ofbc('MOTOTRAK_V3P0_SIGNAL') = 2501;                  %MotoTrak version 3.0 trial stream signal.

ofbc('POKE_BITMASK') = 2560;                          %Nosepoke status bitmask, typically written only when it changes.

ofbc('CAPSENSE_BITMASK') = 2576;                      %Capacitive sensor status bitmask, typically written only when it changes.
ofbc('CAPSENSE_VALUE') = 2577;                        %Capacitive sensor reading for one sensor, in ADC ticks or clock cycles.

ofbc('OUTPUT_TRIGGER_NAME') = 2600;                   %Name/description of the output trigger type for the given index.

ofbc('VIBRATION_TASK_TRIAL_OUTCOME') = 2700;          %Vibration task trial outcome data.
ofbc('VIBROTACTILE_DETECTION_TASK_TRIAL') = 2701;     %Vibrotactile detection task trial data.

ofbc('LED_DETECTION_TASK_TRIAL_OUTCOME') = 2710;      %LED detection task trial outcome data.
ofbc('LIGHT_SRC_MODEL') = 2711;                       %Light source model name.
ofbc('LIGHT_SRC_TYPE') = 2712;                        %Light source type (i.e. LED, LASER, etc).

ofbc('STTC_2AFC_TRIAL_OUTCOME') = 2720;               %SensiTrak tactile discrimination task trial outcome data.
ofbc('STTC_NUM_PADS') = 2721;                         %Number of pads on the SensiTrak Tactile Carousel module.
ofbc('MODULE_MICROSTEP') = 2722;                      %Microstep setting on the specified OTMP module.
ofbc('MODULE_STEPS_PER_ROT') = 2723;                  %Steps per rotation on the specified OTMP module.

ofbc('MODULE_PITCH_CIRC') = 2730;                     %Pitch circumference, in millimeters, of the driving gear on the specified OTMP module.
ofbc('MODULE_CENTER_OFFSET') = 2731;                  %Center offset, in millimeters, for the specified OTMP module.

ofbc('STAP_2AFC_TRIAL_OUTCOME') = 2740;               %SensiTrak proprioception discrimination task trial outcome data.

ofbc('FR_TASK_TRIAL') = 2800;                         %Fixed reinforcement task trial data.

ofbc('SCOPE_TRACE') = 3072;                           %An oscilloscope recording, in units of volts, from one or multiple channels, with time units, in seconds, along with a variable number of parameters describing the recording conditions.
