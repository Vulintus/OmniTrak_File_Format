function data = OmniTrakFileRead(file,varargin)

%Collated: 01/29/2021, 14:04:43


%
%OMNITRAKFILEREAD.m - Vulintus, Inc., 2018.
%
%   OMNITRAKFILEREAD reads in behavioral data from Vulintus' *.OmniTrak
%   file format and returns data organized in the fields of the output
%   "data" structure.
%
%   UPDATE LOG:
%   02/22/2018 - Drew Sloan - Function first created.
%

% if nargin > 1                                                               %If there's any optional input arguments...
%     
% end

file = 'C:\Users\Drew\Google Drive\HabiTrak SBIR\HabiTrak - Spencer Lab Testing\LED Detection Task Data\Calibration Data\LEDDET_CALIBRATION_VULINTUS-LAPTOP_BOOTH200_20210128T224037.OmniTrak';

data = [];                                                                  %Create a structure to receive the data.

if ~exist(file,'file') == 2                                                 %If the file doesn't exist...
    error(['ERROR IN ' upper(mfilename) ': The specified file doesn''t '...
        'exist!\n\t%s'],file);                                              %Throw an error.
end

fid = fopen(file,'r');                                                      %Open the input file for read access.
fseek(fid,0,-1);                                                            %Rewind to the beginning of the file.

block = fread(fid,1,'uint16');                                              %Read in the first data block code.
if isempty(block) || block ~= hex2dec('ABCD')                               %If the first block isn't the expected OmniTrak file identifier...
    fclose(fid);                                                            %Close the input file.
    error(['ERROR IN ' upper(mfilename) ': The specified file doesn''t '...
        'start with the *.OmniTrak 0xABCD identifier code!\n\t%s'],file);   %Throw an error.
end

block = fread(fid,1,'uint16');                                              %Read in the second data block code.
if isempty(block) || block ~= 1                                             %If the second data block code isn't the format version.
    fclose(fid);                                                            %Close the input file.
    error(['ERROR IN ' upper(mfilename) ': The specified file doesn''t '...
        'specify an *.OmniTrak file version!\n\t%s'],file);                 %Throw an error.
end
data.file_version = fread(fid,1,'uint16');                                  %Read in the file version.

block_codes = Load_OmniTrak_File_Block_Codes(data.file_version);            %Load the OmniTrak block code structure.   

f_names = fieldnames(block_codes);
f_values = zeros(size(f_names));
for i = 1:length(f_names)
    f_values(i) = block_codes.(f_names{i});
end

bad_block_start = [];                                                       %Create a variable to check for bad blocks.

try                                                                         %Attempt to read in the file.
    
    while ~feof(fid)                                                        %Loop until the end of the file.

        block_start = ftell(fid);                                           %Grab the current file position.
        
        if ~isempty(bad_block_start) && bad_block_start == block_start      %If this is a known incomplete block...
            fseek(bad_block_end);                                           %Skip over the block.
        end
        
        block = fread(fid,1,'uint16');                                      %Read in the next data block code.
        if isempty(block)                                                   %If there was no new block code to read.
            continue                                                        %Skip the rest of the loop.
        end

        i = (block == f_values);                                            %Find the index for the matching block code.
        fprintf(1,'%s\n',f_names{i});                                       %Print the block code name.
        
        data = OmniTrakFileRead_ReadBlock(fid,block,data);                  %Call the subfunction to read the block.
        
        if isfiled(data,'unrecognized_block')                               %If the last block was unrecognized...

            i = (block == f_values);                                        %Find the index for the matching block code.
            fprintf(1,'%s\n',f_names{i});                                   %Print the block code name.

            fprintf(1,'UNRECOGNIZED BLOCK CODE: %1.0f!\n',block);           %Print the block code.
            fclose(fid);                                                    %Close the file.
            return                                                          %Skip execution of the rest of the function.

        end
    end

catch err                                                                   %If an error occured...
    if strcmpi(err.identifier, 'MATLAB:subsassigndimmismatch')              %If the error was a subscript mismatch...
        data.incomplete_block = block;                                      %Save incomplete block ID.
    else                                                                    %Otherwise...
        fprintf(1,'Add error handler for: %s\n', err.identifier);           %Print a message to add error handling for this error.
    end
    data.incomplete_block = block;                                          %Add an indicator to structure to indicate the file was not read in completely.
    warning(['FILE READ ERROR IN OMNITRAKFILEREAD:\n\t%s\n\tended in an'...
        ' incomplete block.\n\tError Message: ''%s''\n\tline: %1.0f\n'],...
        file, err.message,err.stack(1).line);                               %Show a warning.
end

fclose(fid);                                                                %Close the input file.


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
%	This function was programmatically generated: 29-Jan-2021 13:25:09
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


function data = OmniTrakFileRead_Check_Field_Name(data,fieldname,subfieldname)

if ~iscell(fieldname)                                                       %If the field name isn't a cell.
    fieldname = {fieldname};                                                %Convert it to a cell array.
end
if ~iscell(subfieldname)                                                    %If the subfield name isn't a cell..
    subfieldname = {subfieldname};                                          %Convert it to a cell array.
end
for i = 1:length(fieldname)                                                 %Step through each specified field name.        
    if ~isfield(data,fieldname{i})                                          %If the structure doesn't yet have the specified field...
        data.(fieldname{i}) = [];                                           %Create the field.
    end
    for j = 1:length(subfieldname)                                          %Step through each specified subfield name.            
        if ~isempty(subfieldname{j})                                        %If a subfield was specified...
            if ~isfield(data.(fieldname{i}),subfieldname{j})                %If the primary field doesn't yet have the specified subfield...
                data.(fieldname{i}).(subfieldname{j}) = [];                 %Create the subfield.
            end
        end   
    end
end


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


function data = OmniTrakFileRead_ReadBlock_V1_ALSPT19_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1007
%		ALSPT19_ENABLED

fprintf(1,'Need to finish coding for Block 1007: ALSPT19_ENABLED');


function data = OmniTrakFileRead_ReadBlock_V1_ALSPT19_LIGHT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1600
%		ALSPT19_LIGHT

if ~isfield(data,'amb')                                                     %If the structure doesn't yet have an "amb" field..
    data.amb = [];                                                          %Create the field.
end
i = length(data.amb) + 1;                                                   %Grab a new ambient light reading index.
data.amb(i).src = 'ALSPT19';                                                %Save the source of the ambient light reading.
data.amb(i).id = fread(fid,1,'uint8');                                      %Read in the ambient light sensor index (there may be multiple sensors).
data.amb(i).time = fread(fid,1,'uint32');                                   %Save the millisecond clock timestamp for the reading.
data.amb(i).int = fread(fid,1,'uint16');                                    %Save the ambient light reading as an unsigned 16-bit value.


function data = OmniTrakFileRead_ReadBlock_V1_AMG8833_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1000
%		AMG8833_ENABLED

id = fread(fid,1,'uint8');                                                  %Read in the AMG8833 sensor index (there may be multiple sensors).
if ~isfield(data,'amg')                                                     %If the structure doesn't yet have an "amg" field..
    data.amg = [];                                                          %Create the field.
    data.amg(1).id = id;                                                    %Save the file-specified index for this AMG8833.
end
temp = vertcat(data.amg(:).id);                                             %Grab all of the existing AMG8833 indices.
i = find(temp == id);                                                       %Find the field index for the current AMG8833.
if ~isfield(data.amg,'pixels')                                              %If the "amg" field doesn't yet have an "pixels" field..
    data.amg.pixels = [];                                                   %Create the "pixels" field. 
end            
j = length(data.amg(i).pixels) + 1;                                         %Grab a new reading index.   
data.amg(i).pixels(j).timestamp = fread(fid,1,'uint32');                    %Save the millisecond clock timestamp for the reading.
data.amg(i).pixels(j).float = nan(8,8);                                     %Create an 8x8 matrix to hold the pixel values.
for k = 8:-1:1                                                              %Step through the rows of pixels.
    data.amg(i).pixels(j).float(k,:) = fliplr(fread(fid,8,'float32'));      %Read in each row of pixel values.
end


function data = OmniTrakFileRead_ReadBlock_V1_AMG8833_PIXELS_CONV(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1110
%		AMG8833_PIXELS_CONV

fprintf(1,'Need to finish coding for Block 1110: AMG8833_PIXELS_CONV');


function data = OmniTrakFileRead_ReadBlock_V1_AMG8833_PIXELS_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1111
%		AMG8833_PIXELS_FL

id = fread(fid,1,'uint8');                                                  %Read in the AMG8833 sensor index (there may be multiple sensors).
if ~isfield(data,'amg')                                                     %If the structure doesn't yet have an "amg" field..
    data.amg = [];                                                          %Create the field.
    data.amg(1).id = id;                                                    %Save the file-specified index for this AMG8833.
end
temp = vertcat(data.amg(:).id);                                             %Grab all of the existing AMG8833 indices.
i = find(temp == id);                                                       %Find the field index for the current AMG8833.
if ~isfield(data.amg,'pixels')                                              %If the "amg" field doesn't yet have an "pixels" field..
    data.amg.pixels = [];                                                   %Create the "pixels" field. 
end            
j = length(data.amg(i).pixels) + 1;                                         %Grab a new reading index.   
data.amg(i).pixels(j).timestamp = fread(fid,1,'uint32');                    %Save the millisecond clock timestamp for the reading.
data.amg(i).pixels(j).float = nan(8,8);                                     %Create an 8x8 matrix to hold the pixel values.
for k = 8:-1:1                                                              %Step through the rows of pixels.
    data.amg(i).pixels(j).float(k,:) = fliplr(fread(fid,8,'float32'));      %Read in each row of pixel values.
end


function data = OmniTrakFileRead_ReadBlock_V1_AMG8833_PIXELS_INT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1112
%		AMG8833_PIXELS_INT

fprintf(1,'Need to finish coding for Block 1112: AMG8833_PIXELS_INT');


function data = OmniTrakFileRead_ReadBlock_V1_AMG8833_THERM_CONV(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1100
%		AMG8833_THERM_CONV

fprintf(1,'Need to finish coding for Block 1100: AMG8833_THERM_CONV');


function data = OmniTrakFileRead_ReadBlock_V1_AMG8833_THERM_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1101
%		AMG8833_THERM_FL

data = OmniTrakFileRead_Check_Field_Name(data,'temp',[]);                   %Call the subfunction to check for existing fieldnames.
i = length(data.temp) + 1;                                                  %Grab a new temperature reading index.
data.temp(i).src = 'AMG8833';                                               %Save the source of the temperature reading.
data.temp(i).id = fread(fid,1,'uint8');                                     %Read in the AMG8833 sensor index (there may be multiple sensors).
data.temp(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.temp(i).float = fread(fid,1,'float32');                                %Save the temperature reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_V1_AMG8833_THERM_INT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1102
%		AMG8833_THERM_INT

fprintf(1,'Need to finish coding for Block 1102: AMG8833_THERM_INT');


function data = OmniTrakFileRead_ReadBlock_V1_BATTERY_CURRENT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		172
%		BATTERY_CURRENT

data = OmniTrakFileRead_Check_Field_Name(data,'bat','cur');                 %Call the subfunction to check for existing fieldnames.         
j = length(data.bat.current) + 1;                                           %Grab a new reading index.   
data.bat.cur(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.cur(j).reading = double(fread(fid,1,'int16'))/1000;                %Save the average current draw, in amps.


function data = OmniTrakFileRead_ReadBlock_V1_BATTERY_FULL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		173
%		BATTERY_FULL

data = OmniTrakFileRead_Check_Field_Name(data,'bat','full');                %Call the subfunction to check for existing fieldnames.    
j = length(data.bat.full) + 1;                                              %Grab a new reading index.   
data.bat.full(j).timestamp = readtime;                                      %Save the millisecond clock timestamp for the reading.
data.bat.full(j).reading = double(fread(fid,1,'uint16'))/1000;              %Save the battery's full capacity, in amp-hours.


function data = OmniTrakFileRead_ReadBlock_V1_BATTERY_POWER(fid,data)

%	OmniTrak File Block Code (OFBC):
%		175
%		BATTERY_POWER

data = OmniTrakFileRead_Check_Field_Name(data,'bat','pwr');                 %Call the subfunction to check for existing fieldnames.    
j = length(data.bat.pwr) + 1;                                               %Grab a new reading index.   
data.bat.pwr(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.pwr(j).reading = double(fread(fid,1,'int16'))/1000;                %Save the average power draw, in Watts.


function data = OmniTrakFileRead_ReadBlock_V1_BATTERY_REMAIN(fid,data)

%	OmniTrak File Block Code (OFBC):
%		174
%		BATTERY_REMAIN

data = OmniTrakFileRead_Check_Field_Name(data,'bat','rem');                 %Call the subfunction to check for existing fieldnames.    
j = length(data.bat.rem) + 1;                                               %Grab a new reading index.   
data.bat.rem(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.rem(j).reading = double(fread(fid,1,'uint16'))/1000;               %Save the battery's remaining capacity, in amp-hours.


function data = OmniTrakFileRead_ReadBlock_V1_BATTERY_SOC(fid,data)

%	OmniTrak File Block Code (OFBC):
%		170
%		BATTERY_SOC

data = OmniTrakFileRead_Check_Field_Name(data,'bat','soc');                 %Call the subfunction to check for existing fieldnames.         
j = length(data.bat.soc) + 1;                                               %Grab a new reading index.   
data.bat.soc(j).timestamp = fread(fid,1,'uint32');                          %Save the millisecond clock timestamp for the reading.
data.bat.soc(j).percent = fread(fid,1,'uint16');                            %Save the state-of-charge reading, in percent.


function data = OmniTrakFileRead_ReadBlock_V1_BATTERY_SOH(fid,data)

%	OmniTrak File Block Code (OFBC):
%		176
%		BATTERY_SOH

data = OmniTrakFileRead_Check_Field_Name(data,'bat','sof');                 %Call the subfunction to check for existing fieldnames.    
j = length(data.bat.soh) + 1;                                               %Grab a new reading index.   
data.bat.soh(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.soh(j).reading = fread(fid,1,'int16');                             %Save the state-of-health reading, in percent.


function data = OmniTrakFileRead_ReadBlock_V1_BATTERY_STATUS(fid,data)

%	OmniTrak File Block Code (OFBC):
%		177
%		BATTERY_STATUS

readtime = fread(fid,1,'uint32');                                           %Grab the millisecond clock timestamp for the readings.
data = OmniTrakFileRead_Check_Field_Name(data,'bat','soc');                 %Call the subfunction to check for existing fieldnames.
j = length(data.bat.soc) + 1;                                               %Grab a new reading index.   
data.bat.soc(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.soc(j).reading = fread(fid,1,'uint16');                            %Save the state-of-charge reading, in percent.
data = OmniTrakFileRead_Check_Field_Name(data,'bat','volt');                %Call the subfunction to check for existing fieldnames.        
j = length(data.bat.volt) + 1;                                              %Grab a new reading index.   
data.bat.volt(j).timestamp = readtime;                                      %Save the millisecond clock timestamp for the reading.
data.bat.volt(j).reading = double(fread(fid,1,'uint16'))/1000;              %Save the battery voltage, in volts.
data = OmniTrakFileRead_Check_Field_Name(data,'bat','cur');                 %Call the subfunction to check for existing fieldnames.        
j = length(data.bat.cur) + 1;                                               %Grab a new reading index.   
data.bat.cur(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.cur(j).reading = double(fread(fid,1,'int16'))/1000;                %Save the average current draw, in amps.
data = OmniTrakFileRead_Check_Field_Name(data,'bat','full');                %Call the subfunction to check for existing fieldnames.        
j = length(data.bat.full) + 1;                                              %Grab a new reading index.   
data.bat.full(j).timestamp = readtime;                                      %Save the millisecond clock timestamp for the reading.
data.bat.full(j).reading = double(fread(fid,1,'uint16'))/1000;              %Save the battery's full capacity, in amp-hours.
data = OmniTrakFileRead_Check_Field_Name(data,'bat','rem');                 %Call the subfunction to check for existing fieldnames.        
j = length(data.bat.rem) + 1;                                               %Grab a new reading index.   
data.bat.rem(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.rem(j).reading = double(fread(fid,1,'uint16'))/1000;               %Save the battery's remaining capacity, in amp-hours.
data = OmniTrakFileRead_Check_Field_Name(data,'bat','pwr');                 %Call the subfunction to check for existing fieldnames.        
j = length(data.bat.pwr) + 1;                                               %Grab a new reading index.   
data.bat.pwr(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.pwr(j).reading = double(fread(fid,1,'int16'))/1000;                %Save the average power draw, in Watts.
data = OmniTrakFileRead_Check_Field_Name(data,'bat','soh');                 %Call the subfunction to check for existing fieldnames.
j = length(data.bat.soh) + 1;                                               %Grab a new reading index.   
data.bat.soh(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.soh(j).reading = fread(fid,1,'int16');                             %Save the state-of-health reading, in percent.


function data = OmniTrakFileRead_ReadBlock_V1_BATTERY_VOLTS(fid,data)

%	OmniTrak File Block Code (OFBC):
%		171
%		BATTERY_VOLTS

data = OmniTrakFileRead_Check_Field_Name(data,'bat','volt');                %Call the subfunction to check for existing fieldnames.         
j = length(data.bat.volt) + 1;                                              %Grab a new reading index.   
data.bat.volt(j).timestamp = readtime;                                      %Save the millisecond clock timestamp for the reading.
data.bat.volt(j).reading = double(fread(fid,1,'uint16'))/1000;              %Save the battery voltage, in volts.


function data = OmniTrakFileRead_ReadBlock_V1_BME280_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1002
%		BME280_ENABLED

fprintf(1,'Need to finish coding for Block 1002: BME280_ENABLED');


function data = OmniTrakFileRead_ReadBlock_V1_BME280_HUM_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1220
%		BME280_HUM_FL

if ~isfield(data,'hum')                                                     %If the structure doesn't yet have a "hum" field..
    data.hum = [];                                                          %Create the field.
end
i = length(data.hum) + 1;                                                   %Grab a new pressure reading index.
data.hum(i).src = 'BME280';                                                 %Save the source of the pressure reading.
data.hum(i).id = fread(fid,1,'uint8');                                      %Read in the BME280 sensor index (there may be multiple sensors).
data.hum(i).time = fread(fid,1,'uint32');                                   %Save the millisecond clock timestamp for the reading.
data.hum(i).float = fread(fid,1,'float32');                                 %Save the pressure reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_V1_BME280_PRES_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1210
%		BME280_PRES_FL

if ~isfield(data,'pres')                                                    %If the structure doesn't yet have a "pres" field..
    data.pres = [];                                                         %Create the field.
end
i = length(data.pres) + 1;                                                  %Grab a new pressure reading index.
data.pres(i).src = 'BMP280';                                                %Save the source of the pressure reading.
data.pres(i).id = fread(fid,1,'uint8');                                     %Read in the BMP280 sensor index (there may be multiple sensors).
data.pres(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.pres(i).float = fread(fid,1,'float32');                                %Save the pressure reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_V1_BME280_TEMP_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1200
%		BME280_TEMP_FL

if ~isfield(data,'temp')                                                    %If the structure doesn't yet have a "temp" field..
    data.temp = [];                                                         %Create the field.
end
i = length(data.temp) + 1;                                                  %Grab a new temperature reading index.
data.temp(i).src = 'BMP280';                                                %Save the source of the temperature reading.
data.temp(i).id = fread(fid,1,'uint8');                                     %Read in the BMP280 sensor index (there may be multiple sensors).
data.temp(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.temp(i).float = fread(fid,1,'float32');                                %Save the temperature reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_V1_BME680_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1003
%		BME680_ENABLED

fprintf(1,'Need to finish coding for Block 1003: BME680_ENABLED');


function data = OmniTrakFileRead_ReadBlock_V1_BME680_TEMP_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1202
%		BME680_TEMP_FL

fprintf(1,'Need to finish coding for Block 1202: BME680_TEMP_FL');


function data = OmniTrakFileRead_ReadBlock_V1_BMP280_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1001
%		BMP280_ENABLED

fprintf(1,'Need to finish coding for Block 1001: BMP280_ENABLED');


function data = OmniTrakFileRead_ReadBlock_V1_BMP280_PRES_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1211
%		BMP280_PRES_FL

if ~isfield(data,'pres')                                                    %If the structure doesn't yet have a "pres" field..
    data.pres = [];                                                         %Create the field.
end
i = length(data.pres) + 1;                                                  %Grab a new pressure reading index.
data.pres(i).src = 'BME280';                                                %Save the source of the pressure reading.
data.pres(i).id = fread(fid,1,'uint8');                                     %Read in the BME280 sensor index (there may be multiple sensors).
data.pres(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.pres(i).float = fread(fid,1,'float32');                                %Save the pressure reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_V1_BMP280_TEMP_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1201
%		BMP280_TEMP_FL

if ~isfield(data,'temp')                                                    %If the structure doesn't yet have a "temp" field..
    data.temp = [];                                                         %Create the field.
end
i = length(data.temp) + 1;                                                  %Grab a new temperature reading index.
data.temp(i).src = 'BMP280';                                                %Save the source of the temperature reading.
data.temp(i).id = fread(fid,1,'uint8');                                     %Read in the BMP280 sensor index (there may be multiple sensors).
data.temp(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.temp(i).float = fread(fid,1,'float32');                                %Save the temperature reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_V1_CALIBRATION_BASELINE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2200
%		CALIBRATION_BASELINE

data = OmniTrakFileRead_Check_Field_Name(data,'calibration',[]);            %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the module index.
data.calibration(i).baseline = fread(fid,1,'float32');                      %Save the calibration baseline coefficient.


function data = OmniTrakFileRead_ReadBlock_V1_CALIBRATION_BASELINE_ADJUST(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2202
%		CALIBRATION_BASELINE_ADJUST

fprintf(1,'Need to finish coding for Block 2202: CALIBRATION_BASELINE_ADJUST');


function data = OmniTrakFileRead_ReadBlock_V1_CALIBRATION_SLOPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2201
%		CALIBRATION_SLOPE

data = OmniTrakFileRead_Check_Field_Name(data,'calibration',[]);            %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the module index.
data.calibration(i).slope = fread(fid,1,'float32');                         %Save the calibration baseline coefficient.


function data = OmniTrakFileRead_ReadBlock_V1_CALIBRATION_SLOPE_ADJUST(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2203
%		CALIBRATION_SLOPE_ADJUST

fprintf(1,'Need to finish coding for Block 2203: CALIBRATION_SLOPE_ADJUST');


function data = OmniTrakFileRead_ReadBlock_V1_CCS811_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1004
%		CCS811_ENABLED

fprintf(1,'Need to finish coding for Block 1004: CCS811_ENABLED');


function data = OmniTrakFileRead_ReadBlock_V1_CLOCK_FILE_START(fid,data)

%	OmniTrak File Block Code (OFBC):
%		6
%		CLOCK_FILE_START

data = OmniTrakFileRead_Check_Field_Name(data,'file_start',[]);             %Call the subfunction to check for existing fieldnames.    
data.file_start.datenum = fread(fid,1,'float64');                           %Save the file start 32-bit millisecond clock timestamp.


function data = OmniTrakFileRead_ReadBlock_V1_CLOCK_FILE_STOP(fid,data)

%	OmniTrak File Block Code (OFBC):
%		7
%		CLOCK_FILE_STOP

data = OmniTrakFileRead_Check_Field_Name(data,'file_stop',[]);              %Call the subfunction to check for existing fieldnames.   
data.file_stop.datenum = fread(fid,1,'float64');                            %Save the file stop 32-bit millisecond clock timestamp.


function data = OmniTrakFileRead_ReadBlock_V1_COMPUTER_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		106
%		COMPUTER_NAME

data = OmniTrakFileRead_Check_Field_Name(data,'device','computer');         %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device.computer = char(fread(fid,N,'uchar')');                         %Read in the computer name.


function data = OmniTrakFileRead_ReadBlock_V1_COM_PORT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		107
%		COM_PORT

data = OmniTrakFileRead_Check_Field_Name(data,'device','com');              %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.file_info.download.port = char(fread(fid,N,'uchar')');                 %Read in the port name.


function data = OmniTrakFileRead_ReadBlock_V1_DEVICE_FILE_INDEX(fid,data)

%	OmniTrak File Block Code (OFBC):
%		10
%		DEVICE_FILE_INDEX

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
data.device.file_index = fread(fid,1,'uint32');                             %Save the 32-bit integer file index.


function data = OmniTrakFileRead_ReadBlock_V1_DEVICE_RESET_COUNT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		140
%		DEVICE_RESET_COUNT

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
data.device.reset_count = fread(fid,1,'uint16');                            %Save the device's reset count for the file.


function data = OmniTrakFileRead_ReadBlock_V1_DOWNLOAD_SYSTEM(fid,data)

%	OmniTrak File Block Code (OFBC):
%		43
%		DOWNLOAD_SYSTEM

data = OmniTrakFileRead_Check_Field_Name(data,'file_info','download');      %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.file_info.download.computer = ...
    char(fread(fid,N,'uchar')');                                            %Read in the computer name.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.file_info.download.port = char(fread(fid,N,'uchar')');                 %Read in the port name.


function data = OmniTrakFileRead_ReadBlock_V1_DOWNLOAD_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		42
%		DOWNLOAD_TIME

data = OmniTrakFileRead_Check_Field_Name(data,'file_info','download');      %Call the subfunction to check for existing fieldnames.
data.file_info.download.time = fread(fid,1,'float64');                      %Read in the timestamp for the download.


function data = OmniTrakFileRead_ReadBlock_V1_ESP8266_CHIP_ID(fid,data)

%	OmniTrak File Block Code (OFBC):
%		122
%		ESP8266_CHIP_ID

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
data.device.chip_id = fread(fid,1,'uint32');                                %Save the device's unique chip ID.


function data = OmniTrakFileRead_ReadBlock_V1_ESP8266_FLASH_ID(fid,data)

%	OmniTrak File Block Code (OFBC):
%		123
%		ESP8266_FLASH_ID

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
data.device.flash_id = fread(fid,1,'uint32');                               %Save the device's unique flash chip ID.


function data = OmniTrakFileRead_ReadBlock_V1_ESP8266_IP4_ADDR(fid,data)

%	OmniTrak File Block Code (OFBC):
%		121
%		ESP8266_IP4_ADDR

fprintf(1,'Need to finish coding for Block 121: ESP8266_IP4_ADDR');


function data = OmniTrakFileRead_ReadBlock_V1_ESP8266_MAC_ADDR(fid,data)

%	OmniTrak File Block Code (OFBC):
%		120
%		ESP8266_MAC_ADDR

data = OmniTrakFileRead_Check_Field_Name(data,'device',[]);                 %Call the subfunction to check for existing fieldnames.
data.device.mac_addr = fread(fid,6,'uint8');                                %Save the device MAC address.


function data = OmniTrakFileRead_ReadBlock_V1_EXP_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		300
%		EXP_NAME

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.exp_name = fread(fid,N,'*char')';                                      %Read in the characters of the user's experiment name.


function data = OmniTrakFileRead_ReadBlock_V1_FEED_SERVO_MAX_RPM(fid,data)

%	OmniTrak File Block Code (OFBC):
%		190
%		FEED_SERVO_MAX_RPM

data = OmniTrakFileRead_Check_Field_Name(data,'device','feeder');           %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.
data.device.feeder(i).max_rpm = fread(fid,1,'float32');                     %Read in the maximum measure speed, in RPM.


function data = OmniTrakFileRead_ReadBlock_V1_FEED_SERVO_SPEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		191
%		FEED_SERVO_SPEED

data = OmniTrakFileRead_Check_Field_Name(data,'device','feeder');           %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.
data.device.feeder(i).servo_speed = fread(fid,1,'uint8');                   %Read in the current speed setting (0-180).


function data = OmniTrakFileRead_ReadBlock_V1_FILE_VERSION(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1
%		FILE_VERSION

fprintf(1,'Need to finish coding for Block 1: FILE_VERSION');


function data = OmniTrakFileRead_ReadBlock_V1_FW_OPERANT_FEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2404
%		FW_OPERANT_FEED

data = OmniTrakFileRead_Check_Field_Name(data,'pellet',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.                
j = size(data.pellet(i).time,1) + 1;                                        %Find the next index for the pellet timestamp for this dispenser.
data.pellet(i).time(j,1) = fread(fid,1,'uint32');                           %Save the millisecond clock timestamp.
data.pellet(i).num(j,1) = fread(fid,1,'uint16');                            %Save the number of feedings.
data.pellet(i).source{j,1} = 'operant_firmware';                            %Save the feed trigger source.  


function data = OmniTrakFileRead_ReadBlock_V1_FW_RANDOM_FEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2402
%		FW_RANDOM_FEED

data = OmniTrakFileRead_Check_Field_Name(data,'pellet',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.                
j = size(data.pellet(i).time,1) + 1;                                        %Find the next index for the pellet timestamp for this dispenser.
data.pellet(i).time(j,1) = fread(fid,1,'uint32');                           %Save the millisecond clock timestamp.
data.pellet(i).num(j,1) = fread(fid,1,'uint16');                            %Save the number of feedings.
data.pellet(i).source{j,1} = 'random_firmware';                             %Save the feed trigger source.     


function data = OmniTrakFileRead_ReadBlock_V1_GROUP_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		201
%		GROUP_NAME

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.group = fread(fid,N,'*char')';                                         %Read in the characters of the group name.


function data = OmniTrakFileRead_ReadBlock_V1_HARD_PAUSE_START(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2010
%		HARD_PAUSE_START

fprintf(1,'Need to finish coding for Block 2010: HARD_PAUSE_START');


function data = OmniTrakFileRead_ReadBlock_V1_HIT_THRESH_TYPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2300
%		HIT_THRESH_TYPE

data = OmniTrakFileRead_Check_Field_Name(data,'hit_thresh_type',[]);        %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the signal index.
if isempty(data.hit_thresh_type)                                            %If there's no hit threshold type yet set...
    data.hit_thresh_type = cell(i,1);                                       %Create a cell array to hold the threshold types.
end
N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.hit_thresh_type{i} = fread(fid,N,'*char')';                            %Read in the characters of the user's experiment name.


function data = OmniTrakFileRead_ReadBlock_V1_HWUI_MANUAL_FEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2401
%		HWUI_MANUAL_FEED

data = OmniTrakFileRead_Check_Field_Name(data,'pellet',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.                
j = size(data.pellet(i).time,1) + 1;                                        %Find the next index for the pellet timestamp for this dispenser.
data.pellet(i).time(j,1) = fread(fid,1,'uint32');                           %Save the millisecond clock timestamp.
data.pellet(i).num(j,1) = fread(fid,1,'uint16');                            %Save the number of feedings.
data.pellet(i).source{j,1} = 'manual_hardware';                             %Save the feed trigger source.   


function data = OmniTrakFileRead_ReadBlock_V1_INCOMPLETE_BLOCK(fid,data)

%	OmniTrak File Block Code (OFBC):
%		50
%		INCOMPLETE_BLOCK

fprintf(1,'Need to finish coding for Block 50: INCOMPLETE_BLOCK');


function data = OmniTrakFileRead_ReadBlock_V1_INIT_THRESH_TYPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2320
%		INIT_THRESH_TYPE

fprintf(1,'Need to finish coding for Block 2320: INIT_THRESH_TYPE');


function data = OmniTrakFileRead_ReadBlock_V1_LED_DETECTION_TASK_TRIAL_OUTCOME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2710
%		LED_DETECTION_TASK_TRIAL_OUTCOME

data = OmniTrakFileRead_Check_Field_Name(data,'trial',[]);                  %Call the subfunction to check for existing fieldnames.
t = fread(fid,1,'uint16');                                                  %Read in the trial index.
data.trial(t).start_time = fread(fid,1,'float64');                          %Read in the trial start time (serial date number).
data.trial(t).start_millis = fread(fid,1,'uint32');                         %Read in the trial start time (Arduino millisecond clock).
data.trial(t).outcome = fread(fid,1,'*char');                               %Read in the trial outcome.
N = fread(fid,1,'uint8');                                                   %Read in the number of feedings.
data.trial(t).feed_time = fread(fid,N,'float64');                           %Read in the feeding times.
data.trial(t).hit_win = fread(fid,1,'float32');                             %Read in the hit window.
data.trial(t).ls_index = fread(fid,1,'uint8');                              %Read in the light source index (1-8).
data.trial(t).ls_pwm = fread(fid,1,'uint8');                                %Read in the light source intensity (PWM).                
data.trial(t).ls_dur = fread(fid,1,'float32');                              %Read in the light stimulus duration.
data.trial(t).hold_time = fread(fid,1,'float32');                           %Read in the hold time.
data.trial(t).time_held = fread(fid,1,'float32');                           %Read in the time held.
num_signals = fread(fid,1,'uint8');                                         %Read in the number of signal streams.
num_signals = 1;                                                            %%<<REMOVE AFTER DEBUGGING.
N = fread(fid,1,'uint32');                                                  %Read in the number of samples.                
data.trial(t).times = fread(fid,N,'uint32');                                %Read in the millisecond clock timestampes.
data.trial(t).signal = nan(N,num_signals);                                  %Create a matrix to hold the sensor signals.
data.trial(t).signal(:,1) = fread(fid,N,'uint16');                          %Read in the nosepoke signal.
for i = 2:num_signals                                                       %Step through the non-nosepoke signals.
    data.trial(t).signal(:,i) = fread(fid,N,'float32');                     %Read in each non-nosepoke signal.
end


function data = OmniTrakFileRead_ReadBlock_V1_LIGHT_SRC_MODEL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2711
%		LIGHT_SRC_MODEL

fprintf(1,'Need to finish coding for Block 2711: LIGHT_SRC_MODEL');


function data = OmniTrakFileRead_ReadBlock_V1_LIGHT_SRC_TYPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2712
%		LIGHT_SRC_TYPE

fprintf(1,'Need to finish coding for Block 2712: LIGHT_SRC_TYPE');


function data = OmniTrakFileRead_ReadBlock_V1_LSM303_ACC_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1802
%		LSM303_ACC_FL

data = OmniTrakFileRead_Check_Field_Name(data,'acc',[]);                    %Call the subfunction to check for existing fieldnames.
i = length(data.acc) + 1;                                                   %Grab a new accelerometer reading index.
data.acc(i).src = 'LSM303';                                                 %Save the source of the accelerometer reading.
data.acc(i).id = fread(fid,1,'uint8');                                      %Read in the accelerometer sensor index (there may be multiple sensors).
data.acc(i).time = fread(fid,1,'uint32');                                   %Save the millisecond clock timestamp for the reading.
data.acc(i).xyz = fread(fid,3,'float32');                                   %Save the accelerometer x-y-z readings as float-32 values.


function data = OmniTrakFileRead_ReadBlock_V1_LSM303_ACC_SETTINGS(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1800
%		LSM303_ACC_SETTINGS

fprintf(1,'Need to finish coding for Block 1800: LSM303_ACC_SETTINGS');


function data = OmniTrakFileRead_ReadBlock_V1_LSM303_MAG_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1803
%		LSM303_MAG_FL

fprintf(1,'Need to finish coding for Block 1803: LSM303_MAG_FL');


function data = OmniTrakFileRead_ReadBlock_V1_LSM303_MAG_SETTINGS(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1801
%		LSM303_MAG_SETTINGS

fprintf(1,'Need to finish coding for Block 1801: LSM303_MAG_SETTINGS');


function data = OmniTrakFileRead_ReadBlock_V1_MLX90640_ADC_RES(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1502
%		MLX90640_ADC_RES

fprintf(1,'Need to finish coding for Block 1502: MLX90640_ADC_RES');


function data = OmniTrakFileRead_ReadBlock_V1_MLX90640_CALC_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1521
%		MLX90640_CALC_TIME

fprintf(1,'Need to finish coding for Block 1521: MLX90640_CALC_TIME');


function data = OmniTrakFileRead_ReadBlock_V1_MLX90640_DEVICE_ID(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1500
%		MLX90640_DEVICE_ID

fprintf(1,'Need to finish coding for Block 1500: MLX90640_DEVICE_ID');


function data = OmniTrakFileRead_ReadBlock_V1_MLX90640_EEPROM_DUMP(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1501
%		MLX90640_EEPROM_DUMP

fprintf(1,'Need to finish coding for Block 1501: MLX90640_EEPROM_DUMP');


function data = OmniTrakFileRead_ReadBlock_V1_MLX90640_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1008
%		MLX90640_ENABLED

fprintf(1,'Need to finish coding for Block 1008: MLX90640_ENABLED');


function data = OmniTrakFileRead_ReadBlock_V1_MLX90640_I2C_CLOCKRATE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1504
%		MLX90640_I2C_CLOCKRATE

fprintf(1,'Need to finish coding for Block 1504: MLX90640_I2C_CLOCKRATE');


function data = OmniTrakFileRead_ReadBlock_V1_MLX90640_I2C_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1520
%		MLX90640_I2C_TIME

fprintf(1,'Need to finish coding for Block 1520: MLX90640_I2C_TIME');


function data = OmniTrakFileRead_ReadBlock_V1_MLX90640_IM_WRITE_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1522
%		MLX90640_IM_WRITE_TIME

fprintf(1,'Need to finish coding for Block 1522: MLX90640_IM_WRITE_TIME');


function data = OmniTrakFileRead_ReadBlock_V1_MLX90640_INT_WRITE_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1523
%		MLX90640_INT_WRITE_TIME

fprintf(1,'Need to finish coding for Block 1523: MLX90640_INT_WRITE_TIME');


function data = OmniTrakFileRead_ReadBlock_V1_MLX90640_PIXELS_IM(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1511
%		MLX90640_PIXELS_IM

fprintf(1,'Need to finish coding for Block 1511: MLX90640_PIXELS_IM');


function data = OmniTrakFileRead_ReadBlock_V1_MLX90640_PIXELS_INT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1512
%		MLX90640_PIXELS_INT

fprintf(1,'Need to finish coding for Block 1512: MLX90640_PIXELS_INT');


function data = OmniTrakFileRead_ReadBlock_V1_MLX90640_PIXELS_TO(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1510
%		MLX90640_PIXELS_TO

id = fread(fid,1,'uint8');                                                  %Read in the AMG8833 sensor index (there may be multiple sensors).
if ~isfield(data,'mlx')                                                     %If the structure doesn't yet have an "amg" field..
    data.mlx = [];                                                          %Create the field.
    data.mlx(1).id = id;                                                    %Save the file-specified index for this AMG8833.
end
temp = vertcat(data.mlx(:).id);                                             %Grab all of the existing AMG8833 indices.
i = find(temp == id);                                                       %Find the field index for the current AMG8833.
if ~isfield(data.mlx,'pixels')                                              %If the "amg" field doesn't yet have an "pixels" field..
    data.mlx.pixels = [];                                                   %Create the "pixels" field. 
end            
j = length(data.mlx(i).pixels) + 1;                                         %Grab a new reading index.   
data.mlx(i).pixels(j).timestamp = fread(fid,1,'uint32');                    %Save the millisecond clock timestamp for the reading.
data.mlx(i).pixels(j).float = nan(24,32);                                   %Create an 8x8 matrix to hold the pixel values.
for k = 1:24                                                                %Step through the rows of pixels.
    data.mlx(i).pixels(j).float(k,:) = fliplr(fread(fid,32,'float32'));     %Read in each row of pixel values.
end


function data = OmniTrakFileRead_ReadBlock_V1_MLX90640_REFRESH_RATE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1503
%		MLX90640_REFRESH_RATE

fprintf(1,'Need to finish coding for Block 1503: MLX90640_REFRESH_RATE');


function data = OmniTrakFileRead_ReadBlock_V1_MOTOTRAK_V3P0_OUTCOME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2500
%		MOTOTRAK_V3P0_OUTCOME

data = OmniTrakFileRead_Check_Field_Name(data,'trial',[]);                  %Call the subfunction to check for existing fieldnames.
t = fread(fid,1,'uint16');                                                  %Read in the trial index.
data.trial(t).start_time = fread(fid,1,'uint32');                           %Save the millisecond clock timestamp for the trial start.
data.trial(t).outcome = fread(fid,1,'*char');                               %Read in the character code for the outcome.
pre_N = fread(fid,1,'uint16');                                              %Read in the number of pre-trial samples.
hitwin_N = fread(fid,1,'uint16');                                           %Read in the number of hit window samples.
post_N = fread(fid,1,'uint16');                                             %Read in the number of post-trial samples.
data.trial(t).N_samples = [pre_N, hitwin_N, post_N];                        %Save the number of samples for each phase of the trial.
data.trial(t).init_thresh = fread(fid,1,'float32');                         %Read in the initiation threshold.
data.trial(t).hit_thresh = fread(fid,1,'float32');                          %Read in the hit threshold.
N = fread(fid,1,'uint8');                                                   %Read in the number of secondary hit thresholds.
if N > 0                                                                    %If there were any secondary hit thresholds...
    data.trial(t).secondary_hit_thresh = fread(fid,N,'float32')';           %Read in each secondary hit threshold.
end
N = fread(fid,1,'uint8');                                                   %Read in the number of hits.
if N > 0                                                                    %If there were any hits...
    data.trial(t).hit_time = fread(fid,N,'uint32')';                        %Read in each millisecond clock timestamp for each hit.
end
N = fread(fid,1,'uint8');                                                   %Read in the number of output triggers.
if N > 0                                                                    %If there were any output triggers...
    data.trial(t).trig_time = fread(fid,1,'uint32');                        %Read in each millisecond clock timestamp for each output trigger.
end
num_signals = fread(fid,1,'uint8');                                         %Read in the number of signal streams.
if ~isfield(data.trial,'times')                                             %If the sample times field doesn't yet exist...
    data.trial(t).times = nan(pre_N + hitwin_N + post_N,1);                 %Pre-allocate a matrix to hold sample times.
end
if ~isfield(data.trial,'signal')                                            %If the signal matrix field doesn't yet exist...
    data.trial(t).signal = nan(pre_N + hitwin_N + post_N,3);                %Pre-allocate a matrix to hold signal samples.
end
for i = 1:pre_N                                                             %Step through the samples starting at the hit window.
    data.trial(t).times(i) = fread(fid,1,'uint32');                         %Save the millisecond clock timestamp for the sample.
    data.trial(t).signal(i,:) = fread(fid,num_signals,'int16');             %Save the signal samples.
end       


function data = OmniTrakFileRead_ReadBlock_V1_MOTOTRAK_V3P0_SIGNAL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2501
%		MOTOTRAK_V3P0_SIGNAL

data = OmniTrakFileRead_Check_Field_Name(data,'trial',[]);                  %Call the subfunction to check for existing fieldnames.
t = fread(fid,1,'uint16');                                                  %Read in the trial index.
num_signals = fread(fid,1,'uint8');                                         %Read in the number of signal streams.
pre_N = fread(fid,1,'uint16');                                              %Read in the number of pre-trial samples.
hitwin_N = fread(fid,1,'uint16');                                           %Read in the number of hit window samples.
post_N = fread(fid,1,'uint16');                                             %Read in the number of post-trial samples.
data.trial(t).N_samples = [pre_N, hitwin_N, post_N];                        %Save the number of samples for each phase of the trial.
data.trial(t).times = nan(pre_N + hitwin_N + post_N,1);                     %Pre-allocate a matrix to hold sample times, in microseconds.
data.trial(t).signal = nan(pre_N + hitwin_N + post_N,3);                    %Pre-allocate a matrix to hold signal samples.
for i = (pre_N + 1):(pre_N + hitwin_N + post_N)                             %Step through the samples starting at the hit window.
    data.trial(t).times(i) = fread(fid,1,'uint32');                         %Save the microsecond clock timestamp for the sample.
    data.trial(t).signal(i,:) = fread(fid,num_signals,'int16');             %Save the signal samples.
end


function data = OmniTrakFileRead_ReadBlock_V1_MS_FILE_START(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2
%		MS_FILE_START

data = OmniTrakFileRead_Check_Field_Name(data,'file_start',[]);             %Call the subfunction to check for existing fieldnames.    
data.file_start.ms = fread(fid,1,'uint32');                                 %Save the file start 32-bit millisecond clock timestamp.


function data = OmniTrakFileRead_ReadBlock_V1_MS_FILE_STOP(fid,data)

%	OmniTrak File Block Code (OFBC):
%		3
%		MS_FILE_STOP

data = OmniTrakFileRead_Check_Field_Name(data,'file_stop',[]);              %Call the subfunction to check for existing fieldnames.   
data.file_stop.ms = fread(fid,1,'uint32');                                  %Save the file stop 32-bit millisecond clock timestamp.


function data = OmniTrakFileRead_ReadBlock_V1_MS_TIMER_ROLLOVER(fid,data)

%	OmniTrak File Block Code (OFBC):
%		23
%		MS_TIMER_ROLLOVER

fprintf(1,'Need to finish coding for Block 23: MS_TIMER_ROLLOVER');


function data = OmniTrakFileRead_ReadBlock_V1_MS_US_CLOCK_SYNC(fid,data)

%	OmniTrak File Block Code (OFBC):
%		22
%		MS_US_CLOCK_SYNC

fprintf(1,'Need to finish coding for Block 22: MS_US_CLOCK_SYNC');


function data = OmniTrakFileRead_ReadBlock_V1_NTP_SYNC(fid,data)

%	OmniTrak File Block Code (OFBC):
%		20
%		NTP_SYNC

fprintf(1,'Need to finish coding for Block 20: NTP_SYNC');


function data = OmniTrakFileRead_ReadBlock_V1_NTP_SYNC_FAIL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		21
%		NTP_SYNC_FAIL

fprintf(1,'Need to finish coding for Block 21: NTP_SYNC_FAIL');


function data = OmniTrakFileRead_ReadBlock_V1_ORIGINAL_FILENAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		40
%		ORIGINAL_FILENAME

fprintf(1,'Need to finish coding for Block 40: ORIGINAL_FILENAME');


function data = OmniTrakFileRead_ReadBlock_V1_OUTPUT_TRIGGER_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2600
%		OUTPUT_TRIGGER_NAME

fprintf(1,'Need to finish coding for Block 2600: OUTPUT_TRIGGER_NAME');


function data = OmniTrakFileRead_ReadBlock_V1_PELLET_DISPENSE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2000
%		PELLET_DISPENSE

fprintf(1,'Need to finish coding for Block 2000: PELLET_DISPENSE');


function data = OmniTrakFileRead_ReadBlock_V1_PELLET_FAILURE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2001
%		PELLET_FAILURE

data = OmniTrakFileRead_Check_Field_Name(data,'pellet','fail');             %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.
if length(data.pellet) < i                                                  %If there's no entry yet for this dispenser...
    data.pellet(i).fail = fread(fid,1,'uint32');                            %Save the millisecond clock timestamp for the pellet dispensing failure.
else                                                                        %Otherwise, if there's an entry for this dispenser.
    j = size(data.pellet(i).fail,1) + 1;                                    %Find the next index for the pellet failure timestamp.
    data.pellet(i).fail(j) = fread(fid,1,'uint32');                         %Save the millisecond clock timestamp for the pellet dispensing failure.
end       


function data = OmniTrakFileRead_ReadBlock_V1_POSITION_MOVE_X(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2021
%		POSITION_MOVE_X

data = OmniTrakFileRead_Check_Field_Name(data,'pos','move');                %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the module index.
j = size(data.pos(i).move, 1) + 1;                                          %Find a new row index in the positioner movement matrix.
data.pos(i).move(j,:) = nan(1,4);                                           %Add 4 NaNs to a new row in the movement matrix.            
data.pos(i).move(j,1) = fread(fid,1,'uint32');                              %Save the millisecond clock timestamp for the movement.
data.pos(i).move(j,2) = fread(fid,1,'float32');                             %Save the new positioner x-value as a float32 value.     


function data = OmniTrakFileRead_ReadBlock_V1_POSITION_MOVE_XY(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2023
%		POSITION_MOVE_XY

fprintf(1,'Need to finish coding for Block 2023: POSITION_MOVE_XY');


function data = OmniTrakFileRead_ReadBlock_V1_POSITION_MOVE_XYZ(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2025
%		POSITION_MOVE_XYZ

fprintf(1,'Need to finish coding for Block 2025: POSITION_MOVE_XYZ');


function data = OmniTrakFileRead_ReadBlock_V1_POSITION_START_X(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2020
%		POSITION_START_X

data = OmniTrakFileRead_Check_Field_Name(data,'pos','start');               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the module index.
data.pos(i).start = [fread(fid,1,'float32'), NaN, NaN];                     %Save the starting positioner x-value as a float32 value.   


function data = OmniTrakFileRead_ReadBlock_V1_POSITION_START_XY(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2022
%		POSITION_START_XY

data = OmniTrakFileRead_Check_Field_Name(data,'pos','start');               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the module index.
data.pos(i).start = [fread(fid,2,'float32'), NaN];                          %Save the starting positioner x- and y-value as a float32 value.   


function data = OmniTrakFileRead_ReadBlock_V1_POSITION_START_XYZ(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2024
%		POSITION_START_XYZ

fprintf(1,'Need to finish coding for Block 2024: POSITION_START_XYZ');


function data = OmniTrakFileRead_ReadBlock_V1_PRIMARY_INPUT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		111
%		PRIMARY_INPUT

data = OmniTrakFileRead_Check_Field_Name(data,'input',[]);                  %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.input.primary = fread(fid,N,'*char')';                                 %Read in the characters of the primary module name.


function data = OmniTrakFileRead_ReadBlock_V1_PRIMARY_MODULE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		110
%		PRIMARY_MODULE

data = OmniTrakFileRead_Check_Field_Name(data,'module',[]);                 %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.module.primary = fread(fid,N,'*char')';                                %Read in the characters of the primary module name.


function data = OmniTrakFileRead_ReadBlock_V1_REMOTE_MANUAL_FEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2400
%		REMOTE_MANUAL_FEED

data = OmniTrakFileRead_Check_Field_Name(data,'pellet',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.                
j = size(data.pellet(i).time,1) + 1;                                        %Find the next index for the pellet timestamp for this dispenser.
data.pellet(i).time(j,1) = fread(fid,1,'uint32');                           %Save the millisecond clock timestamp.
data.pellet(i).num(j,1) = fread(fid,1,'uint16');                            %Save the number of feedings.
data.pellet(i).source{j,1} = 'manual_remote';                               %Save the feed trigger source.  


function data = OmniTrakFileRead_ReadBlock_V1_RENAMED_FILE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		41
%		RENAMED_FILE

data = OmniTrakFileRead_Check_Field_Name(data,'file_info','rename');        %Call the subfunction to check for existing fieldnames.
i = length(data.file_info.rename) + 1;                                      %Find the next available index for a renaming event.
data.file_info.rename(i).time = fread(fid,1,'float64');                     %Read in the timestamp for the renaming.
N = fread(fid,1,'uint16');                                                  %Read in the number of characters in the old filename.
data.file_info.rename(i).old = char(fread(fid,N,'uchar')');                 %Read in the old filename.
N = fread(fid,1,'uint16');                                                  %Read in the number of characters in the new filename.
data.file_info.rename(i).new = char(fread(fid,N,'uchar')');                 %Read in the new filename.     


function data = OmniTrakFileRead_ReadBlock_V1_RTC_STRING(fid,data)

%	OmniTrak File Block Code (OFBC):
%		31
%		RTC_STRING

fprintf(1,'Need to finish coding for Block 31: RTC_STRING');


function data = OmniTrakFileRead_ReadBlock_V1_RTC_STRING_DEPRECATED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		30
%		RTC_STRING_DEPRECATED

fprintf(1,'Need to finish coding for Block 30: RTC_STRING_DEPRECATED');


function data = OmniTrakFileRead_ReadBlock_V1_RTC_VALUES(fid,data)

%	OmniTrak File Block Code (OFBC):
%		32
%		RTC_VALUES

data = OmniTrakFileRead_Check_Field_Name(data,'clock',[]);                  %Call the subfunction to check for existing fieldnames.    
i = length(data.clock) + 1;                                                 %Find the next available index for a new real-time clock synchronization.
data.clock(i).ms = fread(fid,1,'uint32');                                   %Save the 32-bit millisecond clock timestamp.
yr = fread(fid,1,'uint16');                                                 %Read in the year.
mo = fread(fid,1,'uint8');                                                  %Read in the month.
dy = fread(fid,1,'uint8');                                                  %Read in the day.
hr = fread(fid,1,'uint8');                                                  %Read in the hour.
mn = fread(fid,1,'uint8');                                                  %Read in the minute.
sc = fread(fid,1,'uint8');                                                  %Read in the second.            
data.clock(i).datenum = datenum(yr, mo, dy, hr, mn, sc);                    %Save the RTC time as a MATLAB serial date number.
data.clock(i).source = 'RTC';                                               %Indicate that the date/time source was a real-time clock.


function data = OmniTrakFileRead_ReadBlock_V1_SECONDARY_THRESH_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2310
%		SECONDARY_THRESH_NAME

fprintf(1,'Need to finish coding for Block 2310: SECONDARY_THRESH_NAME');


function data = OmniTrakFileRead_ReadBlock_V1_SGP30_EC02(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1410
%		SGP30_EC02

if ~isfield(data,'eco2')                                                    %If the structure doesn't yet have a "eco2" field..
    data.eco2 = [];                                                         %Create the field.
end
i = length(data.eco2) + 1;                                                  %Grab a new eCO2 reading index.
data.eco2(i).src = 'SGP30';                                                 %Save the source of the eCO2 reading.
data.eco2(i).id = fread(fid,1,'uint8');                                     %Read in the SGP30 sensor index (there may be multiple sensors).
data.eco2(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.eco2(i).int = fread(fid,1,'uint16');                                   %Save the eCO2 reading as an unsigned 16-bit value.


function data = OmniTrakFileRead_ReadBlock_V1_SGP30_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1005
%		SGP30_ENABLED

fprintf(1,'Need to finish coding for Block 1005: SGP30_ENABLED');


function data = OmniTrakFileRead_ReadBlock_V1_SGP30_SN(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1400
%		SGP30_SN

fprintf(1,'Need to finish coding for Block 1400: SGP30_SN');


function data = OmniTrakFileRead_ReadBlock_V1_SGP30_TVOC(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1420
%		SGP30_TVOC

if ~isfield(data,'tvoc')                                                    %If the structure doesn't yet have a "tvoc" field..
    data.tvoc = [];                                                         %Create the field.
end
i = length(data.tvoc) + 1;                                                  %Grab a new TVOC reading index.
data.tvoc(i).src = 'SGP30';                                                 %Save the source of the TVOC reading.
data.tvoc(i).id = fread(fid,1,'uint8');                                     %Read in the SGP30 sensor index (there may be multiple sensors).
data.tvoc(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.tvoc(i).int = fread(fid,1,'uint16');                                   %Save the TVOC reading as an unsigned 16-bit value.


function data = OmniTrakFileRead_ReadBlock_V1_SOFT_PAUSE_START(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2012
%		SOFT_PAUSE_START

fprintf(1,'Need to finish coding for Block 2012: SOFT_PAUSE_START');


function data = OmniTrakFileRead_ReadBlock_V1_SPECTRO_TRACE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1901
%		SPECTRO_TRACE

fprintf(1,'Need to finish coding for Block 1901: SPECTRO_TRACE');


function data = OmniTrakFileRead_ReadBlock_V1_SPECTRO_WAVELEN(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1900
%		SPECTRO_WAVELEN

fprintf(1,'Need to finish coding for Block 1900: SPECTRO_WAVELEN');


function data = OmniTrakFileRead_ReadBlock_V1_STAGE_DESCRIPTION(fid,data)

%	OmniTrak File Block Code (OFBC):
%		401
%		STAGE_DESCRIPTION

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.stage_description = fread(fid,N,'*char')';                             %Read in the characters of the behavioral session stage description.


function data = OmniTrakFileRead_ReadBlock_V1_STAGE_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		400
%		STAGE_NAME

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.stage_name = fread(fid,N,'*char')';                                    %Read in the characters of the behavioral session stage name.


function data = OmniTrakFileRead_ReadBlock_V1_STREAM_INPUT_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2100
%		STREAM_INPUT_NAME

fprintf(1,'Need to finish coding for Block 2100: STREAM_INPUT_NAME');


function data = OmniTrakFileRead_ReadBlock_V1_SUBJECT_DEPRECATED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		4
%		SUBJECT_DEPRECATED

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.subject = fread(fid,N,'*char')';                                       %Read in the characters of the subject's name.


function data = OmniTrakFileRead_ReadBlock_V1_SUBJECT_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		200
%		SUBJECT_NAME

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.subject = fread(fid,N,'*char')';                                       %Read in the characters of the subject's name.


function data = OmniTrakFileRead_ReadBlock_V1_SWUI_MANUAL_FEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2405
%		SWUI_MANUAL_FEED

data = OmniTrakFileRead_Check_Field_Name(data,'pellet',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.                
j = size(data.pellet(i).time,1) + 1;                                        %Find the next index for the pellet timestamp for this dispenser.
data.pellet(i).time(j,1) = fread(fid,1,'float64');                          %Save the millisecond clock timestamp.
data.pellet(i).num(j,1) = fread(fid,1,'uint16');                            %Save the number of feedings.
data.pellet(i).source{j,1} = 'manual_software';                             %Save the feed trigger source.  


function data = OmniTrakFileRead_ReadBlock_V1_SWUI_MANUAL_FEED_DEPRECATED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2403
%		SWUI_MANUAL_FEED_DEPRECATED

data = OmniTrakFileRead_Check_Field_Name(data,'pellet',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = 1;                                                                      %Read in the dispenser index.                
j = size(data.pellet(i).time,1) + 1;                                        %Find the next index for the pellet timestamp for this dispenser.
data.pellet(i).time(j,1) = fread(fid,1,'float64');                          %Save the millisecond clock timestamp.
data.pellet(i).num(j,1) = fread(fid,1,'uint8');                             %Save the number of feedings.
data.pellet(i).source{j,1} = 'manual_software';                             %Save the feed trigger source.


function data = OmniTrakFileRead_ReadBlock_V1_SW_OPERANT_FEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2407
%		SW_OPERANT_FEED

data = OmniTrakFileRead_Check_Field_Name(data,'pellet',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.                
j = size(data.pellet(i).time,1) + 1;                                        %Find the next index for the pellet timestamp for this dispenser.
data.pellet(i).time(j,1) = fread(fid,1,'float64');                          %Save the millisecond clock timestamp.
data.pellet(i).num(j,1) = fread(fid,1,'uint16');                            %Save the number of feedings.
data.pellet(i).source{j,1} = 'operant_software';                            %Save the feed trigger source.   


function data = OmniTrakFileRead_ReadBlock_V1_SW_RANDOM_FEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2406
%		SW_RANDOM_FEED

data = OmniTrakFileRead_Check_Field_Name(data,'pellet',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.                
j = size(data.pellet(i).time,1) + 1;                                        %Find the next index for the pellet timestamp for this dispenser.
data.pellet(i).time(j,1) = fread(fid,1,'float64');                          %Save the millisecond clock timestamp.
data.pellet(i).num(j,1) = fread(fid,1,'uint16');                            %Save the number of feedings.
data.pellet(i).source{j,1} = 'random_software';                             %Save the feed trigger source.   


function data = OmniTrakFileRead_ReadBlock_V1_SYSTEM_FW_VER(fid,data)

%	OmniTrak File Block Code (OFBC):
%		103
%		SYSTEM_FW_VER

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device.fw_version = char(fread(fid,N,'uchar')');                       %Read in the firmware version.


function data = OmniTrakFileRead_ReadBlock_V1_SYSTEM_HW_VER(fid,data)

%	OmniTrak File Block Code (OFBC):
%		102
%		SYSTEM_HW_VER

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field.
    data.device = [];                                                       %Create the field.
end
data.device.hw_version = fread(fid,1,'float32');                            %Save the device hardware version.


function data = OmniTrakFileRead_ReadBlock_V1_SYSTEM_MFR(fid,data)

%	OmniTrak File Block Code (OFBC):
%		105
%		SYSTEM_MFR

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field.
    data.device = [];                                                       %Create the field.
end
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device.manufacturer = char(fread(fid,N,'uchar')');                     %Read in the manufacturer.


function data = OmniTrakFileRead_ReadBlock_V1_SYSTEM_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		101
%		SYSTEM_NAME

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field.
    data.device = [];                                                       %Create the field.
end
N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.device.system_name = fread(fid,N,'*char')';                            %Read in the characters of the system name.


function data = OmniTrakFileRead_ReadBlock_V1_SYSTEM_SN(fid,data)

%	OmniTrak File Block Code (OFBC):
%		104
%		SYSTEM_SN

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field.
    data.device = [];                                                       %Create the field.
end
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device.serial_num = char(fread(fid,N,'uchar')');                       %Read in the serial number.


function data = OmniTrakFileRead_ReadBlock_V1_SYSTEM_TYPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		100
%		SYSTEM_TYPE

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field.
    data.device = [];                                                       %Create the field.
end
data.device.type = fread(fid,1,'uint8');                                    %Save the device type value.


function data = OmniTrakFileRead_ReadBlock_V1_TASK_TYPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		301
%		TASK_TYPE

data = OmniTrakFileRead_Check_Field_Name(data,'task',[]);                   %Call the subfunction to check for existing fieldnames.                
N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.task.type = fread(fid,N,'*char')';                                     %Read in the characters of the user's task type.


function data = OmniTrakFileRead_ReadBlock_V1_USER_SYSTEM_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		130
%		USER_SYSTEM_NAME

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device.user_system_name = fread(fid,N,'*char')';                       %Read in the characters of the system name.


function data = OmniTrakFileRead_ReadBlock_V1_USER_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		60
%		USER_TIME

data = OmniTrakFileRead_Check_Field_Name(data,'clock',[]);                  %Call the subfunction to check for existing fieldnames.    
i = length(data.clock) + 1;                                                 %Find the next available index for a new real-time clock synchronization.
data.clock(i).ms = fread(fid,1,'uint32');                                   %Save the 32-bit millisecond clock timestamp.
yr = double(fread(fid,1,'uint8')) + 2000;                                   %Read in the year.
mo = fread(fid,1,'uint8');                                                  %Read in the month.
dy = fread(fid,1,'uint8');                                                  %Read in the day.
hr = fread(fid,1,'uint8');                                                  %Read in the hour.
mn = fread(fid,1,'uint8');                                                  %Read in the minute.
sc = fread(fid,1,'uint8');                                                  %Read in the second.            
data.clock(i).datenum = datenum(yr, mo, dy, hr, mn, sc);                    %Save the RTC time as a MATLAB serial date number.
data.clock(i).source = 'USER';                                              %Indicate that the date/time source was a real-time clock.


function data = OmniTrakFileRead_ReadBlock_V1_US_TIMER_ROLLOVER(fid,data)

%	OmniTrak File Block Code (OFBC):
%		24
%		US_TIMER_ROLLOVER

fprintf(1,'Need to finish coding for Block 24: US_TIMER_ROLLOVER');


function data = OmniTrakFileRead_ReadBlock_V1_VIBRATION_TASK_TRIAL_OUTCOME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2700
%		VIBRATION_TASK_TRIAL_OUTCOME

data = OmniTrakFileRead_Check_Field_Name(data,'trial',[]);                  %Call the subfunction to check for existing fieldnames.
t = fread(fid,1,'uint16');                                                  %Read in the trial index.
data.trial(t).start_time = fread(fid,1,'float64');                          %Read in the trial start time (serial date number).
data.trial(t).outcome = fread(fid,1,'*char');                               %Read in the trial outcome.
N = fread(fid,1,'uint8');                                                   %Read in the number of feedings.
data.trial(t).feed_time = fread(fid,N,'float64');                           %Read in the feeding times.
data.trial(t).hit_win = fread(fid,1,'float32');                             %Read in the hit window.
data.trial(t).vib_dur = fread(fid,1,'float32');                             %Read in the vibration pulse duration.
data.trial(t).vib_rate = fread(fid,1,'float32');                            %Read in the vibration pulse rate.
data.trial(t).actual_vib_rate = fread(fid,1,'float32');                     %Read in the actual vibration pulse rate.
data.trial(t).gap_length = fread(fid,1,'float32');                          %Read in the gap length.
data.trial(t).actual_gap_length = fread(fid,1,'float32');                   %Read in the actual gap length.
data.trial(t).hold_time = fread(fid,1,'float32');                           %Read in the hold time.
data.trial(t).time_held = fread(fid,1,'float32');                           %Read in the time held.
data.trial(t).vib_n = fread(fid,1,'uint16');                                %Read in the number of vibration pulses.
data.trial(t).gap_start = fread(fid,1,'uint16');                            %Read in the number of vibration gap start index.
data.trial(t).gap_stop = fread(fid,1,'uint16');                             %Read in the number of vibration gap stop index.
data.trial(t).debounce_samples = fread(fid,1,'uint16');                     %Read in the number of debounce samples.
data.trial(t).pre_samples = fread(fid,1,'uint32');                          %Read in the number of pre-trial samples.
num_signals = fread(fid,1,'uint8');                                         %Read in the number of signal streams.
N = fread(fid,1,'uint32');                                                  %Read in the number of samples.
data.trial(t).times = fread(fid,N,'uint32');                                %Read in the millisecond clock timestampes.
data.trial(t).signal = nan(N,num_signals);                                  %Create a matrix to hold the sensor signals.
for i = 1:num_signals                                                       %Step through the signals.
    data.trial(t).signal(:,i) = fread(fid,N,'float32');                     %Read in each signal.
end


function data = OmniTrakFileRead_ReadBlock_V1_VL53L0X_DIST(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1300
%		VL53L0X_DIST

if ~isfield(data,'dist')                                                    %If the structure doesn't yet have a "dist" field..
    data.dist = [];                                                         %Create the field.
end
i = length(data.dist) + 1;                                                  %Grab a new distance reading index.
data.dist(i).src = 'VL53L0X';                                               %Save the source of the distance reading.
data.dist(i).id = fread(fid,1,'uint8');                                     %Read in the VL53L0X sensor index (there may be multiple sensors).
data.dist(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.dist(i).int = fread(fid,1,'uint16');                                   %Save the distance reading as an unsigned 16-bit value.   


function data = OmniTrakFileRead_ReadBlock_V1_VL53L0X_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1006
%		VL53L0X_ENABLED

fprintf(1,'Need to finish coding for Block 1006: VL53L0X_ENABLED');


function data = OmniTrakFileRead_ReadBlock_V1_VL53L0X_FAIL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1301
%		VL53L0X_FAIL

if ~isfield(data,'dist')                                                    %If the structure doesn't yet have a "dist" field..
    data.dist = [];                                                         %Create the field.
end
i = length(data.dist) + 1;                                      %Grab a new distance reading index.
data.dist(i).src = 'SGP30';                                     %Save the source of the distance reading.
data.dist(i).id = fread(fid,1,'uint8');                         %Read in the VL53L0X sensor index (there may be multiple sensors).
data.dist(i).time = fread(fid,1,'uint32');                      %Save the millisecond clock timestamp for the reading.
data.dist(i).int = NaN;                                         %Save a NaN in place of a value to indicate a read failure.


function data = OmniTrakFileRead_ReadBlock_V1_WINC1500_IP4_ADDR(fid,data)

%	OmniTrak File Block Code (OFBC):
%		151
%		WINC1500_IP4_ADDR

fprintf(1,'Need to finish coding for Block 151: WINC1500_IP4_ADDR');


function data = OmniTrakFileRead_ReadBlock_V1_WINC1500_MAC_ADDR(fid,data)

%	OmniTrak File Block Code (OFBC):
%		150
%		WINC1500_MAC_ADDR

data = OmniTrakFileRead_Check_Field_Name(data,'device',[]);                 %Call the subfunction to check for existing fieldnames.
data.device.mac_addr = fread(fid,6,'uint8');                                %Save the device MAC address.


function data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_CONFIG_PARAMS(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1701
%		ZMOD4410_CONFIG_PARAMS

fprintf(1,'Need to finish coding for Block 1701: ZMOD4410_CONFIG_PARAMS');


function data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_ECO2(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1710
%		ZMOD4410_ECO2

fprintf(1,'Need to finish coding for Block 1710: ZMOD4410_ECO2');


function data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1009
%		ZMOD4410_ENABLED

fprintf(1,'Need to finish coding for Block 1009: ZMOD4410_ENABLED');


function data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_ERROR(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1702
%		ZMOD4410_ERROR

fprintf(1,'Need to finish coding for Block 1702: ZMOD4410_ERROR');


function data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_IAQ(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1711
%		ZMOD4410_IAQ

fprintf(1,'Need to finish coding for Block 1711: ZMOD4410_IAQ');


function data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_MOX_BOUND(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1700
%		ZMOD4410_MOX_BOUND

fprintf(1,'Need to finish coding for Block 1700: ZMOD4410_MOX_BOUND');


function data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_READING_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1703
%		ZMOD4410_READING_FL

fprintf(1,'Need to finish coding for Block 1703: ZMOD4410_READING_FL');


function data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_READING_INT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1704
%		ZMOD4410_READING_INT

data = OmniTrakFileRead_Check_Field_Name(data,'gas_adc',[]);                %Call the subfunction to check for existing fieldnames.
i = length(data.gas_adc) + 1;                                               %Grab a new TVOC reading index.
data.gas_adc(i).src = 'ZMOD4410';                                           %Save the source of the TVOC reading.
data.gas_adc(i).id = fread(fid,1,'uint8');                                  %Read in the SGP30 sensor index (there may be multiple sensors).
data.gas_adc(i).time = fread(fid,1,'uint32');                               %Save the millisecond clock timestamp for the reading.
data.gas_adc(i).int = fread(fid,1,'uint16');                                %Save the TVOC reading as an unsigned 16-bit value.


function data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_R_CDA(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1713
%		ZMOD4410_R_CDA

fprintf(1,'Need to finish coding for Block 1713: ZMOD4410_R_CDA');


function data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_TVOC(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1712
%		ZMOD4410_TVOC

fprintf(1,'Need to finish coding for Block 1712: ZMOD4410_TVOC');


function data = OmniTrakFileRead_Unrecognized_Block(fid, data)

fseek(fid,-2,'cof');                                                        %Rewind 2 bytes.
data.unrecognized_block = [];                                               %Create an unrecognized block field.
data.unrecognized_block.pos = ftell(fid);                                   %Save the file position.
data.unrecognized_block.code = fread(fid,1,'uint16');                       %Read in the data block code.


