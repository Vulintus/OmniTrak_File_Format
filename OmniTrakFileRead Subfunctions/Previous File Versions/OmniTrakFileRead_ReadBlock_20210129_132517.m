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
%	This function was programmatically generated: 29-Jan-2021 13:25:15
%

block_codes = Load_OmniTrak_File_Block_Codes(data.file_version);

if verbose == 1
	block_names = fieldnames(block_codes);
	for f = block_names
		if block_codes.(f{1}) == block
			fprintf(1,'%1.0f >> %1.0f: %s\n',ftell(fid)-2,block,f{1});
		end
	end
end

switch data.file_version

	case 1

		switch block

			case block_code.FILE_VERSION
				data = OmniTrakFileRead_ReadBlock_V1_FILE_VERSION(fid,data);

			case block_code.MS_FILE_START
				data = OmniTrakFileRead_ReadBlock_V1_MS_FILE_START(fid,data);

			case block_code.MS_FILE_STOP
				data = OmniTrakFileRead_ReadBlock_V1_MS_FILE_STOP(fid,data);

			case block_code.SUBJECT_DEPRECATED
				data = OmniTrakFileRead_ReadBlock_V1_SUBJECT_DEPRECATED(fid,data);

			case block_code.CLOCK_FILE_START
				data = OmniTrakFileRead_ReadBlock_V1_CLOCK_FILE_START(fid,data);

			case block_code.CLOCK_FILE_STOP
				data = OmniTrakFileRead_ReadBlock_V1_CLOCK_FILE_STOP(fid,data);

			case block_code.DEVICE_FILE_INDEX
				data = OmniTrakFileRead_ReadBlock_V1_DEVICE_FILE_INDEX(fid,data);

			case block_code.NTP_SYNC
				data = OmniTrakFileRead_ReadBlock_V1_NTP_SYNC(fid,data);

			case block_code.NTP_SYNC_FAIL
				data = OmniTrakFileRead_ReadBlock_V1_NTP_SYNC_FAIL(fid,data);

			case block_code.MS_US_CLOCK_SYNC
				data = OmniTrakFileRead_ReadBlock_V1_MS_US_CLOCK_SYNC(fid,data);

			case block_code.MS_TIMER_ROLLOVER
				data = OmniTrakFileRead_ReadBlock_V1_MS_TIMER_ROLLOVER(fid,data);

			case block_code.US_TIMER_ROLLOVER
				data = OmniTrakFileRead_ReadBlock_V1_US_TIMER_ROLLOVER(fid,data);

			case block_code.RTC_STRING_DEPRECATED
				data = OmniTrakFileRead_ReadBlock_V1_RTC_STRING_DEPRECATED(fid,data);

			case block_code.RTC_STRING
				data = OmniTrakFileRead_ReadBlock_V1_RTC_STRING(fid,data);

			case block_code.RTC_VALUES
				data = OmniTrakFileRead_ReadBlock_V1_RTC_VALUES(fid,data);

			case block_code.ORIGINAL_FILENAME
				data = OmniTrakFileRead_ReadBlock_V1_ORIGINAL_FILENAME(fid,data);

			case block_code.RENAMED_FILE
				data = OmniTrakFileRead_ReadBlock_V1_RENAMED_FILE(fid,data);

			case block_code.DOWNLOAD_TIME
				data = OmniTrakFileRead_ReadBlock_V1_DOWNLOAD_TIME(fid,data);

			case block_code.DOWNLOAD_SYSTEM
				data = OmniTrakFileRead_ReadBlock_V1_DOWNLOAD_SYSTEM(fid,data);

			case block_code.INCOMPLETE_BLOCK
				data = OmniTrakFileRead_ReadBlock_V1_INCOMPLETE_BLOCK(fid,data);

			case block_code.USER_TIME
				data = OmniTrakFileRead_ReadBlock_V1_USER_TIME(fid,data);

			case block_code.SYSTEM_TYPE
				data = OmniTrakFileRead_ReadBlock_V1_SYSTEM_TYPE(fid,data);

			case block_code.SYSTEM_NAME
				data = OmniTrakFileRead_ReadBlock_V1_SYSTEM_NAME(fid,data);

			case block_code.SYSTEM_HW_VER
				data = OmniTrakFileRead_ReadBlock_V1_SYSTEM_HW_VER(fid,data);

			case block_code.SYSTEM_FW_VER
				data = OmniTrakFileRead_ReadBlock_V1_SYSTEM_FW_VER(fid,data);

			case block_code.SYSTEM_SN
				data = OmniTrakFileRead_ReadBlock_V1_SYSTEM_SN(fid,data);

			case block_code.SYSTEM_MFR
				data = OmniTrakFileRead_ReadBlock_V1_SYSTEM_MFR(fid,data);

			case block_code.COMPUTER_NAME
				data = OmniTrakFileRead_ReadBlock_V1_COMPUTER_NAME(fid,data);

			case block_code.COM_PORT
				data = OmniTrakFileRead_ReadBlock_V1_COM_PORT(fid,data);

			case block_code.PRIMARY_MODULE
				data = OmniTrakFileRead_ReadBlock_V1_PRIMARY_MODULE(fid,data);

			case block_code.PRIMARY_INPUT
				data = OmniTrakFileRead_ReadBlock_V1_PRIMARY_INPUT(fid,data);

			case block_code.ESP8266_MAC_ADDR
				data = OmniTrakFileRead_ReadBlock_V1_ESP8266_MAC_ADDR(fid,data);

			case block_code.ESP8266_IP4_ADDR
				data = OmniTrakFileRead_ReadBlock_V1_ESP8266_IP4_ADDR(fid,data);

			case block_code.ESP8266_CHIP_ID
				data = OmniTrakFileRead_ReadBlock_V1_ESP8266_CHIP_ID(fid,data);

			case block_code.ESP8266_FLASH_ID
				data = OmniTrakFileRead_ReadBlock_V1_ESP8266_FLASH_ID(fid,data);

			case block_code.USER_SYSTEM_NAME
				data = OmniTrakFileRead_ReadBlock_V1_USER_SYSTEM_NAME(fid,data);

			case block_code.DEVICE_RESET_COUNT
				data = OmniTrakFileRead_ReadBlock_V1_DEVICE_RESET_COUNT(fid,data);

			case block_code.WINC1500_MAC_ADDR
				data = OmniTrakFileRead_ReadBlock_V1_WINC1500_MAC_ADDR(fid,data);

			case block_code.WINC1500_IP4_ADDR
				data = OmniTrakFileRead_ReadBlock_V1_WINC1500_IP4_ADDR(fid,data);

			case block_code.BATTERY_SOC
				data = OmniTrakFileRead_ReadBlock_V1_BATTERY_SOC(fid,data);

			case block_code.BATTERY_VOLTS
				data = OmniTrakFileRead_ReadBlock_V1_BATTERY_VOLTS(fid,data);

			case block_code.BATTERY_CURRENT
				data = OmniTrakFileRead_ReadBlock_V1_BATTERY_CURRENT(fid,data);

			case block_code.BATTERY_FULL
				data = OmniTrakFileRead_ReadBlock_V1_BATTERY_FULL(fid,data);

			case block_code.BATTERY_REMAIN
				data = OmniTrakFileRead_ReadBlock_V1_BATTERY_REMAIN(fid,data);

			case block_code.BATTERY_POWER
				data = OmniTrakFileRead_ReadBlock_V1_BATTERY_POWER(fid,data);

			case block_code.BATTERY_SOH
				data = OmniTrakFileRead_ReadBlock_V1_BATTERY_SOH(fid,data);

			case block_code.BATTERY_STATUS
				data = OmniTrakFileRead_ReadBlock_V1_BATTERY_STATUS(fid,data);

			case block_code.FEED_SERVO_MAX_RPM
				data = OmniTrakFileRead_ReadBlock_V1_FEED_SERVO_MAX_RPM(fid,data);

			case block_code.FEED_SERVO_SPEED
				data = OmniTrakFileRead_ReadBlock_V1_FEED_SERVO_SPEED(fid,data);

			case block_code.SUBJECT_NAME
				data = OmniTrakFileRead_ReadBlock_V1_SUBJECT_NAME(fid,data);

			case block_code.GROUP_NAME
				data = OmniTrakFileRead_ReadBlock_V1_GROUP_NAME(fid,data);

			case block_code.EXP_NAME
				data = OmniTrakFileRead_ReadBlock_V1_EXP_NAME(fid,data);

			case block_code.TASK_TYPE
				data = OmniTrakFileRead_ReadBlock_V1_TASK_TYPE(fid,data);

			case block_code.STAGE_NAME
				data = OmniTrakFileRead_ReadBlock_V1_STAGE_NAME(fid,data);

			case block_code.STAGE_DESCRIPTION
				data = OmniTrakFileRead_ReadBlock_V1_STAGE_DESCRIPTION(fid,data);

			case block_code.AMG8833_ENABLED
				data = OmniTrakFileRead_ReadBlock_V1_AMG8833_ENABLED(fid,data);

			case block_code.BMP280_ENABLED
				data = OmniTrakFileRead_ReadBlock_V1_BMP280_ENABLED(fid,data);

			case block_code.BME280_ENABLED
				data = OmniTrakFileRead_ReadBlock_V1_BME280_ENABLED(fid,data);

			case block_code.BME680_ENABLED
				data = OmniTrakFileRead_ReadBlock_V1_BME680_ENABLED(fid,data);

			case block_code.CCS811_ENABLED
				data = OmniTrakFileRead_ReadBlock_V1_CCS811_ENABLED(fid,data);

			case block_code.SGP30_ENABLED
				data = OmniTrakFileRead_ReadBlock_V1_SGP30_ENABLED(fid,data);

			case block_code.VL53L0X_ENABLED
				data = OmniTrakFileRead_ReadBlock_V1_VL53L0X_ENABLED(fid,data);

			case block_code.ALSPT19_ENABLED
				data = OmniTrakFileRead_ReadBlock_V1_ALSPT19_ENABLED(fid,data);

			case block_code.MLX90640_ENABLED
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_ENABLED(fid,data);

			case block_code.ZMOD4410_ENABLED
				data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_ENABLED(fid,data);

			case block_code.AMG8833_THERM_CONV
				data = OmniTrakFileRead_ReadBlock_V1_AMG8833_THERM_CONV(fid,data);

			case block_code.AMG8833_THERM_FL
				data = OmniTrakFileRead_ReadBlock_V1_AMG8833_THERM_FL(fid,data);

			case block_code.AMG8833_THERM_INT
				data = OmniTrakFileRead_ReadBlock_V1_AMG8833_THERM_INT(fid,data);

			case block_code.AMG8833_PIXELS_CONV
				data = OmniTrakFileRead_ReadBlock_V1_AMG8833_PIXELS_CONV(fid,data);

			case block_code.AMG8833_PIXELS_FL
				data = OmniTrakFileRead_ReadBlock_V1_AMG8833_PIXELS_FL(fid,data);

			case block_code.AMG8833_PIXELS_INT
				data = OmniTrakFileRead_ReadBlock_V1_AMG8833_PIXELS_INT(fid,data);

			case block_code.BME280_TEMP_FL
				data = OmniTrakFileRead_ReadBlock_V1_BME280_TEMP_FL(fid,data);

			case block_code.BMP280_TEMP_FL
				data = OmniTrakFileRead_ReadBlock_V1_BMP280_TEMP_FL(fid,data);

			case block_code.BME680_TEMP_FL
				data = OmniTrakFileRead_ReadBlock_V1_BME680_TEMP_FL(fid,data);

			case block_code.BME280_PRES_FL
				data = OmniTrakFileRead_ReadBlock_V1_BME280_PRES_FL(fid,data);

			case block_code.BMP280_PRES_FL
				data = OmniTrakFileRead_ReadBlock_V1_BMP280_PRES_FL(fid,data);

			case block_code.BME280_PRES_FL
				data = OmniTrakFileRead_ReadBlock_V1_BME280_PRES_FL(fid,data);

			case block_code.BME280_HUM_FL
				data = OmniTrakFileRead_ReadBlock_V1_BME280_HUM_FL(fid,data);

			case block_code.VL53L0X_DIST
				data = OmniTrakFileRead_ReadBlock_V1_VL53L0X_DIST(fid,data);

			case block_code.VL53L0X_FAIL
				data = OmniTrakFileRead_ReadBlock_V1_VL53L0X_FAIL(fid,data);

			case block_code.SGP30_SN
				data = OmniTrakFileRead_ReadBlock_V1_SGP30_SN(fid,data);

			case block_code.SGP30_EC02
				data = OmniTrakFileRead_ReadBlock_V1_SGP30_EC02(fid,data);

			case block_code.SGP30_TVOC
				data = OmniTrakFileRead_ReadBlock_V1_SGP30_TVOC(fid,data);

			case block_code.MLX90640_DEVICE_ID
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_DEVICE_ID(fid,data);

			case block_code.MLX90640_EEPROM_DUMP
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_EEPROM_DUMP(fid,data);

			case block_code.MLX90640_ADC_RES
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_ADC_RES(fid,data);

			case block_code.MLX90640_REFRESH_RATE
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_REFRESH_RATE(fid,data);

			case block_code.MLX90640_I2C_CLOCKRATE
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_I2C_CLOCKRATE(fid,data);

			case block_code.MLX90640_PIXELS_TO
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_PIXELS_TO(fid,data);

			case block_code.MLX90640_PIXELS_IM
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_PIXELS_IM(fid,data);

			case block_code.MLX90640_PIXELS_INT
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_PIXELS_INT(fid,data);

			case block_code.MLX90640_I2C_TIME
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_I2C_TIME(fid,data);

			case block_code.MLX90640_CALC_TIME
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_CALC_TIME(fid,data);

			case block_code.MLX90640_IM_WRITE_TIME
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_IM_WRITE_TIME(fid,data);

			case block_code.MLX90640_INT_WRITE_TIME
				data = OmniTrakFileRead_ReadBlock_V1_MLX90640_INT_WRITE_TIME(fid,data);

			case block_code.ALSPT19_LIGHT
				data = OmniTrakFileRead_ReadBlock_V1_ALSPT19_LIGHT(fid,data);

			case block_code.ZMOD4410_MOX_BOUND
				data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_MOX_BOUND(fid,data);

			case block_code.ZMOD4410_CONFIG_PARAMS
				data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_CONFIG_PARAMS(fid,data);

			case block_code.ZMOD4410_ERROR
				data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_ERROR(fid,data);

			case block_code.ZMOD4410_READING_FL
				data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_READING_FL(fid,data);

			case block_code.ZMOD4410_READING_INT
				data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_READING_INT(fid,data);

			case block_code.ZMOD4410_ECO2
				data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_ECO2(fid,data);

			case block_code.ZMOD4410_IAQ
				data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_IAQ(fid,data);

			case block_code.ZMOD4410_TVOC
				data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_TVOC(fid,data);

			case block_code.ZMOD4410_R_CDA
				data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_R_CDA(fid,data);

			case block_code.LSM303_ACC_SETTINGS
				data = OmniTrakFileRead_ReadBlock_V1_LSM303_ACC_SETTINGS(fid,data);

			case block_code.LSM303_MAG_SETTINGS
				data = OmniTrakFileRead_ReadBlock_V1_LSM303_MAG_SETTINGS(fid,data);

			case block_code.LSM303_ACC_FL
				data = OmniTrakFileRead_ReadBlock_V1_LSM303_ACC_FL(fid,data);

			case block_code.LSM303_MAG_FL
				data = OmniTrakFileRead_ReadBlock_V1_LSM303_MAG_FL(fid,data);

			case block_code.SPECTRO_WAVELEN
				data = OmniTrakFileRead_ReadBlock_V1_SPECTRO_WAVELEN(fid,data);

			case block_code.SPECTRO_TRACE
				data = OmniTrakFileRead_ReadBlock_V1_SPECTRO_TRACE(fid,data);

			case block_code.PELLET_DISPENSE
				data = OmniTrakFileRead_ReadBlock_V1_PELLET_DISPENSE(fid,data);

			case block_code.PELLET_FAILURE
				data = OmniTrakFileRead_ReadBlock_V1_PELLET_FAILURE(fid,data);

			case block_code.HARD_PAUSE_START
				data = OmniTrakFileRead_ReadBlock_V1_HARD_PAUSE_START(fid,data);

			case block_code.HARD_PAUSE_START
				data = OmniTrakFileRead_ReadBlock_V1_HARD_PAUSE_START(fid,data);

			case block_code.SOFT_PAUSE_START
				data = OmniTrakFileRead_ReadBlock_V1_SOFT_PAUSE_START(fid,data);

			case block_code.SOFT_PAUSE_START
				data = OmniTrakFileRead_ReadBlock_V1_SOFT_PAUSE_START(fid,data);

			case block_code.POSITION_START_X
				data = OmniTrakFileRead_ReadBlock_V1_POSITION_START_X(fid,data);

			case block_code.POSITION_MOVE_X
				data = OmniTrakFileRead_ReadBlock_V1_POSITION_MOVE_X(fid,data);

			case block_code.POSITION_START_XY
				data = OmniTrakFileRead_ReadBlock_V1_POSITION_START_XY(fid,data);

			case block_code.POSITION_MOVE_XY
				data = OmniTrakFileRead_ReadBlock_V1_POSITION_MOVE_XY(fid,data);

			case block_code.POSITION_START_XYZ
				data = OmniTrakFileRead_ReadBlock_V1_POSITION_START_XYZ(fid,data);

			case block_code.POSITION_MOVE_XYZ
				data = OmniTrakFileRead_ReadBlock_V1_POSITION_MOVE_XYZ(fid,data);

			case block_code.STREAM_INPUT_NAME
				data = OmniTrakFileRead_ReadBlock_V1_STREAM_INPUT_NAME(fid,data);

			case block_code.CALIBRATION_BASELINE
				data = OmniTrakFileRead_ReadBlock_V1_CALIBRATION_BASELINE(fid,data);

			case block_code.CALIBRATION_SLOPE
				data = OmniTrakFileRead_ReadBlock_V1_CALIBRATION_SLOPE(fid,data);

			case block_code.CALIBRATION_BASELINE_ADJUST
				data = OmniTrakFileRead_ReadBlock_V1_CALIBRATION_BASELINE_ADJUST(fid,data);

			case block_code.CALIBRATION_SLOPE_ADJUST
				data = OmniTrakFileRead_ReadBlock_V1_CALIBRATION_SLOPE_ADJUST(fid,data);

			case block_code.HIT_THRESH_TYPE
				data = OmniTrakFileRead_ReadBlock_V1_HIT_THRESH_TYPE(fid,data);

			case block_code.SECONDARY_THRESH_NAME
				data = OmniTrakFileRead_ReadBlock_V1_SECONDARY_THRESH_NAME(fid,data);

			case block_code.INIT_THRESH_TYPE
				data = OmniTrakFileRead_ReadBlock_V1_INIT_THRESH_TYPE(fid,data);

			case block_code.REMOTE_MANUAL_FEED
				data = OmniTrakFileRead_ReadBlock_V1_REMOTE_MANUAL_FEED(fid,data);

			case block_code.HWUI_MANUAL_FEED
				data = OmniTrakFileRead_ReadBlock_V1_HWUI_MANUAL_FEED(fid,data);

			case block_code.FW_RANDOM_FEED
				data = OmniTrakFileRead_ReadBlock_V1_FW_RANDOM_FEED(fid,data);

			case block_code.SWUI_MANUAL_FEED_DEPRECATED
				data = OmniTrakFileRead_ReadBlock_V1_SWUI_MANUAL_FEED_DEPRECATED(fid,data);

			case block_code.FW_OPERANT_FEED
				data = OmniTrakFileRead_ReadBlock_V1_FW_OPERANT_FEED(fid,data);

			case block_code.SWUI_MANUAL_FEED
				data = OmniTrakFileRead_ReadBlock_V1_SWUI_MANUAL_FEED(fid,data);

			case block_code.SW_RANDOM_FEED
				data = OmniTrakFileRead_ReadBlock_V1_SW_RANDOM_FEED(fid,data);

			case block_code.SW_OPERANT_FEED
				data = OmniTrakFileRead_ReadBlock_V1_SW_OPERANT_FEED(fid,data);

			case block_code.MOTOTRAK_V3P0_OUTCOME
				data = OmniTrakFileRead_ReadBlock_V1_MOTOTRAK_V3P0_OUTCOME(fid,data);

			case block_code.MOTOTRAK_V3P0_SIGNAL
				data = OmniTrakFileRead_ReadBlock_V1_MOTOTRAK_V3P0_SIGNAL(fid,data);

			case block_code.OUTPUT_TRIGGER_NAME
				data = OmniTrakFileRead_ReadBlock_V1_OUTPUT_TRIGGER_NAME(fid,data);

			case block_code.VIBRATION_TASK_TRIAL_OUTCOME
				data = OmniTrakFileRead_ReadBlock_V1_VIBRATION_TASK_TRIAL_OUTCOME(fid,data);

			case block_code.LED_DETECTION_TASK_TRIAL_OUTCOME
				data = OmniTrakFileRead_ReadBlock_V1_LED_DETECTION_TASK_TRIAL_OUTCOME(fid,data);

			case block_code.LIGHT_SRC_MODEL
				data = OmniTrakFileRead_ReadBlock_V1_LIGHT_SRC_MODEL(fid,data);

			case block_code.LIGHT_SRC_TYPE
				data = OmniTrakFileRead_ReadBlock_V1_LIGHT_SRC_TYPE(fid,data);

			otherwise
				data = OmniTrakFileRead_Unrecognized_Block(fid,data);

	end
end