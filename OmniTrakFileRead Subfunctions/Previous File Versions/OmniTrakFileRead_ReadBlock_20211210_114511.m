function data = OmniTrakFileRead_ReadBlock(fid,block,data,verbose)

%OMNITRAKFILEREAD_READ_BLOCK.m
%
%	Vulintus, Inc.
%
%	OmniTrak file block read subfunction router.
%
%	Library V1 documentation:
%	https://docs.google.com/spreadsheets/d/e/2PACX-1vSt8EQXvF5DNkU8MrZYNL_1TcYMDagQc-U6WyK51xt2nk6oHyXr6Z0jQPUfQTLzla4QNMagKPDmxKJ0/pubhtml
%
%	This function was programmatically generated: 10-Dec-2021 11:45:08
%

block_codes = Load_OmniTrak_File_Block_Codes(data.file_version);

if verbose == 1
	block_names = fieldnames(block_codes)';
	for f = block_names
		if block_codes.(f{1}) == block
			fprintf(1,'b%1.0f\t>>\t%1.0f: %s\n',ftell(fid)-2,block,f{1});
		end
	end
end

switch data.file_version

	case 1

		switch block

			case block_codes.FILE_VERSION                                   %The version of the file format used.
				data = OmniTrakFileRead_ReadBlock_V1_FILE_VERSION(fid,data);

			case block_codes.MS_FILE_START                                  %Value of the SoC millisecond clock at file creation.
				data = OmniTrakFileRead_ReadBlock_V1_MS_FILE_START(fid,data);

			case block_codes.MS_FILE_STOP                                   %Value of the SoC millisecond clock when the file is closed.
				data = OmniTrakFileRead_ReadBlock_V1_MS_FILE_STOP(fid,data);

			case block_codes.SUBJECT_DEPRECATED                             %A single subject's name.
				data = OmniTrakFileRead_ReadBlock_V1_SUBJECT_DEPRECATED(fid,data);

			case block_codes.CLOCK_FILE_START                               %Computer clock serial date number at file creation (local time).
				data = OmniTrakFileRead_ReadBlock_V1_CLOCK_FILE_START(fid,data);

			case block_codes.CLOCK_FILE_STOP                                %Computer clock serial date number when the file is closed (local time).
				data = OmniTrakFileRead_ReadBlock_V1_CLOCK_FILE_STOP(fid,data);

			case block_codes.DEVICE_FILE_INDEX                              %The device's current file index.
				data = OmniTrakFileRead_ReadBlock_V1_DEVICE_FILE_INDEX(fid,data);

			case block_codes.NTP_SYNC                                       %A fetched NTP time (seconds since January 1, 1900) at the specified SoC millisecond clock time.
				data = OmniTrakFileRead_ReadBlock_V1_NTP_SYNC(fid,data);

			case block_codes.NTP_SYNC_FAIL                                  %Indicates the an NTP synchonization attempt failed.
				data = OmniTrakFileRead_ReadBlock_V1_NTP_SYNC_FAIL(fid,data);

			case block_codes.MS_US_CLOCK_SYNC                               %The current SoC microsecond clock time at the specified SoC millisecond clock time.
				data = OmniTrakFileRead_ReadBlock_V1_MS_US_CLOCK_SYNC(fid,data);

			case block_codes.MS_TIMER_ROLLOVER                              %Indicates that the millisecond timer rolled over since the last loop.
				data = OmniTrakFileRead_ReadBlock_V1_MS_TIMER_ROLLOVER(fid,data);

			case block_codes.US_TIMER_ROLLOVER                              %Indicates tha the microsecond timer rolled over since the last loop.
				data = OmniTrakFileRead_ReadBlock_V1_US_TIMER_ROLLOVER(fid,data);

			case block_codes.TIME_ZONE_OFFSET                               %Computer clock time zone offset from UTC.
				data = OmniTrakFileRead_ReadBlock_V1_TIME_ZONE_OFFSET(fid,data);

			case block_codes.RTC_STRING_DEPRECATED                          %Current date/time string from the real-time clock.
				data = OmniTrakFileRead_ReadBlock_V1_RTC_STRING_DEPRECATED(fid,data);

			case block_codes.RTC_STRING                                     %Current date/time string from the real-time clock.
				data = OmniTrakFileRead_ReadBlock_V1_RTC_STRING(fid,data);

			case block_codes.RTC_VALUES                                     %Current date/time values from the real-time clock.
				data = OmniTrakFileRead_ReadBlock_V1_RTC_VALUES(fid,data);

			case block_codes.ORIGINAL_FILENAME                              %The original filename for the data file.
				data = OmniTrakFileRead_ReadBlock_V1_ORIGINAL_FILENAME(fid,data);

			case block_codes.RENAMED_FILE                                   %A timestamped event to indicate when a file has been renamed by one of Vulintus' automatic data organizing programs.
				data = OmniTrakFileRead_ReadBlock_V1_RENAMED_FILE(fid,data);

			case block_codes.DOWNLOAD_TIME                                  %A timestamp indicating when the data file was downloaded from the OmniTrak device to a computer.
				data = OmniTrakFileRead_ReadBlock_V1_DOWNLOAD_TIME(fid,data);

			case block_codes.DOWNLOAD_SYSTEM                                %The computer system name and the COM port used to download the data file form the OmniTrak device.
				data = OmniTrakFileRead_ReadBlock_V1_DOWNLOAD_SYSTEM(fid,data);

			case block_codes.INCOMPLETE_BLOCK                               %Indicates that the file will end in an incomplete block.
				data = OmniTrakFileRead_ReadBlock_V1_INCOMPLETE_BLOCK(fid,data);

			case block_codes.USER_TIME                                      %Date/time values from a user-set timestamp.
				data = OmniTrakFileRead_ReadBlock_V1_USER_TIME(fid,data);

			case block_codes.SYSTEM_TYPE                                    %Vulintus system ID code (1 = MotoTrak, 2 = OmniTrak, 3 = HabiTrak, 4 = OmniHome, 5 = SensiTrak, 6 = Prototype).
				data = OmniTrakFileRead_ReadBlock_V1_SYSTEM_TYPE(fid,data);

			case block_codes.SYSTEM_NAME                                    %System name.
				data = OmniTrakFileRead_ReadBlock_V1_SYSTEM_NAME(fid,data);

			case block_codes.SYSTEM_HW_VER                                  %Vulintus system hardware version.
				data = OmniTrakFileRead_ReadBlock_V1_SYSTEM_HW_VER(fid,data);

			case block_codes.SYSTEM_FW_VER                                  %System firmware version, written as characters.
				data = OmniTrakFileRead_ReadBlock_V1_SYSTEM_FW_VER(fid,data);

			case block_codes.SYSTEM_SN                                      %System serial number, written as characters.
				data = OmniTrakFileRead_ReadBlock_V1_SYSTEM_SN(fid,data);

			case block_codes.SYSTEM_MFR                                     %Manufacturer name for non-Vulintus systems.
				data = OmniTrakFileRead_ReadBlock_V1_SYSTEM_MFR(fid,data);

			case block_codes.COMPUTER_NAME                                  %Windows PC computer name.
				data = OmniTrakFileRead_ReadBlock_V1_COMPUTER_NAME(fid,data);

			case block_codes.COM_PORT                                       %The COM port of a computer-connected system.
				data = OmniTrakFileRead_ReadBlock_V1_COM_PORT(fid,data);

			case block_codes.PRIMARY_MODULE                                 %Primary module name, for systems with interchangeable modules.
				data = OmniTrakFileRead_ReadBlock_V1_PRIMARY_MODULE(fid,data);

			case block_codes.PRIMARY_INPUT                                  %Primary input name, for modules with multiple input signals.
				data = OmniTrakFileRead_ReadBlock_V1_PRIMARY_INPUT(fid,data);

			case block_codes.ESP8266_MAC_ADDR                               %The MAC address of the device's ESP8266 module.
				data = OmniTrakFileRead_ReadBlock_V1_ESP8266_MAC_ADDR(fid,data);

			case block_codes.ESP8266_IP4_ADDR                               %The local IPv4 address of the device's ESP8266 module.
				data = OmniTrakFileRead_ReadBlock_V1_ESP8266_IP4_ADDR(fid,data);

			case block_codes.ESP8266_CHIP_ID                                %The ESP8266 manufacturer's unique chip identifier
				data = OmniTrakFileRead_ReadBlock_V1_ESP8266_CHIP_ID(fid,data);

			case block_codes.ESP8266_FLASH_ID                               %The ESP8266 flash chip's unique chip identifier
				data = OmniTrakFileRead_ReadBlock_V1_ESP8266_FLASH_ID(fid,data);

			case block_codes.USER_SYSTEM_NAME                               %The user's name for the system, i.e. booth number.
				data = OmniTrakFileRead_ReadBlock_V1_USER_SYSTEM_NAME(fid,data);

			case block_codes.DEVICE_RESET_COUNT                             %The current reboot count saved in EEPROM or flash memory.
				data = OmniTrakFileRead_ReadBlock_V1_DEVICE_RESET_COUNT(fid,data);

			case block_codes.WINC1500_MAC_ADDR                              %The MAC address of the device's ATWINC1500 module.
				data = OmniTrakFileRead_ReadBlock_V1_WINC1500_MAC_ADDR(fid,data);

			case block_codes.WINC1500_IP4_ADDR                              %The local IPv4 address of the device's ATWINC1500 module.
				data = OmniTrakFileRead_ReadBlock_V1_WINC1500_IP4_ADDR(fid,data);

			case block_codes.BATTERY_SOC                                    %Current battery state-of charge, in percent, measured the BQ27441
				data = OmniTrakFileRead_ReadBlock_V1_BATTERY_SOC(fid,data);

			case block_codes.BATTERY_VOLTS                                  %Current battery voltage, in millivolts, measured by the BQ27441
				data = OmniTrakFileRead_ReadBlock_V1_BATTERY_VOLTS(fid,data);

			case block_codes.BATTERY_CURRENT                                %Average current draw from the battery, in milli-amps, measured by the BQ27441
				data = OmniTrakFileRead_ReadBlock_V1_BATTERY_CURRENT(fid,data);

			case block_codes.BATTERY_FULL                                   %Full capacity of the battery, in milli-amp hours, measured by the BQ27441
				data = OmniTrakFileRead_ReadBlock_V1_BATTERY_FULL(fid,data);

			case block_codes.BATTERY_REMAIN                                 %Remaining capacity of the battery, in milli-amp hours, measured by the BQ27441
				data = OmniTrakFileRead_ReadBlock_V1_BATTERY_REMAIN(fid,data);

			case block_codes.BATTERY_POWER                                  %Average power draw, in milliWatts, measured by the BQ27441
				data = OmniTrakFileRead_ReadBlock_V1_BATTERY_POWER(fid,data);

			case block_codes.BATTERY_SOH                                    %Battery state-of-health, in percent, measured by the BQ27441
				data = OmniTrakFileRead_ReadBlock_V1_BATTERY_SOH(fid,data);

			case block_codes.BATTERY_STATUS                                 %Combined battery state-of-charge, voltage, current, capacity, power, and state-of-health, measured by the BQ27441
				data = OmniTrakFileRead_ReadBlock_V1_BATTERY_STATUS(fid,data);

			case block_codes.FEED_SERVO_MAX_RPM                             %Actual rotation rate, in RPM, of the feeder servo (OmniHome) when set to 180 speed.
				data = OmniTrakFileRead_ReadBlock_V1_FEED_SERVO_MAX_RPM(fid,data);

			case block_codes.FEED_SERVO_SPEED                               %Current speed setting (0-180) for the feeder servo (OmniHome).
				data = OmniTrakFileRead_ReadBlock_V1_FEED_SERVO_SPEED(fid,data);

			case block_codes.SUBJECT_NAME                                   %A single subject's name.
				data = OmniTrakFileRead_ReadBlock_V1_SUBJECT_NAME(fid,data);

			case block_codes.GROUP_NAME                                     %The subject's or subjects' experimental group name.
				data = OmniTrakFileRead_ReadBlock_V1_GROUP_NAME(fid,data);

			case block_codes.EXP_NAME                                       %The user's name for the current experiment.
				data = OmniTrakFileRead_ReadBlock_V1_EXP_NAME(fid,data);

			case block_codes.TASK_TYPE                                      %The user's name for task type, which can be a variant of the overall experiment type.
				data = OmniTrakFileRead_ReadBlock_V1_TASK_TYPE(fid,data);

			case block_codes.STAGE_NAME                                     %The stage name for a behavioral session.
				data = OmniTrakFileRead_ReadBlock_V1_STAGE_NAME(fid,data);

			case block_codes.STAGE_DESCRIPTION                              %The stage description for a behavioral session.
				data = OmniTrakFileRead_ReadBlock_V1_STAGE_DESCRIPTION(fid,data);

			case block_codes.AMG8833_ENABLED                                %Indicates that an AMG8833 thermopile array sensor is present in the system.
				data = OmniTrakFileRead_ReadBlock_V1_AMG8833_ENABLED(fid,data);

			case block_codes.BMP280_ENABLED                                 %Indicates that an BMP280 temperature/pressure sensor is present in the system.
				data = OmniTrakFileRead_ReadBlock_V1_BMP280_ENABLED(fid,data);

			case block_codes.BME280_ENABLED                                 %Indicates that an BME280 temperature/pressure/humidty sensor is present in the system.
				data = OmniTrakFileRead_ReadBlock_V1_BME280_ENABLED(fid,data);

			case block_codes.BME680_ENABLED                                 %Indicates that an BME680 temperature/pressure/humidy/VOC sensor is present in the system.
				data = OmniTrakFileRead_ReadBlock_V1_BME680_ENABLED(fid,data);

			case block_codes.CCS811_ENABLED                                 %Indicates that an CCS811 VOC/eC02 sensor is present in the system.
				data = OmniTrakFileRead_ReadBlock_V1_CCS811_ENABLED(fid,data);

			case block_codes.SGP30_ENABLED                                  %Indicates that an SGP30 VOC/eC02 sensor is present in the system.
				data = OmniTrakFileRead_ReadBlock_V1_SGP30_ENABLED(fid,data);

			case block_codes.VL53L0X_ENABLED                                %Indicates that an VL53L0X time-of-flight distance sensor is present in the system.
				data = OmniTrakFileRead_ReadBlock_V1_VL53L0X_ENABLED(fid,data);

			case block_codes.ALSPT19_ENABLED                                %Indicates that an ALS-PT19 ambient light sensor is present in the system.
				data = OmniTrakFileRead_ReadBlock_V1_ALSPT19_ENABLED(fid,data);

			case block_codes.MLX90640_ENABLED                               %Indicates that an MLX90640 thermopile array sensor is present in the system.
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_ENABLED(fid,data);

			case block_codes.ZMOD4410_ENABLED                               %Indicates that an ZMOD4410 VOC/eC02 sensor is present in the system.
				data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_ENABLED(fid,data);

			case block_codes.AMG8833_THERM_CONV                             %The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature.
				data = OmniTrakFileRead_ReadBlock_V1_AMG8833_THERM_CONV(fid,data);

			case block_codes.AMG8833_THERM_FL                               %The current AMG8833 thermistor reading as a converted float32 value, in Celsius.
				data = OmniTrakFileRead_ReadBlock_V1_AMG8833_THERM_FL(fid,data);

			case block_codes.AMG8833_THERM_INT                              %The current AMG8833 thermistor reading as a raw, signed 16-bit integer.
				data = OmniTrakFileRead_ReadBlock_V1_AMG8833_THERM_INT(fid,data);

			case block_codes.AMG8833_PIXELS_CONV                            %The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature.
				data = OmniTrakFileRead_ReadBlock_V1_AMG8833_PIXELS_CONV(fid,data);

			case block_codes.AMG8833_PIXELS_FL                              %The current AMG8833 pixel readings as converted float32 values, in Celsius.
				data = OmniTrakFileRead_ReadBlock_V1_AMG8833_PIXELS_FL(fid,data);

			case block_codes.AMG8833_PIXELS_INT                             %The current AMG8833 pixel readings as a raw, signed 16-bit integers.
				data = OmniTrakFileRead_ReadBlock_V1_AMG8833_PIXELS_INT(fid,data);

			case block_codes.BME280_TEMP_FL                                 %The current BME280 temperature reading as a converted float32 value, in Celsius.
				data = OmniTrakFileRead_ReadBlock_V1_BME280_TEMP_FL(fid,data);

			case block_codes.BMP280_TEMP_FL                                 %The current BMP280 temperature reading as a converted float32 value, in Celsius.
				data = OmniTrakFileRead_ReadBlock_V1_BMP280_TEMP_FL(fid,data);

			case block_codes.BME680_TEMP_FL                                 %The current BME680 temperature reading as a converted float32 value, in Celsius.
				data = OmniTrakFileRead_ReadBlock_V1_BME680_TEMP_FL(fid,data);

			case block_codes.BME280_PRES_FL                                 %The current BME280 pressure reading as a converted float32 value, in Pascals (Pa).
				data = OmniTrakFileRead_ReadBlock_V1_BME280_PRES_FL(fid,data);

			case block_codes.BMP280_PRES_FL                                 %The current BMP280 pressure reading as a converted float32 value, in Pascals (Pa).
				data = OmniTrakFileRead_ReadBlock_V1_BMP280_PRES_FL(fid,data);

			case block_codes.BME680_PRES_FL                                 %The current BME680 pressure reading as a converted float32 value, in Pascals (Pa).
				data = OmniTrakFileRead_ReadBlock_V1_BME680_PRES_FL(fid,data);

			case block_codes.BME280_HUM_FL                                  %The current BM280 humidity reading as a converted float32 value, in percent (%).
				data = OmniTrakFileRead_ReadBlock_V1_BME280_HUM_FL(fid,data);

			case block_codes.VL53L0X_DIST                                   %The current VL53L0X distance reading as a 16-bit integer, in millimeters (-1 indicates out-of-range).
				data = OmniTrakFileRead_ReadBlock_V1_VL53L0X_DIST(fid,data);

			case block_codes.VL53L0X_FAIL                                   %Indicates the VL53L0X sensor experienced a range failure.
				data = OmniTrakFileRead_ReadBlock_V1_VL53L0X_FAIL(fid,data);

			case block_codes.SGP30_SN                                       %The serial number of the SGP30.
				data = OmniTrakFileRead_ReadBlock_V1_SGP30_SN(fid,data);

			case block_codes.SGP30_EC02                                     %The current SGp30 eCO2 reading distance reading as a 16-bit integer, in parts per million (ppm).
				data = OmniTrakFileRead_ReadBlock_V1_SGP30_EC02(fid,data);

			case block_codes.SGP30_TVOC                                     %The current SGp30 TVOC reading distance reading as a 16-bit integer, in parts per million (ppm).
				data = OmniTrakFileRead_ReadBlock_V1_SGP30_TVOC(fid,data);

			case block_codes.MLX90640_DEVICE_ID                             %The MLX90640 unique device ID saved in the device's EEPROM.
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_DEVICE_ID(fid,data);

			case block_codes.MLX90640_EEPROM_DUMP                           %Raw download of the entire MLX90640 EEPROM, as unsigned 16-bit integers.
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_EEPROM_DUMP(fid,data);

			case block_codes.MLX90640_ADC_RES                               %ADC resolution setting on the MLX90640 (16-, 17-, 18-, or 19-bit).
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_ADC_RES(fid,data);

			case block_codes.MLX90640_REFRESH_RATE                          %Current refresh rate on the MLX90640 (0.25, 0.5, 1, 2, 4, 8, 16, or 32 Hz).
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_REFRESH_RATE(fid,data);

			case block_codes.MLX90640_I2C_CLOCKRATE                         %Current I2C clock freqency used with the MLX90640 (100, 400, or 1000 kHz).
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_I2C_CLOCKRATE(fid,data);

			case block_codes.MLX90640_PIXELS_TO                             %The current MLX90640 pixel readings as converted float32 values, in Celsius.
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_PIXELS_TO(fid,data);

			case block_codes.MLX90640_PIXELS_IM                             %The current MLX90640 pixel readings as converted, but uncalibrationed, float32 values.
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_PIXELS_IM(fid,data);

			case block_codes.MLX90640_PIXELS_INT                            %The current MLX90640 pixel readings as a raw, unsigned 16-bit integers.
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_PIXELS_INT(fid,data);

			case block_codes.MLX90640_I2C_TIME                              %The I2C transfer time of the frame data from the MLX90640 to the microcontroller, in milliseconds.
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_I2C_TIME(fid,data);

			case block_codes.MLX90640_CALC_TIME                             %The calculation time for the uncalibrated or calibrated image captured by the MLX90640.
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_CALC_TIME(fid,data);

			case block_codes.MLX90640_IM_WRITE_TIME                         %The SD card write time for the MLX90640 float32 image data.
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_IM_WRITE_TIME(fid,data);

			case block_codes.MLX90640_INT_WRITE_TIME                        %The SD card write time for the MLX90640 raw uint16 data.
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_INT_WRITE_TIME(fid,data);

			case block_codes.ALSPT19_LIGHT                                  %The current analog value of the ALS-PT19 ambient light sensor, as an unsigned integer ADC value.
				data = OmniTrakFileRead_ReadBlock_V1_ALSPT19_LIGHT(fid,data);

			case block_codes.ZMOD4410_MOX_BOUND                             %The current lower and upper bounds for the ZMOD4410 ADC reading used in calculations.
				data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_MOX_BOUND(fid,data);

			case block_codes.ZMOD4410_CONFIG_PARAMS                         %Current configuration values for the ZMOD4410.
				data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_CONFIG_PARAMS(fid,data);

			case block_codes.ZMOD4410_ERROR                                 %Timestamped ZMOD4410 error event.
				data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_ERROR(fid,data);

			case block_codes.ZMOD4410_READING_FL                            %Timestamped ZMOD4410 reading calibrated and converted to float32.
				data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_READING_FL(fid,data);

			case block_codes.ZMOD4410_READING_INT                           %Timestamped ZMOD4410 reading saved as the raw uint16 ADC value.
				data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_READING_INT(fid,data);

			case block_codes.ZMOD4410_ECO2                                  %Timestamped ZMOD4410 eCO2 reading.
				data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_ECO2(fid,data);

			case block_codes.ZMOD4410_IAQ                                   %Timestamped ZMOD4410 indoor air quality reading.
				data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_IAQ(fid,data);

			case block_codes.ZMOD4410_TVOC                                  %Timestamped ZMOD4410 total volatile organic compound reading.
				data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_TVOC(fid,data);

			case block_codes.ZMOD4410_R_CDA                                 %Timestamped ZMOD4410 total volatile organic compound reading.
				data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_R_CDA(fid,data);

			case block_codes.LSM303_ACC_SETTINGS                            %Current accelerometer reading settings on any enabled LSM303.
				data = OmniTrakFileRead_ReadBlock_V1_LSM303_ACC_SETTINGS(fid,data);

			case block_codes.LSM303_MAG_SETTINGS                            %Current magnetometer reading settings on any enabled LSM303.
				data = OmniTrakFileRead_ReadBlock_V1_LSM303_MAG_SETTINGS(fid,data);

			case block_codes.LSM303_ACC_FL                                  %Current readings from the LSM303 accelerometer, as float values in m/s^2.
				data = OmniTrakFileRead_ReadBlock_V1_LSM303_ACC_FL(fid,data);

			case block_codes.LSM303_MAG_FL                                  %Current readings from the LSM303 magnetometer, as float values in uT.
				data = OmniTrakFileRead_ReadBlock_V1_LSM303_MAG_FL(fid,data);

			case block_codes.SPECTRO_WAVELEN                                %Spectrometer wavelengths, in nanometers.
				data = OmniTrakFileRead_ReadBlock_V1_SPECTRO_WAVELEN(fid,data);

			case block_codes.SPECTRO_TRACE                                  %Spectrometer measurement trace.
				data = OmniTrakFileRead_ReadBlock_V1_SPECTRO_TRACE(fid,data);

			case block_codes.PELLET_DISPENSE                                %Timestamped event for feeding/pellet dispensing.
				data = OmniTrakFileRead_ReadBlock_V1_PELLET_DISPENSE(fid,data);

			case block_codes.PELLET_FAILURE                                 %Timestamped event for feeding/pellet dispensing in which no pellet was detected.
				data = OmniTrakFileRead_ReadBlock_V1_PELLET_FAILURE(fid,data);

			case block_codes.HARD_PAUSE_START                               %Timestamped event marker for the start of a session pause, with no events recorded during the pause.
				data = OmniTrakFileRead_ReadBlock_V1_HARD_PAUSE_START(fid,data);

			case block_codes.HARD_PAUSE_START                               %Timestamped event marker for the stop of a session pause, with no events recorded during the pause.
				data = OmniTrakFileRead_ReadBlock_V1_HARD_PAUSE_START(fid,data);

			case block_codes.SOFT_PAUSE_START                               %Timestamped event marker for the start of a session pause, with non-operant events recorded during the pause.
				data = OmniTrakFileRead_ReadBlock_V1_SOFT_PAUSE_START(fid,data);

			case block_codes.SOFT_PAUSE_START                               %Timestamped event marker for the stop of a session pause, with non-operant events recorded during the pause.
				data = OmniTrakFileRead_ReadBlock_V1_SOFT_PAUSE_START(fid,data);

			case block_codes.POSITION_START_X                               %Starting position of an autopositioner in just the x-direction, with distance in millimeters.
				data = OmniTrakFileRead_ReadBlock_V1_POSITION_START_X(fid,data);

			case block_codes.POSITION_MOVE_X                                %Timestamped movement of an autopositioner in just the x-direction, with distance in millimeters.
				data = OmniTrakFileRead_ReadBlock_V1_POSITION_MOVE_X(fid,data);

			case block_codes.POSITION_START_XY                              %Starting position of an autopositioner in just the x- and y-directions, with distance in millimeters.
				data = OmniTrakFileRead_ReadBlock_V1_POSITION_START_XY(fid,data);

			case block_codes.POSITION_MOVE_XY                               %Timestamped movement of an autopositioner in just the x- and y-directions, with distance in millimeters.
				data = OmniTrakFileRead_ReadBlock_V1_POSITION_MOVE_XY(fid,data);

			case block_codes.POSITION_START_XYZ                             %Starting position of an autopositioner in the x-, y-, and z- directions, with distance in millimeters.
				data = OmniTrakFileRead_ReadBlock_V1_POSITION_START_XYZ(fid,data);

			case block_codes.POSITION_MOVE_XYZ                              %Timestamped movement of an autopositioner in the x-, y-, and z- directions, with distance in millimeters.
				data = OmniTrakFileRead_ReadBlock_V1_POSITION_MOVE_XYZ(fid,data);

			case block_codes.STREAM_INPUT_NAME                              %Stream input name for the specified input index.
				data = OmniTrakFileRead_ReadBlock_V1_STREAM_INPUT_NAME(fid,data);

			case block_codes.CALIBRATION_BASELINE                           %Starting calibration baseline coefficient, for the specified module index.
				data = OmniTrakFileRead_ReadBlock_V1_CALIBRATION_BASELINE(fid,data);

			case block_codes.CALIBRATION_SLOPE                              %Starting calibration slope coefficient, for the specified module index.
				data = OmniTrakFileRead_ReadBlock_V1_CALIBRATION_SLOPE(fid,data);

			case block_codes.CALIBRATION_BASELINE_ADJUST                    %Timestamped in-session calibration baseline coefficient adjustment, for the specified module index.
				data = OmniTrakFileRead_ReadBlock_V1_CALIBRATION_BASELINE_ADJUST(fid,data);

			case block_codes.CALIBRATION_SLOPE_ADJUST                       %Timestamped in-session calibration slope coefficient adjustment, for the specified module index.
				data = OmniTrakFileRead_ReadBlock_V1_CALIBRATION_SLOPE_ADJUST(fid,data);

			case block_codes.HIT_THRESH_TYPE                                %Type of hit threshold (i.e. peak force), for the specified input.
				data = OmniTrakFileRead_ReadBlock_V1_HIT_THRESH_TYPE(fid,data);

			case block_codes.SECONDARY_THRESH_NAME                          %A name/description of secondary thresholds used in the behavior.
				data = OmniTrakFileRead_ReadBlock_V1_SECONDARY_THRESH_NAME(fid,data);

			case block_codes.INIT_THRESH_TYPE                               %Type of initation threshold (i.e. force or touch), for the specified input.
				data = OmniTrakFileRead_ReadBlock_V1_INIT_THRESH_TYPE(fid,data);

			case block_codes.REMOTE_MANUAL_FEED                             %A timestamped manual feed event, triggered remotely.
				data = OmniTrakFileRead_ReadBlock_V1_REMOTE_MANUAL_FEED(fid,data);

			case block_codes.HWUI_MANUAL_FEED                               %A timestamped manual feed event, triggered from the hardware user interface.
				data = OmniTrakFileRead_ReadBlock_V1_HWUI_MANUAL_FEED(fid,data);

			case block_codes.FW_RANDOM_FEED                                 %A timestamped manual feed event, triggered randomly by the firmware.
				data = OmniTrakFileRead_ReadBlock_V1_FW_RANDOM_FEED(fid,data);

			case block_codes.SWUI_MANUAL_FEED_DEPRECATED                    %A timestamped manual feed event, triggered from a computer software user interface.
				data = OmniTrakFileRead_ReadBlock_V1_SWUI_MANUAL_FEED_DEPRECATED(fid,data);

			case block_codes.FW_OPERANT_FEED                                %A timestamped operant-rewarded feed event, trigged by the OmniHome firmware, with the possibility of multiple feedings.
				data = OmniTrakFileRead_ReadBlock_V1_FW_OPERANT_FEED(fid,data);

			case block_codes.SWUI_MANUAL_FEED                               %A timestamped manual feed event, triggered from a computer software user interface.
				data = OmniTrakFileRead_ReadBlock_V1_SWUI_MANUAL_FEED(fid,data);

			case block_codes.SW_RANDOM_FEED                                 %A timestamped manual feed event, triggered randomly by computer software.
				data = OmniTrakFileRead_ReadBlock_V1_SW_RANDOM_FEED(fid,data);

			case block_codes.SW_OPERANT_FEED                                %A timestamped operant-rewarded feed event, trigged by the PC-based behavioral software, with the possibility of multiple feedings.
				data = OmniTrakFileRead_ReadBlock_V1_SW_OPERANT_FEED(fid,data);

			case block_codes.MOTOTRAK_V3P0_OUTCOME                          %MotoTrak version 3.0 trial outcome data.
				data = OmniTrakFileRead_ReadBlock_V1_MOTOTRAK_V3P0_OUTCOME(fid,data);

			case block_codes.MOTOTRAK_V3P0_SIGNAL                           %MotoTrak version 3.0 trial stream signal.
				data = OmniTrakFileRead_ReadBlock_V1_MOTOTRAK_V3P0_SIGNAL(fid,data);

			case block_codes.OUTPUT_TRIGGER_NAME                            %Name/description of the output trigger type for the given index.
				data = OmniTrakFileRead_ReadBlock_V1_OUTPUT_TRIGGER_NAME(fid,data);

			case block_codes.VIBRATION_TASK_TRIAL_OUTCOME                   %Vibration task trial outcome data.
				data = OmniTrakFileRead_ReadBlock_V1_VIBRATION_TASK_TRIAL_OUTCOME(fid,data);

			case block_codes.LED_DETECTION_TASK_TRIAL_OUTCOME               %LED detection task trial outcome data.
				data = OmniTrakFileRead_ReadBlock_V1_LED_DETECTION_TASK_TRIAL_OUTCOME(fid,data);

			case block_codes.LIGHT_SRC_MODEL                                %Light source model name.
				data = OmniTrakFileRead_ReadBlock_V1_LIGHT_SRC_MODEL(fid,data);

			case block_codes.LIGHT_SRC_TYPE                                 %Light source type (i.e. LED, LASER, etc).
				data = OmniTrakFileRead_ReadBlock_V1_LIGHT_SRC_TYPE(fid,data);

			case block_codes.ST_TACTILE_2AFC_TRIAL_OUTCOME                  %SensiTrak tactile discrimination task trial outcome data.
				data = OmniTrakFileRead_ReadBlock_V1_ST_TACTILE_2AFC_TRIAL_OUTCOME(fid,data);

			case block_codes.MAX_ANGLE_POSSIBLE                             %Maximum possble angle the proprioception module can do.
				data = OmniTrakFileRead_ReadBlock_V1_MAX_ANGLE_POSSIBLE(fid,data);

			otherwise
				data = OmniTrakFileRead_Unrecognized_Block(fid,data);

	end
end