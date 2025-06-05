/*
	OmniTrak_File_Block_Codes.h

	Vulintus, Inc.

	OmniTrak File Format Block Codes (OFBC) Libary

	Library documentation:
	https://github.com/Vulintus/OmniTrak_File_Format

	This file was programmatically generated: 2025-06-05, 04:13:26 (UTC)
*/

#ifndef _VULINTUS_OFBC_BLOCK_CODES_H_
#define _VULINTUS_OFBC_BLOCK_CODES_H_

#ifndef OFBC_DEF_VERSION
	#define OFBC_DEF_VERSION		1
#endif
#define OFBC_CUR_DEF_VERSION	OFBC_DEF_VERSION

const uint16_t OFBC_OMNITRAK_FILE_VERIFY = 0xABCD;                 // First unsigned 16-bit integer written to every *.OmniTrak file to identify the file type, has a hex value of 0xABCD.

const uint16_t OFBC_FILE_VERSION = 0x0001;                         // The version of the file format used.
const uint16_t OFBC_MS_FILE_START = 0x0002;                        // Value of the SoC millisecond clock at file creation.
const uint16_t OFBC_MS_FILE_STOP = 0x0003;                         // Value of the SoC millisecond clock when the file is closed.
const uint16_t OFBC_SUBJECT_DEPRECATED = 0x0004;                   // A single subject's name.

const uint16_t OFBC_CLOCK_FILE_START = 0x0006;                     // Computer clock serial date number at file creation (local time).
const uint16_t OFBC_CLOCK_FILE_STOP = 0x0007;                      // Computer clock serial date number when the file is closed (local time).

const uint16_t OFBC_DEVICE_FILE_INDEX = 0x000A;                    // The device's current file index.

const uint16_t OFBC_NTP_SYNC = 0x0014;                             // A fetched NTP time (seconds since January 1, 1900) at the specified SoC millisecond clock time.
const uint16_t OFBC_NTP_SYNC_FAIL = 0x0015;                        // Indicates the an NTP synchonization attempt failed.
const uint16_t OFBC_CLOCK_SYNC = 0x0016;                           // The current serial date number, millisecond clock reading, and/or microsecond clock reading at a single timepoint.
const uint16_t OFBC_MS_TIMER_ROLLOVER = 0x0017;                    // Indicates that the millisecond timer rolled over since the last loop.
const uint16_t OFBC_US_TIMER_ROLLOVER = 0x0018;                    // Indicates that the microsecond timer rolled over since the last loop.
const uint16_t OFBC_TIME_ZONE_OFFSET = 0x0019;                     // Computer clock time zone offset from UTC.
const uint16_t OFBC_TIME_ZONE_OFFSET_HHMM = 0x001A;                // Computer clock time zone offset from UTC as two integers, one for hours, and the other for minutes

const uint16_t OFBC_RTC_STRING_DEPRECATED = 0x001E;                // Current date/time string from the real-time clock.
const uint16_t OFBC_RTC_STRING = 0x001F;                           // Current date/time string from the real-time clock.
const uint16_t OFBC_RTC_VALUES = 0x0020;                           // Current date/time values from the real-time clock.

const uint16_t OFBC_ORIGINAL_FILENAME = 0x0028;                    // The original filename for the data file.
const uint16_t OFBC_RENAMED_FILE = 0x0029;                         // A timestamped event to indicate when a file has been renamed by one of Vulintus' automatic data organizing programs.
const uint16_t OFBC_DOWNLOAD_TIME = 0x002A;                        // A timestamp indicating when the data file was downloaded from the OmniTrak device to a computer.
const uint16_t OFBC_DOWNLOAD_SYSTEM = 0x002B;                      // The computer system name and the COM port used to download the data file form the OmniTrak device.

const uint16_t OFBC_INCOMPLETE_BLOCK = 0x0032;                     // Indicates that the file will end in an incomplete block.

const uint16_t OFBC_USER_TIME = 0x003C;                            // Date/time values from a user-set timestamp.

const uint16_t OFBC_SYSTEM_TYPE = 0x0064;                          // Vulintus system ID code (1 = MotoTrak, 2 = OmniTrak, 3 = HabiTrak, 4 = OmniHome, 5 = SensiTrak, 6 = Prototype).
const uint16_t OFBC_SYSTEM_NAME = 0x0065;                          // Vulintus system name.
const uint16_t OFBC_SYSTEM_HW_VER = 0x0066;                        // Vulintus system hardware version.
const uint16_t OFBC_SYSTEM_FW_VER = 0x0067;                        // System firmware version, written as characters.
const uint16_t OFBC_SYSTEM_SN = 0x0068;                            // System serial number, written as characters.
const uint16_t OFBC_SYSTEM_MFR = 0x0069;                           // Manufacturer name for non-Vulintus systems.
const uint16_t OFBC_COMPUTER_NAME = 0x006A;                        // Windows PC computer name.
const uint16_t OFBC_COM_PORT = 0x006B;                             // The COM port of a computer-connected system.
const uint16_t OFBC_DEVICE_ALIAS = 0x006C;                         // Human-readable Adjective + Noun alias/name for the device, assigned by Vulintus during manufacturing.

const uint16_t OFBC_PRIMARY_MODULE = 0x006E;                       // Primary module name, for systems with interchangeable modules.
const uint16_t OFBC_PRIMARY_INPUT = 0x006F;                        // Primary input name, for modules with multiple input signals.
const uint16_t OFBC_SAMD_CHIP_ID = 0x0070;                         // The SAMD manufacturer's unique chip identifier.

const uint16_t OFBC_ESP8266_MAC_ADDR = 0x0078;                     // The MAC address of the device's ESP8266 module.
const uint16_t OFBC_ESP8266_IP4_ADDR = 0x0079;                     // The local IPv4 address of the device's ESP8266 module.
const uint16_t OFBC_ESP8266_CHIP_ID = 0x007A;                      // The ESP8266 manufacturer's unique chip identifier
const uint16_t OFBC_ESP8266_FLASH_ID = 0x007B;                     // The ESP8266 flash chip's unique chip identifier

const uint16_t OFBC_USER_SYSTEM_NAME = 0x0082;                     // The user's name for the system, i.e. booth number.

const uint16_t OFBC_DEVICE_RESET_COUNT = 0x008C;                   // The current reboot count saved in EEPROM or flash memory.
const uint16_t OFBC_CTRL_FW_FILENAME = 0x008D;                     // Controller firmware filename, copied from the macro, written as characters.
const uint16_t OFBC_CTRL_FW_DATE = 0x008E;                         // Controller firmware upload date, copied from the macro, written as characters.
const uint16_t OFBC_CTRL_FW_TIME = 0x008F;                         // Controller firmware upload time, copied from the macro, written as characters.
const uint16_t OFBC_MODULE_FW_FILENAME = 0x0090;                   // OTMP Module firmware filename, copied from the macro, written as characters.
const uint16_t OFBC_MODULE_FW_DATE = 0x0091;                       // OTMP Module firmware upload date, copied from the macro, written as characters.
const uint16_t OFBC_MODULE_FW_TIME = 0x0092;                       // OTMP Module firmware upload time, copied from the macro, written as characters.

const uint16_t OFBC_WINC1500_MAC_ADDR = 0x0096;                    // The MAC address of the device's ATWINC1500 module.
const uint16_t OFBC_WINC1500_IP4_ADDR = 0x0097;                    // The local IPv4 address of the device's ATWINC1500 module.

const uint16_t OFBC_BATTERY_SOC = 0x00AA;                          // Current battery state-of charge, in percent, measured the BQ27441
const uint16_t OFBC_BATTERY_VOLTS = 0x00AB;                        // Current battery voltage, in millivolts, measured by the BQ27441
const uint16_t OFBC_BATTERY_CURRENT = 0x00AC;                      // Average current draw from the battery, in milli-amps, measured by the BQ27441
const uint16_t OFBC_BATTERY_FULL = 0x00AD;                         // Full capacity of the battery, in milli-amp hours, measured by the BQ27441
const uint16_t OFBC_BATTERY_REMAIN = 0x00AE;                       // Remaining capacity of the battery, in milli-amp hours, measured by the BQ27441
const uint16_t OFBC_BATTERY_POWER = 0x00AF;                        // Average power draw, in milliWatts, measured by the BQ27441
const uint16_t OFBC_BATTERY_SOH = 0x00B0;                          // Battery state-of-health, in percent, measured by the BQ27441
const uint16_t OFBC_BATTERY_STATUS = 0x00B1;                       // Combined battery state-of-charge, voltage, current, capacity, power, and state-of-health, measured by the BQ27441

const uint16_t OFBC_FEED_SERVO_MAX_RPM = 0x00BE;                   // Actual rotation rate, in RPM, of the feeder servo (OmniHome) when set to 180 speed.
const uint16_t OFBC_FEED_SERVO_SPEED = 0x00BF;                     // Current speed setting (0-180) for the feeder servo (OmniHome).

const uint16_t OFBC_SUBJECT_NAME = 0x00C8;                         // A single subject's name.
const uint16_t OFBC_GROUP_NAME = 0x00C9;                           // The subject's or subjects' experimental group name.

const uint16_t OFBC_EXP_NAME = 0x012C;                             // The user's name for the current experiment.
const uint16_t OFBC_TASK_TYPE = 0x012D;                            // The user's name for task type, which can be a variant of the overall experiment type.

const uint16_t OFBC_STAGE_NAME = 0x0190;                           // The stage name for a behavioral session.
const uint16_t OFBC_STAGE_DESCRIPTION = 0x0191;                    // The stage description for a behavioral session.

const uint16_t OFBC_AMG8833_ENABLED = 0x03E8;                      // Indicates that an AMG8833 thermopile array sensor is present in the system.
const uint16_t OFBC_BMP280_ENABLED = 0x03E9;                       // Indicates that an BMP280 temperature/pressure sensor is present in the system.
const uint16_t OFBC_BME280_ENABLED = 0x03EA;                       // Indicates that an BME280 temperature/pressure/humidty sensor is present in the system.
const uint16_t OFBC_BME680_ENABLED = 0x03EB;                       // Indicates that an BME680 temperature/pressure/humidy/VOC sensor is present in the system.
const uint16_t OFBC_CCS811_ENABLED = 0x03EC;                       // Indicates that an CCS811 VOC/eC02 sensor is present in the system.
const uint16_t OFBC_SGP30_ENABLED = 0x03ED;                        // Indicates that an SGP30 VOC/eC02 sensor is present in the system.
const uint16_t OFBC_VL53L0X_ENABLED = 0x03EE;                      // Indicates that an VL53L0X time-of-flight distance sensor is present in the system.
const uint16_t OFBC_ALSPT19_ENABLED = 0x03EF;                      // Indicates that an ALS-PT19 ambient light sensor is present in the system.
const uint16_t OFBC_MLX90640_ENABLED = 0x03F0;                     // Indicates that an MLX90640 thermopile array sensor is present in the system.
const uint16_t OFBC_ZMOD4410_ENABLED = 0x03F1;                     // Indicates that an ZMOD4410 VOC/eC02 sensor is present in the system.

const uint16_t OFBC_AMBULATION_XY_THETA = 0x0400;                  // A point in a tracked ambulation path, with absolute x- and y-coordinates in millimeters, with facing direction theta, in degrees.

const uint16_t OFBC_AMG8833_THERM_CONV = 0x044C;                   // The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature.
const uint16_t OFBC_AMG8833_THERM_FL = 0x044D;                     // The current AMG8833 thermistor reading as a converted float32 value, in Celsius.
const uint16_t OFBC_AMG8833_THERM_INT = 0x044E;                    // The current AMG8833 thermistor reading as a raw, signed 16-bit integer.

const uint16_t OFBC_AMG8833_PIXELS_CONV = 0x0456;                  // The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature.
const uint16_t OFBC_AMG8833_PIXELS_FL = 0x0457;                    // The current AMG8833 pixel readings as converted float32 values, in Celsius.
const uint16_t OFBC_AMG8833_PIXELS_INT = 0x0458;                   // The current AMG8833 pixel readings as a raw, signed 16-bit integers.
const uint16_t OFBC_HTPA32X32_PIXELS_FP62 = 0x0459;                // The current HTPA32x32 pixel readings as a fixed-point 6/2 type (6 bits for the unsigned integer part, 2 bits for the decimal part), in units of Celcius. This allows temperatures from 0 to 63.75 C.
const uint16_t OFBC_HTPA32X32_PIXELS_INT_K = 0x045A;               // The current HTPA32x32 pixel readings represented as 16-bit unsigned integers in units of deciKelvin (dK, or Kelvin * 10).
const uint16_t OFBC_HTPA32X32_AMBIENT_TEMP = 0x045B;               // The current ambient temperature measured by the HTPA32x32, represented as a 32-bit float, in units of Celcius.
const uint16_t OFBC_HTPA32X32_PIXELS_INT12_C = 0x045C;             // The current HTPA32x32 pixel readings represented as 12-bit signed integers (2 pixels for every 3 bytes) in units of deciCelsius (dC, or Celsius * 10), with values under-range set to the minimum  (2048 dC) and values over-range set to the maximum (2047 dC).
const uint16_t OFBC_HTPA32X32_HOTTEST_PIXEL_FP62 = 0x045D;         // The location and temperature of the hottest pixel in the HTPA32x32 image. This may not be the raw hottest pixel. It may have gone through some processing and filtering to determine the true hottest pixel. The temperature will be in FP62 formatted Celsius.

const uint16_t OFBC_BH1749_RGB = 0x0460;                           // The current red, green, blue, IR, and green2 sensor readings from the BH1749 sensor
const uint16_t OFBC_DEBUG_SANITY_CHECK = 0x0461;                   // A special block acting as a sanity check, only used in cases of debugging

const uint16_t OFBC_BME280_TEMP_FL = 0x04B0;                       // The current BME280 temperature reading as a converted float32 value, in Celsius.
const uint16_t OFBC_BMP280_TEMP_FL = 0x04B1;                       // The current BMP280 temperature reading as a converted float32 value, in Celsius.
const uint16_t OFBC_BME680_TEMP_FL = 0x04B2;                       // The current BME680 temperature reading as a converted float32 value, in Celsius.

const uint16_t OFBC_BME280_PRES_FL = 0x04BA;                       // The current BME280 pressure reading as a converted float32 value, in Pascals (Pa).
const uint16_t OFBC_BMP280_PRES_FL = 0x04BB;                       // The current BMP280 pressure reading as a converted float32 value, in Pascals (Pa).
const uint16_t OFBC_BME680_PRES_FL = 0x04BC;                       // The current BME680 pressure reading as a converted float32 value, in Pascals (Pa).

const uint16_t OFBC_BME280_HUM_FL = 0x04C4;                        // The current BM280 humidity reading as a converted float32 value, in percent (%).
const uint16_t OFBC_BME680_HUM_FL = 0x04C5;                        // The current BME680 humidity reading as a converted float32 value, in percent (%).

const uint16_t OFBC_BME680_GAS_FL = 0x04CE;                        // The current BME680 gas resistance reading as a converted float32 value, in units of kOhms

const uint16_t OFBC_VL53L0X_DIST = 0x0514;                         // The current VL53L0X distance reading as a 16-bit integer, in millimeters (-1 indicates out-of-range).
const uint16_t OFBC_VL53L0X_FAIL = 0x0515;                         // Indicates the VL53L0X sensor experienced a range failure.

const uint16_t OFBC_SGP30_SN = 0x0578;                             // The serial number of the SGP30.

const uint16_t OFBC_SGP30_EC02 = 0x0582;                           // The current SGp30 eCO2 reading distance reading as a 16-bit integer, in parts per million (ppm).

const uint16_t OFBC_SGP30_TVOC = 0x058C;                           // The current SGp30 TVOC reading distance reading as a 16-bit integer, in parts per million (ppm).

const uint16_t OFBC_MLX90640_DEVICE_ID = 0x05DC;                   // The MLX90640 unique device ID saved in the device's EEPROM.
const uint16_t OFBC_MLX90640_EEPROM_DUMP = 0x05DD;                 // Raw download of the entire MLX90640 EEPROM, as unsigned 16-bit integers.
const uint16_t OFBC_MLX90640_ADC_RES = 0x05DE;                     // ADC resolution setting on the MLX90640 (16-, 17-, 18-, or 19-bit).
const uint16_t OFBC_MLX90640_REFRESH_RATE = 0x05DF;                // Current refresh rate on the MLX90640 (0.25, 0.5, 1, 2, 4, 8, 16, or 32 Hz).
const uint16_t OFBC_MLX90640_I2C_CLOCKRATE = 0x05E0;               // Current I2C clock freqency used with the MLX90640 (100, 400, or 1000 kHz).

const uint16_t OFBC_MLX90640_PIXELS_TO = 0x05E6;                   // The current MLX90640 pixel readings as converted float32 values, in Celsius.
const uint16_t OFBC_MLX90640_PIXELS_IM = 0x05E7;                   // The current MLX90640 pixel readings as converted, but uncalibrationed, float32 values.
const uint16_t OFBC_MLX90640_PIXELS_INT = 0x05E8;                  // The current MLX90640 pixel readings as a raw, unsigned 16-bit integers.

const uint16_t OFBC_MLX90640_I2C_TIME = 0x05F0;                    // The I2C transfer time of the frame data from the MLX90640 to the microcontroller, in milliseconds.
const uint16_t OFBC_MLX90640_CALC_TIME = 0x05F1;                   // The calculation time for the uncalibrated or calibrated image captured by the MLX90640.
const uint16_t OFBC_MLX90640_IM_WRITE_TIME = 0x05F2;               // The SD card write time for the MLX90640 float32 image data.
const uint16_t OFBC_MLX90640_INT_WRITE_TIME = 0x05F3;              // The SD card write time for the MLX90640 raw uint16 data.

const uint16_t OFBC_ALSPT19_LIGHT = 0x0640;                        // The current analog value of the ALS-PT19 ambient light sensor, as an unsigned integer ADC value.

const uint16_t OFBC_ZMOD4410_MOX_BOUND = 0x06A4;                   // The current lower and upper bounds for the ZMOD4410 ADC reading used in calculations.
const uint16_t OFBC_ZMOD4410_CONFIG_PARAMS = 0x06A5;               // Current configuration values for the ZMOD4410.
const uint16_t OFBC_ZMOD4410_ERROR = 0x06A6;                       // Timestamped ZMOD4410 error event.
const uint16_t OFBC_ZMOD4410_READING_FL = 0x06A7;                  // Timestamped ZMOD4410 reading calibrated and converted to float32.
const uint16_t OFBC_ZMOD4410_READING_INT = 0x06A8;                 // Timestamped ZMOD4410 reading saved as the raw uint16 ADC value.

const uint16_t OFBC_ZMOD4410_ECO2 = 0x06AE;                        // Timestamped ZMOD4410 eCO2 reading.
const uint16_t OFBC_ZMOD4410_IAQ = 0x06AF;                         // Timestamped ZMOD4410 indoor air quality reading.
const uint16_t OFBC_ZMOD4410_TVOC = 0x06B0;                        // Timestamped ZMOD4410 total volatile organic compound reading.
const uint16_t OFBC_ZMOD4410_R_CDA = 0x06B1;                       // Timestamped ZMOD4410 total volatile organic compound reading.

const uint16_t OFBC_LSM303_ACC_SETTINGS = 0x0708;                  // Current accelerometer reading settings on any enabled LSM303.
const uint16_t OFBC_LSM303_MAG_SETTINGS = 0x0709;                  // Current magnetometer reading settings on any enabled LSM303.
const uint16_t OFBC_LSM303_ACC_FL = 0x070A;                        // Current readings from the LSM303 accelerometer, as float values in m/s^2.
const uint16_t OFBC_LSM303_MAG_FL = 0x070B;                        // Current readings from the LSM303 magnetometer, as float values in uT.
const uint16_t OFBC_LSM303_TEMP_FL = 0x070C;                       // Current readings from the LSM303 temperature sensor, as float value in degrees Celcius

const uint16_t OFBC_SPECTRO_WAVELEN = 0x076C;                      // Spectrometer wavelengths, in nanometers.
const uint16_t OFBC_SPECTRO_TRACE = 0x076D;                        // Spectrometer measurement trace.

const uint16_t OFBC_PELLET_DISPENSE = 0x07D0;                      // Timestamped event for feeding/pellet dispensing.
const uint16_t OFBC_PELLET_FAILURE = 0x07D1;                       // Timestamped event for feeding/pellet dispensing in which no pellet was detected.

const uint16_t OFBC_HARD_PAUSE_START = 0x07DA;                     // Timestamped event marker for the start of a session pause, with no events recorded during the pause.
const uint16_t OFBC_HARD_PAUSE_STOP = 0x07DB;                      // Timestamped event marker for the stop of a session pause, with no events recorded during the pause.
const uint16_t OFBC_SOFT_PAUSE_START = 0x07DC;                     // Timestamped event marker for the start of a session pause, with non-operant events recorded during the pause.
const uint16_t OFBC_SOFT_PAUSE_STOP = 0x07DD;                      // Timestamped event marker for the stop of a session pause, with non-operant events recorded during the pause.
const uint16_t OFBC_TRIAL_START_SERIAL_DATE = 0x07DE;              // Timestamped event marker for the start of a trial, with accompanying microsecond clock reading

const uint16_t OFBC_POSITION_START_X = 0x07E4;                     // Starting position of an autopositioner in just the x-direction, with distance in millimeters.
const uint16_t OFBC_POSITION_MOVE_X = 0x07E5;                      // Timestamped movement of an autopositioner in just the x-direction, with distance in millimeters.
const uint16_t OFBC_POSITION_START_XY = 0x07E6;                    // Starting position of an autopositioner in just the x- and y-directions, with distance in millimeters.
const uint16_t OFBC_POSITION_MOVE_XY = 0x07E7;                     // Timestamped movement of an autopositioner in just the x- and y-directions, with distance in millimeters.
const uint16_t OFBC_POSITION_START_XYZ = 0x07E8;                   // Starting position of an autopositioner in the x-, y-, and z- directions, with distance in millimeters.
const uint16_t OFBC_POSITION_MOVE_XYZ = 0x07E9;                    // Timestamped movement of an autopositioner in the x-, y-, and z- directions, with distance in millimeters.

const uint16_t OFBC_TTL_PULSE = 0x0800;                            // Timestamped event for a TTL pulse output, with channel number, voltage, and duration.

const uint16_t OFBC_STREAM_INPUT_NAME = 0x0834;                    // Stream input name for the specified input index.

const uint16_t OFBC_CALIBRATION_BASELINE = 0x0898;                 // Starting calibration baseline coefficient, for the specified module index.
const uint16_t OFBC_CALIBRATION_SLOPE = 0x0899;                    // Starting calibration slope coefficient, for the specified module index.
const uint16_t OFBC_CALIBRATION_BASELINE_ADJUST = 0x089A;          // Timestamped in-session calibration baseline coefficient adjustment, for the specified module index.
const uint16_t OFBC_CALIBRATION_SLOPE_ADJUST = 0x089B;             // Timestamped in-session calibration slope coefficient adjustment, for the specified module index.

const uint16_t OFBC_HIT_THRESH_TYPE = 0x08FC;                      // Type of hit threshold (i.e. peak force), for the specified input.

const uint16_t OFBC_SECONDARY_THRESH_NAME = 0x0906;                // A name/description of secondary thresholds used in the behavior.

const uint16_t OFBC_INIT_THRESH_TYPE = 0x0910;                     // Type of initation threshold (i.e. force or touch), for the specified input.

const uint16_t OFBC_REMOTE_MANUAL_FEED = 0x0960;                   // A timestamped manual feed event, triggered remotely.
const uint16_t OFBC_HWUI_MANUAL_FEED = 0x0961;                     // A timestamped manual feed event, triggered from the hardware user interface.
const uint16_t OFBC_FW_RANDOM_FEED = 0x0962;                       // A timestamped manual feed event, triggered randomly by the firmware.
const uint16_t OFBC_SWUI_MANUAL_FEED_DEPRECATED = 0x0963;          // A timestamped manual feed event, triggered from a computer software user interface.
const uint16_t OFBC_FW_OPERANT_FEED = 0x0964;                      // A timestamped operant-rewarded feed event, trigged by the OmniHome firmware, with the possibility of multiple feedings.
const uint16_t OFBC_SWUI_MANUAL_FEED = 0x0965;                     // A timestamped manual feed event, triggered from a computer software user interface.
const uint16_t OFBC_SW_RANDOM_FEED = 0x0966;                       // A timestamped manual feed event, triggered randomly by computer software.
const uint16_t OFBC_SW_OPERANT_FEED = 0x0967;                      // A timestamped operant-rewarded feed event, trigged by the PC-based behavioral software, with the possibility of multiple feedings.

const uint16_t OFBC_MOTOTRAK_V3P0_OUTCOME = 0x09C4;                // MotoTrak version 3.0 trial outcome data.
const uint16_t OFBC_MOTOTRAK_V3P0_SIGNAL = 0x09C5;                 // MotoTrak version 3.0 trial stream signal.

const uint16_t OFBC_POKE_BITMASK = 0x0A00;                         // Nosepoke status bitmask, typically written only when it changes.

const uint16_t OFBC_CAPSENSE_BITMASK = 0x0A10;                     // Capacitive sensor status bitmask, typically written only when it changes.
const uint16_t OFBC_CAPSENSE_VALUE = 0x0A11;                       // Capacitive sensor reading for one sensor, in ADC ticks or clock cycles.

const uint16_t OFBC_OUTPUT_TRIGGER_NAME = 0x0A28;                  // Name/description of the output trigger type for the given index.

const uint16_t OFBC_VIBRATION_TASK_TRIAL_OUTCOME = 0x0A8C;         // Vibration task trial outcome data.
const uint16_t OFBC_VIBROTACTILE_DETECTION_TASK_TRIAL = 0x0A8D;    // Vibrotactile detection task trial data.

const uint16_t OFBC_LED_DETECTION_TASK_TRIAL_OUTCOME = 0x0A96;     // LED detection task trial outcome data.
const uint16_t OFBC_LIGHT_SRC_MODEL = 0x0A97;                      // Light source model name.
const uint16_t OFBC_LIGHT_SRC_TYPE = 0x0A98;                       // Light source type (i.e. LED, LASER, etc).

const uint16_t OFBC_STTC_2AFC_TRIAL_OUTCOME = 0x0AA0;              // SensiTrak tactile discrimination task trial outcome data.
const uint16_t OFBC_STTC_NUM_PADS = 0x0AA1;                        // Number of pads on the SensiTrak Tactile Carousel module.
const uint16_t OFBC_MODULE_MICROSTEP = 0x0AA2;                     // Microstep setting on the specified OTMP module.
const uint16_t OFBC_MODULE_STEPS_PER_ROT = 0x0AA3;                 // Steps per rotation on the specified OTMP module.

const uint16_t OFBC_MODULE_PITCH_CIRC = 0x0AAA;                    // Pitch circumference, in millimeters, of the driving gear on the specified OTMP module.
const uint16_t OFBC_MODULE_CENTER_OFFSET = 0x0AAB;                 // Center offset, in millimeters, for the specified OTMP module.

const uint16_t OFBC_STAP_2AFC_TRIAL_OUTCOME = 0x0AB4;              // SensiTrak proprioception discrimination task trial outcome data.

const uint16_t OFBC_FR_TASK_TRIAL = 0x0AF0;                        // Fixed reinforcement task trial data.

#endif                                                             // #ifndef _VULINTUS_OFBC_BLOCK_CODES_H_
