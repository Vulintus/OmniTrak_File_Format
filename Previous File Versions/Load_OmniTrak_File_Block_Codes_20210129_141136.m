function block_codes = Load_OmniTrak_File_Block_Codes(ver)

%LOAD_OMNITRAK_FILE_BLOCK_CODES.m
%
%	Vulintus, Inc.
%
%	OmniTrak file format block code libary.
%
%	Library V1 documentation:
%	https://docs.google.com/spreadsheets/d/e/2PACX-1vSt8EQXvF5DNkU8MrZYNL_1TcYMDagQc-U6WyK51xt2nk6oHyXr6Z0jQPUfQTLzla4QNMagKPDmxKJ0/pubhtml
%
%	This function was programmatically generated: 29-Jan-2021 14:11:32
%

block_codes = [];

switch ver

	case 1
		block_codes.CUR_DEF_VERSION = 1;

		block_codes.OMNITRAK_FILE_VERIFY = 43981;

		block_codes.FILE_VERSION = 1;
		block_codes.MS_FILE_START = 2;
		block_codes.MS_FILE_STOP = 3;
		block_codes.SUBJECT_DEPRECATED = 4;

		block_codes.CLOCK_FILE_START = 6;
		block_codes.CLOCK_FILE_STOP = 7;

		block_codes.DEVICE_FILE_INDEX = 10;

		block_codes.NTP_SYNC = 20;
		block_codes.NTP_SYNC_FAIL = 21;
		block_codes.MS_US_CLOCK_SYNC = 22;
		block_codes.MS_TIMER_ROLLOVER = 23;
		block_codes.US_TIMER_ROLLOVER = 24;

		block_codes.RTC_STRING_DEPRECATED = 30;
		block_codes.RTC_STRING = 31;
		block_codes.RTC_VALUES = 32;

		block_codes.ORIGINAL_FILENAME = 40;
		block_codes.RENAMED_FILE = 41;
		block_codes.DOWNLOAD_TIME = 42;
		block_codes.DOWNLOAD_SYSTEM = 43;

		block_codes.INCOMPLETE_BLOCK = 50;

		block_codes.USER_TIME = 60;

		block_codes.SYSTEM_TYPE = 100;
		block_codes.SYSTEM_NAME = 101;
		block_codes.SYSTEM_HW_VER = 102;
		block_codes.SYSTEM_FW_VER = 103;
		block_codes.SYSTEM_SN = 104;
		block_codes.SYSTEM_MFR = 105;
		block_codes.COMPUTER_NAME = 106;
		block_codes.COM_PORT = 107;

		block_codes.PRIMARY_MODULE = 110;
		block_codes.PRIMARY_INPUT = 111;

		block_codes.ESP8266_MAC_ADDR = 120;
		block_codes.ESP8266_IP4_ADDR = 121;
		block_codes.ESP8266_CHIP_ID = 122;
		block_codes.ESP8266_FLASH_ID = 123;

		block_codes.USER_SYSTEM_NAME = 130;

		block_codes.DEVICE_RESET_COUNT = 140;

		block_codes.WINC1500_MAC_ADDR = 150;
		block_codes.WINC1500_IP4_ADDR = 151;

		block_codes.BATTERY_SOC = 170;
		block_codes.BATTERY_VOLTS = 171;
		block_codes.BATTERY_CURRENT = 172;
		block_codes.BATTERY_FULL = 173;
		block_codes.BATTERY_REMAIN = 174;
		block_codes.BATTERY_POWER = 175;
		block_codes.BATTERY_SOH = 176;
		block_codes.BATTERY_STATUS = 177;

		block_codes.FEED_SERVO_MAX_RPM = 190;
		block_codes.FEED_SERVO_SPEED = 191;

		block_codes.SUBJECT_NAME = 200;
		block_codes.GROUP_NAME = 201;

		block_codes.EXP_NAME = 300;
		block_codes.TASK_TYPE = 301;

		block_codes.STAGE_NAME = 400;
		block_codes.STAGE_DESCRIPTION = 401;

		block_codes.AMG8833_ENABLED = 1000;
		block_codes.BMP280_ENABLED = 1001;
		block_codes.BME280_ENABLED = 1002;
		block_codes.BME680_ENABLED = 1003;
		block_codes.CCS811_ENABLED = 1004;
		block_codes.SGP30_ENABLED = 1005;
		block_codes.VL53L0X_ENABLED = 1006;
		block_codes.ALSPT19_ENABLED = 1007;
		block_codes.MLX90640_ENABLED = 1008;
		block_codes.ZMOD4410_ENABLED = 1009;

		block_codes.AMG8833_THERM_CONV = 1100;
		block_codes.AMG8833_THERM_FL = 1101;
		block_codes.AMG8833_THERM_INT = 1102;

		block_codes.AMG8833_PIXELS_CONV = 1110;
		block_codes.AMG8833_PIXELS_FL = 1111;
		block_codes.AMG8833_PIXELS_INT = 1112;

		block_codes.BME280_TEMP_FL = 1200;
		block_codes.BMP280_TEMP_FL = 1201;
		block_codes.BME680_TEMP_FL = 1202;

		block_codes.BME280_PRES_FL = 1210;
		block_codes.BMP280_PRES_FL = 1211;
		block_codes.BME280_PRES_FL = 1212;

		block_codes.BME280_HUM_FL = 1220;

		block_codes.VL53L0X_DIST = 1300;
		block_codes.VL53L0X_FAIL = 1301;

		block_codes.SGP30_SN = 1400;

		block_codes.SGP30_EC02 = 1410;

		block_codes.SGP30_TVOC = 1420;

		block_codes.MLX90640_DEVICE_ID = 1500;
		block_codes.MLX90640_EEPROM_DUMP = 1501;
		block_codes.MLX90640_ADC_RES = 1502;
		block_codes.MLX90640_REFRESH_RATE = 1503;
		block_codes.MLX90640_I2C_CLOCKRATE = 1504;

		block_codes.MLX90640_PIXELS_TO = 1510;
		block_codes.MLX90640_PIXELS_IM = 1511;
		block_codes.MLX90640_PIXELS_INT = 1512;

		block_codes.MLX90640_I2C_TIME = 1520;
		block_codes.MLX90640_CALC_TIME = 1521;
		block_codes.MLX90640_IM_WRITE_TIME = 1522;
		block_codes.MLX90640_INT_WRITE_TIME = 1523;

		block_codes.ALSPT19_LIGHT = 1600;

		block_codes.ZMOD4410_MOX_BOUND = 1700;
		block_codes.ZMOD4410_CONFIG_PARAMS = 1701;
		block_codes.ZMOD4410_ERROR = 1702;
		block_codes.ZMOD4410_READING_FL = 1703;
		block_codes.ZMOD4410_READING_INT = 1704;

		block_codes.ZMOD4410_ECO2 = 1710;
		block_codes.ZMOD4410_IAQ = 1711;
		block_codes.ZMOD4410_TVOC = 1712;
		block_codes.ZMOD4410_R_CDA = 1713;

		block_codes.LSM303_ACC_SETTINGS = 1800;
		block_codes.LSM303_MAG_SETTINGS = 1801;
		block_codes.LSM303_ACC_FL = 1802;
		block_codes.LSM303_MAG_FL = 1803;

		block_codes.SPECTRO_WAVELEN = 1900;
		block_codes.SPECTRO_TRACE = 1901;

		block_codes.PELLET_DISPENSE = 2000;
		block_codes.PELLET_FAILURE = 2001;

		block_codes.HARD_PAUSE_START = 2010;
		block_codes.HARD_PAUSE_START = 2011;
		block_codes.SOFT_PAUSE_START = 2012;
		block_codes.SOFT_PAUSE_START = 2013;

		block_codes.POSITION_START_X = 2020;
		block_codes.POSITION_MOVE_X = 2021;
		block_codes.POSITION_START_XY = 2022;
		block_codes.POSITION_MOVE_XY = 2023;
		block_codes.POSITION_START_XYZ = 2024;
		block_codes.POSITION_MOVE_XYZ = 2025;

		block_codes.STREAM_INPUT_NAME = 2100;

		block_codes.CALIBRATION_BASELINE = 2200;
		block_codes.CALIBRATION_SLOPE = 2201;
		block_codes.CALIBRATION_BASELINE_ADJUST = 2202;
		block_codes.CALIBRATION_SLOPE_ADJUST = 2203;

		block_codes.HIT_THRESH_TYPE = 2300;

		block_codes.SECONDARY_THRESH_NAME = 2310;

		block_codes.INIT_THRESH_TYPE = 2320;

		block_codes.REMOTE_MANUAL_FEED = 2400;
		block_codes.HWUI_MANUAL_FEED = 2401;
		block_codes.FW_RANDOM_FEED = 2402;
		block_codes.SWUI_MANUAL_FEED_DEPRECATED = 2403;
		block_codes.FW_OPERANT_FEED = 2404;
		block_codes.SWUI_MANUAL_FEED = 2405;
		block_codes.SW_RANDOM_FEED = 2406;
		block_codes.SW_OPERANT_FEED = 2407;

		block_codes.MOTOTRAK_V3P0_OUTCOME = 2500;
		block_codes.MOTOTRAK_V3P0_SIGNAL = 2501;

		block_codes.OUTPUT_TRIGGER_NAME = 2600;

		block_codes.VIBRATION_TASK_TRIAL_OUTCOME = 2700;

		block_codes.LED_DETECTION_TASK_TRIAL_OUTCOME = 2710;
		block_codes.LIGHT_SRC_MODEL = 2711;
		block_codes.LIGHT_SRC_TYPE = 2712;

end
