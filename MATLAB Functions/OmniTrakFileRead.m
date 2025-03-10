function data = OmniTrakFileRead(file,varargin)

%Collated: 02/11/2025, 22:51:01


%
% OmniTrakFileRead.m - Vulintus, Inc., 2018.
%
%   OMNITRAKFILEREAD reads in behavioral data from Vulintus' *.OmniTrak
%   file format and returns data organized in the fields of the output
%   "data" structure.
%
%   OMNITRAKFILEREAD_BETA is a beta-testing version of the OmniTrakFileRead
%   function. Use "Deploy_OmniTrakFileRead.m" to generate release versions
%   of OmniTrakFileRead from OmniTrakFileRead_Beta.
%
%   UPDATE LOG:
%   02/22/2018 - Drew Sloan - Function first created.
%   01/29/2020 - Drew Sloan - Block code routing separated into a
%       programmatically generated switch-case subfunction, with separate
%       subfunctions for each block code. Coinciding updates were made to
%       "Update_OmniTrak_Libraries.m" to collate all new subfunctions into
%       a release-version OmniTrakFileRead.m.
%   03/16/2022 - Drew Sloan - Added an option input argument that
%       terminates the file read after the header information (subject,
%       device type, and session start time) is read.
%

verbose = 0;                                                                %Default to non-verbose output.
header_only = 0;                                                            %Default to reading the entire file, not just the header.
show_waitbar = 0;                                                           %Default to not showing a waitbar.
for i = 1:numel(varargin)                                                   %Step through each optional input argument.
    switch lower(varargin{i})                                               %Switch between the recognized input arguments.
        case 'header'                                                       %Just read the header.
            header_only = 1;                                                %Set the header only flag to 1.
        case 'verbose'                                                      %Request verbose output.
            verbose = 1;                                                    %Set the verbose flag to 1.
        case 'waitbar'                                                      %Request a waitbar.
            show_waitbar = 1;                                               %Set the waitbar flag to 1.
    end
end

data = [];                                                                  %Create a structure to receive the data.

if ~exist(file,'file') == 2                                                 %If the file doesn't exist...
    error(['ERROR IN ' upper(mfilename) ': The specified file doesn''t '...
        'exist!\n\t%s'],file);                                              %Throw an error.
end

fid = fopen(file,'r');                                                      %Open the input file for read access.
fseek(fid,0,'eof');                                                         %Fast forward to the end of the file.
file_size = ftell(fid);                                                     %Read in the number of bytes in the file.
fseek(fid,0,'bof');                                                         %Rewind to the beginning of the file.

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

waitbar_closed = 0;                                                         %Create a flag to indicate when the waitbar is closed.
if show_waitbar == 1                                                        %If we're showing a progress waitbar.
    [~, shortfile, ext] = fileparts(file);                                  %Grab the filename minus the path.
    waitbar_str = sprintf('Reading: %s%s',shortfile,ext);                   %Create a string for the waitbar.
    waitbar = big_waitbar('title','OmniTrakFileRead Progress',...
        'string',waitbar_str,...
        'value',ftell(fid)/file_size);                                      %Create a waitbar figure.
end

try                                                                         %Attempt to read in the file.
    
    while ~feof(fid) && ~waitbar_closed                                     %Loop until the end of the file. 
        
        block = fread(fid,1,'uint16');                                      %Read in the next data block code.
        if isempty(block)                                                   %If there was no new block code to read.
            continue                                                        %Skip the rest of the loop.
        end
        
        if verbose == 1
            block_names = fieldnames(block_codes)';
            for f = block_names
                if block_codes.(f{1}) == block
                    fprintf(1,'b%1.0f\t>>\t%1.0f: %s\n',ftell(fid)-2,block,f{1});
                end
            end
        end

        data = block_read_fcn{block}(fid, data);                            %Call the subfunction to read the block.
        
        if isfield(data,'unrecognized_block')                               %If the last block was unrecognized...
            fprintf(1,'UNRECOGNIZED BLOCK CODE: %1.0f!\n',block);           %Print the block code.
            fclose(fid);                                                    %Close the file.
            return                                                          %Skip execution of the rest of the function.
        end
        
        if header_only                                                      %If we're only reading the header.
            if isfield(data,'subject') && ...
                    ~isempty(data.subject) && ...     
                    isfield(data,'file_start') && ...
                    ~isempty(data.file_start) && ...
                    isfield(data,'device') && ...
                    isfield(data.device,'type') && ...
                    ~isempty(data.device.type)
                fclose(fid);                                                %Close the file.
                return                                                      %Skip execution of the rest of the function.
            end
                    
        end

        if show_waitbar                                                     %If we're showing the waitbar...
            if waitbar.isclosed()                                           %If the user closed the waitbar figure...
                waitbar_closed = 1;                                         %Set the waitbar closed flag to 1.
            else                                                            %If the waitbar hasn't been closed...
                waitbar.value(ftell(fid)/file_size);                        %Update the waitbar value.
                waitbar.string(sprintf('%s (%1.0f/%1.0f)',waitbar_str,...
                    ftell(fid),file_size));                                 %Update the waitbar text.
            end
        end

    end

catch err                                                                   %If an error occured...
    
    fprintf(1,'\n');                                                        %Print a carriage return.
    cprintf(-[1,0.5,0],'* FILE READ ERROR IN OMNITRAKFILEREAD:');           %Print a warning message.
    [path,filename,ext] = fileparts(file);                                  %Break the filename into parts.     
    cprintf([1,0.5,0],'\n\n\tFILE: %s%s\n', filename, ext);                 %Print the filename.
    if ~isempty(path)                                                       %If the path is included in the filename...
        cprintf([1,0.5,0],'\tPATH: %s\n', path);                            %Print the path.
    end
    cprintf([1,0.5,0],'\n\tERROR: %s (%s)\n', err.message, err.identifier); %Print the error message.
    for i = numel(err.stack):-1:1                                           %Step through each level of the error stack.
        cprintf([1,0.5,0],repmat('\t',1,(numel(err.stack)-i) + 2));         %Print tabs according to the program level.
        cprintf([1,0.5,0],'%s ', err.stack(i).name);                        %Print the offending function name.
        cprintf([1,0.5,0],['<a href="matlab:opentoline(''%s'','...
            '%1.0f)">(line %1.0f)</a>\n'], err.stack(i).file,...
            err.stack(i).line, err.stack(i).line);                          %Print a link to the offending line of code.
    end
    fprintf(1,'\n');                                                        %Print a carriage return.
    
end

fclose(fid);                                                                %Close the input file.

if show_waitbar && ~waitbar.isclosed()                                      %If we're showing the waitbar and it's not yet closed....
    waitbar.close();                                                        %Close the waitbar.
end


function block_codes = Load_OmniTrak_File_Block_Codes(varargin)

%LOAD_OMNITRAK_FILE_BLOCK_CODES.m
%
%	Vulintus, Inc.
%
%	OmniTrak file format block code libary.
%
%	https://github.com/Vulintus/OmniTrak_File_Format
%
%	This file was programmatically generated: 2025-02-11, 11:58:55 (UTC).
%

if nargin > 0
	ver = varargin{1};
else
	ver = 1;
end

block_codes = [];

switch ver

	case 1

		block_codes.CUR_DEF_VERSION = 1;

		block_codes.OMNITRAK_FILE_VERIFY = 43981;                           %First unsigned 16-bit integer written to every *.OmniTrak file to identify the file type, has a hex value of 0xABCD.

		block_codes.FILE_VERSION = 1;                                       %The version of the file format used.
		block_codes.MS_FILE_START = 2;                                      %Value of the SoC millisecond clock at file creation.
		block_codes.MS_FILE_STOP = 3;                                       %Value of the SoC millisecond clock when the file is closed.
		block_codes.SUBJECT_DEPRECATED = 4;                                 %A single subject's name.

		block_codes.CLOCK_FILE_START = 6;                                   %Computer clock serial date number at file creation (local time).
		block_codes.CLOCK_FILE_STOP = 7;                                    %Computer clock serial date number when the file is closed (local time).

		block_codes.DEVICE_FILE_INDEX = 10;                                 %The device's current file index.

		block_codes.NTP_SYNC = 20;                                          %A fetched NTP time (seconds since January 1, 1900) at the specified SoC millisecond clock time.
		block_codes.NTP_SYNC_FAIL = 21;                                     %Indicates the an NTP synchonization attempt failed.
		block_codes.CLOCK_SYNC = 22;                                  %The current SoC microsecond clock time at the specified SoC millisecond clock time.
		block_codes.MS_TIMER_ROLLOVER = 23;                                 %Indicates that the millisecond timer rolled over since the last loop.
		block_codes.US_TIMER_ROLLOVER = 24;                                 %Indicates that the microsecond timer rolled over since the last loop.
		block_codes.TIME_ZONE_OFFSET = 25;                                  %Computer clock time zone offset from UTC.
		block_codes.TIME_ZONE_OFFSET_HHMM = 26;                             %Computer clock time zone offset from UTC as two integers, one for hours, and the other for minutes

		block_codes.RTC_STRING_DEPRECATED = 30;                             %Current date/time string from the real-time clock.
		block_codes.RTC_STRING = 31;                                        %Current date/time string from the real-time clock.
		block_codes.RTC_VALUES = 32;                                        %Current date/time values from the real-time clock.

		block_codes.ORIGINAL_FILENAME = 40;                                 %The original filename for the data file.
		block_codes.RENAMED_FILE = 41;                                      %A timestamped event to indicate when a file has been renamed by one of Vulintus' automatic data organizing programs.
		block_codes.DOWNLOAD_TIME = 42;                                     %A timestamp indicating when the data file was downloaded from the OmniTrak device to a computer.
		block_codes.DOWNLOAD_SYSTEM = 43;                                   %The computer system name and the COM port used to download the data file form the OmniTrak device.

		block_codes.INCOMPLETE_BLOCK = 50;                                  %Indicates that the file will end in an incomplete block.

		block_codes.USER_TIME = 60;                                         %Date/time values from a user-set timestamp.

		block_codes.SYSTEM_TYPE = 100;                                      %Vulintus system ID code (1 = MotoTrak, 2 = OmniTrak, 3 = HabiTrak, 4 = OmniHome, 5 = SensiTrak, 6 = Prototype).
		block_codes.SYSTEM_NAME = 101;                                      %Vulintus system name.
		block_codes.SYSTEM_HW_VER = 102;                                    %Vulintus system hardware version.
		block_codes.SYSTEM_FW_VER = 103;                                    %System firmware version, written as characters.
		block_codes.SYSTEM_SN = 104;                                        %System serial number, written as characters.
		block_codes.SYSTEM_MFR = 105;                                       %Manufacturer name for non-Vulintus systems.
		block_codes.COMPUTER_NAME = 106;                                    %Windows PC computer name.
		block_codes.COM_PORT = 107;                                         %The COM port of a computer-connected system.
		block_codes.DEVICE_ALIAS = 108;                                     %Human-readable Adjective + Noun alias/name for the device, assigned by Vulintus during manufacturing

		block_codes.PRIMARY_MODULE = 110;                                   %Primary module name, for systems with interchangeable modules.
		block_codes.PRIMARY_INPUT = 111;                                    %Primary input name, for modules with multiple input signals.
		block_codes.SAMD_CHIP_ID = 112;                                     %The SAMD manufacturer's unique chip identifier.

		block_codes.ESP8266_MAC_ADDR = 120;                                 %The MAC address of the device's ESP8266 module.
		block_codes.ESP8266_IP4_ADDR = 121;                                 %The local IPv4 address of the device's ESP8266 module.
		block_codes.ESP8266_CHIP_ID = 122;                                  %The ESP8266 manufacturer's unique chip identifier
		block_codes.ESP8266_FLASH_ID = 123;                                 %The ESP8266 flash chip's unique chip identifier

		block_codes.USER_SYSTEM_NAME = 130;                                 %The user's name for the system, i.e. booth number.

		block_codes.DEVICE_RESET_COUNT = 140;                               %The current reboot count saved in EEPROM or flash memory.
		block_codes.CTRL_FW_FILENAME = 141;                                 %Controller firmware filename, copied from the macro, written as characters.
		block_codes.CTRL_FW_DATE = 142;                                     %Controller firmware upload date, copied from the macro, written as characters.
		block_codes.CTRL_FW_TIME = 143;                                     %Controller firmware upload time, copied from the macro, written as characters.
		block_codes.MODULE_FW_FILENAME = 144;                               %OTMP Module firmware filename, copied from the macro, written as characters.
		block_codes.MODULE_FW_DATE = 145;                                   %OTMP Module firmware upload date, copied from the macro, written as characters.
		block_codes.MODULE_FW_TIME = 146;                                   %OTMP Module firmware upload time, copied from the macro, written as characters.

		block_codes.WINC1500_MAC_ADDR = 150;                                %The MAC address of the device's ATWINC1500 module.
		block_codes.WINC1500_IP4_ADDR = 151;                                %The local IPv4 address of the device's ATWINC1500 module.

		block_codes.BATTERY_SOC = 170;                                      %Current battery state-of charge, in percent, measured the BQ27441
		block_codes.BATTERY_VOLTS = 171;                                    %Current battery voltage, in millivolts, measured by the BQ27441
		block_codes.BATTERY_CURRENT = 172;                                  %Average current draw from the battery, in milli-amps, measured by the BQ27441
		block_codes.BATTERY_FULL = 173;                                     %Full capacity of the battery, in milli-amp hours, measured by the BQ27441
		block_codes.BATTERY_REMAIN = 174;                                   %Remaining capacity of the battery, in milli-amp hours, measured by the BQ27441
		block_codes.BATTERY_POWER = 175;                                    %Average power draw, in milliWatts, measured by the BQ27441
		block_codes.BATTERY_SOH = 176;                                      %Battery state-of-health, in percent, measured by the BQ27441
		block_codes.BATTERY_STATUS = 177;                                   %Combined battery state-of-charge, voltage, current, capacity, power, and state-of-health, measured by the BQ27441

		block_codes.FEED_SERVO_MAX_RPM = 190;                               %Actual rotation rate, in RPM, of the feeder servo (OmniHome) when set to 180 speed.
		block_codes.FEED_SERVO_SPEED = 191;                                 %Current speed setting (0-180) for the feeder servo (OmniHome).

		block_codes.SUBJECT_NAME = 200;                                     %A single subject's name.
		block_codes.GROUP_NAME = 201;                                       %The subject's or subjects' experimental group name.

		block_codes.EXP_NAME = 300;                                         %The user's name for the current experiment.
		block_codes.TASK_TYPE = 301;                                        %The user's name for task type, which can be a variant of the overall experiment type.

		block_codes.STAGE_NAME = 400;                                       %The stage name for a behavioral session.
		block_codes.STAGE_DESCRIPTION = 401;                                %The stage description for a behavioral session.

		block_codes.AMG8833_ENABLED = 1000;                                 %Indicates that an AMG8833 thermopile array sensor is present in the system.
		block_codes.BMP280_ENABLED = 1001;                                  %Indicates that an BMP280 temperature/pressure sensor is present in the system.
		block_codes.BME280_ENABLED = 1002;                                  %Indicates that an BME280 temperature/pressure/humidty sensor is present in the system.
		block_codes.BME680_ENABLED = 1003;                                  %Indicates that an BME680 temperature/pressure/humidy/VOC sensor is present in the system.
		block_codes.CCS811_ENABLED = 1004;                                  %Indicates that an CCS811 VOC/eC02 sensor is present in the system.
		block_codes.SGP30_ENABLED = 1005;                                   %Indicates that an SGP30 VOC/eC02 sensor is present in the system.
		block_codes.VL53L0X_ENABLED = 1006;                                 %Indicates that an VL53L0X time-of-flight distance sensor is present in the system.
		block_codes.ALSPT19_ENABLED = 1007;                                 %Indicates that an ALS-PT19 ambient light sensor is present in the system.
		block_codes.MLX90640_ENABLED = 1008;                                %Indicates that an MLX90640 thermopile array sensor is present in the system.
		block_codes.ZMOD4410_ENABLED = 1009;                                %Indicates that an ZMOD4410 VOC/eC02 sensor is present in the system.

		block_codes.AMBULATION_XY_THETA = 1024;                             %A point in a tracked ambulation path, with absolute x- and y-coordinates in millimeters, with facing direction theta, in degrees.

		block_codes.AMG8833_THERM_CONV = 1100;                              %The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature.
		block_codes.AMG8833_THERM_FL = 1101;                                %The current AMG8833 thermistor reading as a converted float32 value, in Celsius.
		block_codes.AMG8833_THERM_INT = 1102;                               %The current AMG8833 thermistor reading as a raw, signed 16-bit integer.

		block_codes.AMG8833_PIXELS_CONV = 1110;                             %The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature.
		block_codes.AMG8833_PIXELS_FL = 1111;                               %The current AMG8833 pixel readings as converted float32 values, in Celsius.
		block_codes.AMG8833_PIXELS_INT = 1112;                              %The current AMG8833 pixel readings as a raw, signed 16-bit integers.
		block_codes.HTPA32X32_PIXELS_FP62 = 1113;                           %The current HTPA32x32 pixel readings as a fixed-point 6/2 type (6 bits for the unsigned integer part, 2 bits for the decimal part), in units of Celcius. This allows temperatures from 0 to 63.75 C.
		block_codes.HTPA32X32_PIXELS_INT_K = 1114;                          %The current HTPA32x32 pixel readings represented as 16-bit unsigned integers in units of deciKelvin (dK, or Kelvin * 10).
		block_codes.HTPA32X32_AMBIENT_TEMP = 1115;                          %The current ambient temperature measured by the HTPA32x32, represented as a 32-bit float, in units of Celcius.
		block_codes.HTPA32X32_PIXELS_INT12_C = 1116;                        %The current HTPA32x32 pixel readings represented as 12-bit signed integers (2 pixels for every 3 bytes) in units of deciCelsius (dC, or Celsius * 10), with values under-range set to the minimum  (2048 dC) and values over-range set to the maximum (2047 dC).
		block_codes.HTPA32X32_HOTTEST_PIXEL_FP62 = 1117;                    %The location and temperature of the hottest pixel in the HTPA32x32 image. This may not be the raw hottest pixel. It may have gone through some processing and filtering to determine the true hottest pixel. The temperature will be in FP62 formatted Celsius.

		block_codes.BH1749_RGB = 1120;                                      %The current red, green, blue, IR, and green2 sensor readings from the BH1749 sensor
		block_codes.DEBUG_SANITY_CHECK = 1121;                              %A special block acting as a sanity check, only used in cases of debugging

		block_codes.BME280_TEMP_FL = 1200;                                  %The current BME280 temperature reading as a converted float32 value, in Celsius.
		block_codes.BMP280_TEMP_FL = 1201;                                  %The current BMP280 temperature reading as a converted float32 value, in Celsius.
		block_codes.BME680_TEMP_FL = 1202;                                  %The current BME680 temperature reading as a converted float32 value, in Celsius.

		block_codes.BME280_PRES_FL = 1210;                                  %The current BME280 pressure reading as a converted float32 value, in Pascals (Pa).
		block_codes.BMP280_PRES_FL = 1211;                                  %The current BMP280 pressure reading as a converted float32 value, in Pascals (Pa).
		block_codes.BME680_PRES_FL = 1212;                                  %The current BME680 pressure reading as a converted float32 value, in Pascals (Pa).

		block_codes.BME280_HUM_FL = 1220;                                   %The current BM280 humidity reading as a converted float32 value, in percent (%).
		block_codes.BME680_HUM_FL = 1221;                                   %The current BME680 humidity reading as a converted float32 value, in percent (%).

		block_codes.BME680_GAS_FL = 1230;                                   %The current BME680 gas resistance reading as a converted float32 value, in units of kOhms

		block_codes.VL53L0X_DIST = 1300;                                    %The current VL53L0X distance reading as a 16-bit integer, in millimeters (-1 indicates out-of-range).
		block_codes.VL53L0X_FAIL = 1301;                                    %Indicates the VL53L0X sensor experienced a range failure.

		block_codes.SGP30_SN = 1400;                                        %The serial number of the SGP30.

		block_codes.SGP30_EC02 = 1410;                                      %The current SGp30 eCO2 reading distance reading as a 16-bit integer, in parts per million (ppm).

		block_codes.SGP30_TVOC = 1420;                                      %The current SGp30 TVOC reading distance reading as a 16-bit integer, in parts per million (ppm).

		block_codes.MLX90640_DEVICE_ID = 1500;                              %The MLX90640 unique device ID saved in the device's EEPROM.
		block_codes.MLX90640_EEPROM_DUMP = 1501;                            %Raw download of the entire MLX90640 EEPROM, as unsigned 16-bit integers.
		block_codes.MLX90640_ADC_RES = 1502;                                %ADC resolution setting on the MLX90640 (16-, 17-, 18-, or 19-bit).
		block_codes.MLX90640_REFRESH_RATE = 1503;                           %Current refresh rate on the MLX90640 (0.25, 0.5, 1, 2, 4, 8, 16, or 32 Hz).
		block_codes.MLX90640_I2C_CLOCKRATE = 1504;                          %Current I2C clock freqency used with the MLX90640 (100, 400, or 1000 kHz).

		block_codes.MLX90640_PIXELS_TO = 1510;                              %The current MLX90640 pixel readings as converted float32 values, in Celsius.
		block_codes.MLX90640_PIXELS_IM = 1511;                              %The current MLX90640 pixel readings as converted, but uncalibrationed, float32 values.
		block_codes.MLX90640_PIXELS_INT = 1512;                             %The current MLX90640 pixel readings as a raw, unsigned 16-bit integers.

		block_codes.MLX90640_I2C_TIME = 1520;                               %The I2C transfer time of the frame data from the MLX90640 to the microcontroller, in milliseconds.
		block_codes.MLX90640_CALC_TIME = 1521;                              %The calculation time for the uncalibrated or calibrated image captured by the MLX90640.
		block_codes.MLX90640_IM_WRITE_TIME = 1522;                          %The SD card write time for the MLX90640 float32 image data.
		block_codes.MLX90640_INT_WRITE_TIME = 1523;                         %The SD card write time for the MLX90640 raw uint16 data.

		block_codes.ALSPT19_LIGHT = 1600;                                   %The current analog value of the ALS-PT19 ambient light sensor, as an unsigned integer ADC value.

		block_codes.ZMOD4410_MOX_BOUND = 1700;                              %The current lower and upper bounds for the ZMOD4410 ADC reading used in calculations.
		block_codes.ZMOD4410_CONFIG_PARAMS = 1701;                          %Current configuration values for the ZMOD4410.
		block_codes.ZMOD4410_ERROR = 1702;                                  %Timestamped ZMOD4410 error event.
		block_codes.ZMOD4410_READING_FL = 1703;                             %Timestamped ZMOD4410 reading calibrated and converted to float32.
		block_codes.ZMOD4410_READING_INT = 1704;                            %Timestamped ZMOD4410 reading saved as the raw uint16 ADC value.

		block_codes.ZMOD4410_ECO2 = 1710;                                   %Timestamped ZMOD4410 eCO2 reading.
		block_codes.ZMOD4410_IAQ = 1711;                                    %Timestamped ZMOD4410 indoor air quality reading.
		block_codes.ZMOD4410_TVOC = 1712;                                   %Timestamped ZMOD4410 total volatile organic compound reading.
		block_codes.ZMOD4410_R_CDA = 1713;                                  %Timestamped ZMOD4410 total volatile organic compound reading.

		block_codes.LSM303_ACC_SETTINGS = 1800;                             %Current accelerometer reading settings on any enabled LSM303.
		block_codes.LSM303_MAG_SETTINGS = 1801;                             %Current magnetometer reading settings on any enabled LSM303.
		block_codes.LSM303_ACC_FL = 1802;                                   %Current readings from the LSM303 accelerometer, as float values in m/s^2.
		block_codes.LSM303_MAG_FL = 1803;                                   %Current readings from the LSM303 magnetometer, as float values in uT.
		block_codes.LSM303_TEMP_FL = 1804;                                  %Current readings from the LSM303 temperature sensor, as float value in degrees Celcius

		block_codes.SPECTRO_WAVELEN = 1900;                                 %Spectrometer wavelengths, in nanometers.
		block_codes.SPECTRO_TRACE = 1901;                                   %Spectrometer measurement trace.

		block_codes.PELLET_DISPENSE = 2000;                                 %Timestamped event for feeding/pellet dispensing.
		block_codes.PELLET_FAILURE = 2001;                                  %Timestamped event for feeding/pellet dispensing in which no pellet was detected.

		block_codes.HARD_PAUSE_START = 2010;                                %Timestamped event marker for the start of a session pause, with no events recorded during the pause.
		block_codes.HARD_PAUSE_START = 2011;                                %Timestamped event marker for the stop of a session pause, with no events recorded during the pause.
		block_codes.SOFT_PAUSE_START = 2012;                                %Timestamped event marker for the start of a session pause, with non-operant events recorded during the pause.
		block_codes.SOFT_PAUSE_START = 2013;                                %Timestamped event marker for the stop of a session pause, with non-operant events recorded during the pause.
		block_codes.TRIAL_START_SERIAL_DATE = 2014;                         %Timestamped event marker for the start of a trial, with accompanying microsecond clock reading

		block_codes.POSITION_START_X = 2020;                                %Starting position of an autopositioner in just the x-direction, with distance in millimeters.
		block_codes.POSITION_MOVE_X = 2021;                                 %Timestamped movement of an autopositioner in just the x-direction, with distance in millimeters.
		block_codes.POSITION_START_XY = 2022;                               %Starting position of an autopositioner in just the x- and y-directions, with distance in millimeters.
		block_codes.POSITION_MOVE_XY = 2023;                                %Timestamped movement of an autopositioner in just the x- and y-directions, with distance in millimeters.
		block_codes.POSITION_START_XYZ = 2024;                              %Starting position of an autopositioner in the x-, y-, and z- directions, with distance in millimeters.
		block_codes.POSITION_MOVE_XYZ = 2025;                               %Timestamped movement of an autopositioner in the x-, y-, and z- directions, with distance in millimeters.

		block_codes.TTL_PULSE = 2048;                                       %Timestamped event for a TTL pulse output, with channel number, voltage, and duration.

		block_codes.STREAM_INPUT_NAME = 2100;                               %Stream input name for the specified input index.

		block_codes.CALIBRATION_BASELINE = 2200;                            %Starting calibration baseline coefficient, for the specified module index.
		block_codes.CALIBRATION_SLOPE = 2201;                               %Starting calibration slope coefficient, for the specified module index.
		block_codes.CALIBRATION_BASELINE_ADJUST = 2202;                     %Timestamped in-session calibration baseline coefficient adjustment, for the specified module index.
		block_codes.CALIBRATION_SLOPE_ADJUST = 2203;                        %Timestamped in-session calibration slope coefficient adjustment, for the specified module index.

		block_codes.HIT_THRESH_TYPE = 2300;                                 %Type of hit threshold (i.e. peak force), for the specified input.

		block_codes.SECONDARY_THRESH_NAME = 2310;                           %A name/description of secondary thresholds used in the behavior.

		block_codes.INIT_THRESH_TYPE = 2320;                                %Type of initation threshold (i.e. force or touch), for the specified input.

		block_codes.REMOTE_MANUAL_FEED = 2400;                              %A timestamped manual feed event, triggered remotely.
		block_codes.HWUI_MANUAL_FEED = 2401;                                %A timestamped manual feed event, triggered from the hardware user interface.
		block_codes.FW_RANDOM_FEED = 2402;                                  %A timestamped manual feed event, triggered randomly by the firmware.
		block_codes.SWUI_MANUAL_FEED_DEPRECATED = 2403;                     %A timestamped manual feed event, triggered from a computer software user interface.
		block_codes.FW_OPERANT_FEED = 2404;                                 %A timestamped operant-rewarded feed event, trigged by the OmniHome firmware, with the possibility of multiple feedings.
		block_codes.SWUI_MANUAL_FEED = 2405;                                %A timestamped manual feed event, triggered from a computer software user interface.
		block_codes.SW_RANDOM_FEED = 2406;                                  %A timestamped manual feed event, triggered randomly by computer software.
		block_codes.SW_OPERANT_FEED = 2407;                                 %A timestamped operant-rewarded feed event, trigged by the PC-based behavioral software, with the possibility of multiple feedings.

		block_codes.MOTOTRAK_V3P0_OUTCOME = 2500;                           %MotoTrak version 3.0 trial outcome data.
		block_codes.MOTOTRAK_V3P0_SIGNAL = 2501;                            %MotoTrak version 3.0 trial stream signal.

		block_codes.POKE_BITMASK = 2560;                                    %Nosepoke status bitmask, typically written only when it changes.

		block_codes.OUTPUT_TRIGGER_NAME = 2600;                             %Name/description of the output trigger type for the given index.

		block_codes.VIBRATION_TASK_TRIAL_OUTCOME = 2700;                    %Vibration task trial outcome data.
		block_codes.VIBROTACTILE_DETECTION_TASK_TRIAL = 2701;               %Vibrotactile detection task trial data.

		block_codes.LED_DETECTION_TASK_TRIAL_OUTCOME = 2710;                %LED detection task trial outcome data.
		block_codes.LIGHT_SRC_MODEL = 2711;                                 %Light source model name.
		block_codes.LIGHT_SRC_TYPE = 2712;                                  %Light source type (i.e. LED, LASER, etc).

		block_codes.STTC_2AFC_TRIAL_OUTCOME = 2720;                         %SensiTrak tactile discrimination task trial outcome data.
		block_codes.STTC_NUM_PADS = 2721;                                   %Number of pads on the SensiTrak Tactile Carousel module.
		block_codes.MODULE_MICROSTEP = 2722;                                %Microstep setting on the specified OTMP module.
		block_codes.MODULE_STEPS_PER_ROT = 2723;                            %Steps per rotation on the specified OTMP module.

		block_codes.MODULE_PITCH_CIRC = 2730;                               %Pitch circumference, in millimeters, of the driving gear on the specified OTMP module.
		block_codes.MODULE_CENTER_OFFSET = 2731;                            %Center offset, in millimeters, for the specified OTMP module.

		block_codes.STAP_2AFC_TRIAL_OUTCOME = 2740;                         %SensiTrak proprioception discrimination task trial outcome data.

		block_codes.FR_TASK_TRIAL = 2800;                                   %Fixed reinforcement task trial data.
		block_codes.STOP_TASK_TRIAL = 2801;                                 %Stop task trial data.

end


function S = OmniTrakFileRead_Check_Field_Name(S,varargin)

%
%OmniTrakFileRead_Check_Field_Name.m - Vulintus, Inc.
%
%   OMNITRAKFILEREAD_CHECK_FIELD_NAME checks to see if the specified field
%   already exist in the data structure being generated by OmniTrakFileRead 
%   and creates the fields if they don't already exist. It is a recursive
%   function that calls itself until it gets to the end of all the
%   fieldnames and branchaes specified by the user.
%   
%   UPDATE LOG:
%   01/28/2021 - Drew Sloan - Function first implemented.
%   03/15/2022 - Drew Sloan - Rewritten to be recursive to allow for a 
%       variable number of new fields and subfields to be added.
%
%Notes for future updates:
%   The setfield function can handle non-scalar inputs, so it can be used
%   to create multiple field branches at a time, like this:
%
%       new_fields = {'field1','field2',field3',...}
%       setfield(data,new_fields{:},[]);
%
%   However, the isfield function does not handle non-scalar inputs, so
%   it's impossible to check if the field exists before creating it. The
%   getfield function handles non-scalar inputs, but it throws an error
%   when given field names that don't yet exist.
%

if nargin == 1                                                              %If only one input, the data structure, was supplied...
    return                                                                  %Skip execution of the rest of the function.
end

fieldname = varargin{1};                                                    %Grab the first fieldname.
if ~iscell(fieldname)                                                       %If the field name isn't a cell.
    fieldname = {fieldname};                                                %Convert it to a cell array.
end
for i = 1:numel(fieldname)                                                  %Step through each specified field name.       
    if ~isfield(S,fieldname{i})                                             %If the structure doesn't yet have the specified field...
        if numel(varargin) > 1                                              %If this isn't the last branch...
            S(1).(fieldname{i}) = [];                                       %Create the field as an empty value.
        else                                                                %Otherwise, if this is the last branch...
            S(1).(fieldname{i}) = struct([]);                               %Create the field as an empty structure.
        end
    end
    if numel(varargin) > 1                                                  %If there's more subfields to add...
        S(1).(fieldname{i}) = ...
            OmniTrakFileRead_Check_Field_Name(S(1).(fieldname{i}),...
            varargin{2:end});                                               %Recursively call the function to add them.
    end
end


function data = OmniTrakFileRead_ReadBlock(fid,block,data,verbose)

%OMNITRAKFILEREAD_READ_BLOCK.m
%
%	Vulintus, Inc.
%
%	OmniTrak file block read subfunction router.
%
%	https://github.com/Vulintus/OmniTrak_File_Format
%
%	This file was programmatically generated: 2025-02-11, 11:58:55 (UTC).
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
				data = OmniTrakFileRead_ReadBlock_FILE_VERSION(fid,data);

			case block_codes.MS_FILE_START                                  %Value of the SoC millisecond clock at file creation.
				data = OmniTrakFileRead_ReadBlock_MS_FILE_START(fid,data);

			case block_codes.MS_FILE_STOP                                   %Value of the SoC millisecond clock when the file is closed.
				data = OmniTrakFileRead_ReadBlock_MS_FILE_STOP(fid,data);

			case block_codes.SUBJECT_DEPRECATED                             %A single subject's name.
				data = OmniTrakFileRead_ReadBlock_SUBJECT_DEPRECATED(fid,data);

			case block_codes.CLOCK_FILE_START                               %Computer clock serial date number at file creation (local time).
				data = OmniTrakFileRead_ReadBlock_CLOCK_FILE_START(fid,data);

			case block_codes.CLOCK_FILE_STOP                                %Computer clock serial date number when the file is closed (local time).
				data = OmniTrakFileRead_ReadBlock_CLOCK_FILE_STOP(fid,data);

			case block_codes.DEVICE_FILE_INDEX                              %The device's current file index.
				data = OmniTrakFileRead_ReadBlock_DEVICE_FILE_INDEX(fid,data);

			case block_codes.NTP_SYNC                                       %A fetched NTP time (seconds since January 1, 1900) at the specified SoC millisecond clock time.
				data = OmniTrakFileRead_ReadBlock_NTP_SYNC(fid,data);

			case block_codes.NTP_SYNC_FAIL                                  %Indicates the an NTP synchonization attempt failed.
				data = OmniTrakFileRead_ReadBlock_NTP_SYNC_FAIL(fid,data);

			case block_codes.CLOCK_SYNC                               %The current SoC microsecond clock time at the specified SoC millisecond clock time.
				data = OmniTrakFileRead_ReadBlock_CLOCK_SYNC(fid,data);

			case block_codes.MS_TIMER_ROLLOVER                              %Indicates that the millisecond timer rolled over since the last loop.
				data = OmniTrakFileRead_ReadBlock_MS_TIMER_ROLLOVER(fid,data);

			case block_codes.US_TIMER_ROLLOVER                              %Indicates that the microsecond timer rolled over since the last loop.
				data = OmniTrakFileRead_ReadBlock_US_TIMER_ROLLOVER(fid,data);

			case block_codes.TIME_ZONE_OFFSET                               %Computer clock time zone offset from UTC.
				data = OmniTrakFileRead_ReadBlock_TIME_ZONE_OFFSET(fid,data);

			case block_codes.TIME_ZONE_OFFSET_HHMM                          %Computer clock time zone offset from UTC as two integers, one for hours, and the other for minutes
				data = OmniTrakFileRead_ReadBlock_TIME_ZONE_OFFSET_HHMM(fid,data);

			case block_codes.RTC_STRING_DEPRECATED                          %Current date/time string from the real-time clock.
				data = OmniTrakFileRead_ReadBlock_RTC_STRING_DEPRECATED(fid,data);

			case block_codes.RTC_STRING                                     %Current date/time string from the real-time clock.
				data = OmniTrakFileRead_ReadBlock_RTC_STRING(fid,data);

			case block_codes.RTC_VALUES                                     %Current date/time values from the real-time clock.
				data = OmniTrakFileRead_ReadBlock_RTC_VALUES(fid,data);

			case block_codes.ORIGINAL_FILENAME                              %The original filename for the data file.
				data = OmniTrakFileRead_ReadBlock_ORIGINAL_FILENAME(fid,data);

			case block_codes.RENAMED_FILE                                   %A timestamped event to indicate when a file has been renamed by one of Vulintus' automatic data organizing programs.
				data = OmniTrakFileRead_ReadBlock_RENAMED_FILE(fid,data);

			case block_codes.DOWNLOAD_TIME                                  %A timestamp indicating when the data file was downloaded from the OmniTrak device to a computer.
				data = OmniTrakFileRead_ReadBlock_DOWNLOAD_TIME(fid,data);

			case block_codes.DOWNLOAD_SYSTEM                                %The computer system name and the COM port used to download the data file form the OmniTrak device.
				data = OmniTrakFileRead_ReadBlock_DOWNLOAD_SYSTEM(fid,data);

			case block_codes.INCOMPLETE_BLOCK                               %Indicates that the file will end in an incomplete block.
				data = OmniTrakFileRead_ReadBlock_INCOMPLETE_BLOCK(fid,data);

			case block_codes.USER_TIME                                      %Date/time values from a user-set timestamp.
				data = OmniTrakFileRead_ReadBlock_USER_TIME(fid,data);

			case block_codes.SYSTEM_TYPE                                    %Vulintus system ID code (1 = MotoTrak, 2 = OmniTrak, 3 = HabiTrak, 4 = OmniHome, 5 = SensiTrak, 6 = Prototype).
				data = OmniTrakFileRead_ReadBlock_SYSTEM_TYPE(fid,data);

			case block_codes.SYSTEM_NAME                                    %Vulintus system name.
				data = OmniTrakFileRead_ReadBlock_SYSTEM_NAME(fid,data);

			case block_codes.SYSTEM_HW_VER                                  %Vulintus system hardware version.
				data = OmniTrakFileRead_ReadBlock_SYSTEM_HW_VER(fid,data);

			case block_codes.SYSTEM_FW_VER                                  %System firmware version, written as characters.
				data = OmniTrakFileRead_ReadBlock_SYSTEM_FW_VER(fid,data);

			case block_codes.SYSTEM_SN                                      %System serial number, written as characters.
				data = OmniTrakFileRead_ReadBlock_SYSTEM_SN(fid,data);

			case block_codes.SYSTEM_MFR                                     %Manufacturer name for non-Vulintus systems.
				data = OmniTrakFileRead_ReadBlock_SYSTEM_MFR(fid,data);

			case block_codes.COMPUTER_NAME                                  %Windows PC computer name.
				data = OmniTrakFileRead_ReadBlock_COMPUTER_NAME(fid,data);

			case block_codes.COM_PORT                                       %The COM port of a computer-connected system.
				data = OmniTrakFileRead_ReadBlock_COM_PORT(fid,data);

			case block_codes.DEVICE_ALIAS                                   %Human-readable Adjective + Noun alias/name for the device, assigned by Vulintus during manufacturing
				data = OmniTrakFileRead_ReadBlock_DEVICE_ALIAS(fid,data);

			case block_codes.PRIMARY_MODULE                                 %Primary module name, for systems with interchangeable modules.
				data = OmniTrakFileRead_ReadBlock_PRIMARY_MODULE(fid,data);

			case block_codes.PRIMARY_INPUT                                  %Primary input name, for modules with multiple input signals.
				data = OmniTrakFileRead_ReadBlock_PRIMARY_INPUT(fid,data);

			case block_codes.SAMD_CHIP_ID                                   %The SAMD manufacturer's unique chip identifier.
				data = OmniTrakFileRead_ReadBlock_SAMD_CHIP_ID(fid,data);

			case block_codes.ESP8266_MAC_ADDR                               %The MAC address of the device's ESP8266 module.
				data = OmniTrakFileRead_ReadBlock_ESP8266_MAC_ADDR(fid,data);

			case block_codes.ESP8266_IP4_ADDR                               %The local IPv4 address of the device's ESP8266 module.
				data = OmniTrakFileRead_ReadBlock_ESP8266_IP4_ADDR(fid,data);

			case block_codes.ESP8266_CHIP_ID                                %The ESP8266 manufacturer's unique chip identifier
				data = OmniTrakFileRead_ReadBlock_ESP8266_CHIP_ID(fid,data);

			case block_codes.ESP8266_FLASH_ID                               %The ESP8266 flash chip's unique chip identifier
				data = OmniTrakFileRead_ReadBlock_ESP8266_FLASH_ID(fid,data);

			case block_codes.USER_SYSTEM_NAME                               %The user's name for the system, i.e. booth number.
				data = OmniTrakFileRead_ReadBlock_USER_SYSTEM_NAME(fid,data);

			case block_codes.DEVICE_RESET_COUNT                             %The current reboot count saved in EEPROM or flash memory.
				data = OmniTrakFileRead_ReadBlock_DEVICE_RESET_COUNT(fid,data);

			case block_codes.CTRL_FW_FILENAME                               %Controller firmware filename, copied from the macro, written as characters.
				data = OmniTrakFileRead_ReadBlock_CTRL_FW_FILENAME(fid,data);

			case block_codes.CTRL_FW_DATE                                   %Controller firmware upload date, copied from the macro, written as characters.
				data = OmniTrakFileRead_ReadBlock_CTRL_FW_DATE(fid,data);

			case block_codes.CTRL_FW_TIME                                   %Controller firmware upload time, copied from the macro, written as characters.
				data = OmniTrakFileRead_ReadBlock_CTRL_FW_TIME(fid,data);

			case block_codes.MODULE_FW_FILENAME                             %OTMP Module firmware filename, copied from the macro, written as characters.
				data = OmniTrakFileRead_ReadBlock_MODULE_FW_FILENAME(fid,data);

			case block_codes.MODULE_FW_DATE                                 %OTMP Module firmware upload date, copied from the macro, written as characters.
				data = OmniTrakFileRead_ReadBlock_MODULE_FW_DATE(fid,data);

			case block_codes.MODULE_FW_TIME                                 %OTMP Module firmware upload time, copied from the macro, written as characters.
				data = OmniTrakFileRead_ReadBlock_MODULE_FW_TIME(fid,data);

			case block_codes.WINC1500_MAC_ADDR                              %The MAC address of the device's ATWINC1500 module.
				data = OmniTrakFileRead_ReadBlock_WINC1500_MAC_ADDR(fid,data);

			case block_codes.WINC1500_IP4_ADDR                              %The local IPv4 address of the device's ATWINC1500 module.
				data = OmniTrakFileRead_ReadBlock_WINC1500_IP4_ADDR(fid,data);

			case block_codes.BATTERY_SOC                                    %Current battery state-of charge, in percent, measured the BQ27441
				data = OmniTrakFileRead_ReadBlock_BATTERY_SOC(fid,data);

			case block_codes.BATTERY_VOLTS                                  %Current battery voltage, in millivolts, measured by the BQ27441
				data = OmniTrakFileRead_ReadBlock_BATTERY_VOLTS(fid,data);

			case block_codes.BATTERY_CURRENT                                %Average current draw from the battery, in milli-amps, measured by the BQ27441
				data = OmniTrakFileRead_ReadBlock_BATTERY_CURRENT(fid,data);

			case block_codes.BATTERY_FULL                                   %Full capacity of the battery, in milli-amp hours, measured by the BQ27441
				data = OmniTrakFileRead_ReadBlock_BATTERY_FULL(fid,data);

			case block_codes.BATTERY_REMAIN                                 %Remaining capacity of the battery, in milli-amp hours, measured by the BQ27441
				data = OmniTrakFileRead_ReadBlock_BATTERY_REMAIN(fid,data);

			case block_codes.BATTERY_POWER                                  %Average power draw, in milliWatts, measured by the BQ27441
				data = OmniTrakFileRead_ReadBlock_BATTERY_POWER(fid,data);

			case block_codes.BATTERY_SOH                                    %Battery state-of-health, in percent, measured by the BQ27441
				data = OmniTrakFileRead_ReadBlock_BATTERY_SOH(fid,data);

			case block_codes.BATTERY_STATUS                                 %Combined battery state-of-charge, voltage, current, capacity, power, and state-of-health, measured by the BQ27441
				data = OmniTrakFileRead_ReadBlock_BATTERY_STATUS(fid,data);

			case block_codes.FEED_SERVO_MAX_RPM                             %Actual rotation rate, in RPM, of the feeder servo (OmniHome) when set to 180 speed.
				data = OmniTrakFileRead_ReadBlock_FEED_SERVO_MAX_RPM(fid,data);

			case block_codes.FEED_SERVO_SPEED                               %Current speed setting (0-180) for the feeder servo (OmniHome).
				data = OmniTrakFileRead_ReadBlock_FEED_SERVO_SPEED(fid,data);

			case block_codes.SUBJECT_NAME                                   %A single subject's name.
				data = OmniTrakFileRead_ReadBlock_SUBJECT_NAME(fid,data);

			case block_codes.GROUP_NAME                                     %The subject's or subjects' experimental group name.
				data = OmniTrakFileRead_ReadBlock_GROUP_NAME(fid,data);

			case block_codes.EXP_NAME                                       %The user's name for the current experiment.
				data = OmniTrakFileRead_ReadBlock_EXP_NAME(fid,data);

			case block_codes.TASK_TYPE                                      %The user's name for task type, which can be a variant of the overall experiment type.
				data = OmniTrakFileRead_ReadBlock_TASK_TYPE(fid,data);

			case block_codes.STAGE_NAME                                     %The stage name for a behavioral session.
				data = OmniTrakFileRead_ReadBlock_STAGE_NAME(fid,data);

			case block_codes.STAGE_DESCRIPTION                              %The stage description for a behavioral session.
				data = OmniTrakFileRead_ReadBlock_STAGE_DESCRIPTION(fid,data);

			case block_codes.AMG8833_ENABLED                                %Indicates that an AMG8833 thermopile array sensor is present in the system.
				data = OmniTrakFileRead_ReadBlock_AMG8833_ENABLED(fid,data);

			case block_codes.BMP280_ENABLED                                 %Indicates that an BMP280 temperature/pressure sensor is present in the system.
				data = OmniTrakFileRead_ReadBlock_BMP280_ENABLED(fid,data);

			case block_codes.BME280_ENABLED                                 %Indicates that an BME280 temperature/pressure/humidty sensor is present in the system.
				data = OmniTrakFileRead_ReadBlock_BME280_ENABLED(fid,data);

			case block_codes.BME680_ENABLED                                 %Indicates that an BME680 temperature/pressure/humidy/VOC sensor is present in the system.
				data = OmniTrakFileRead_ReadBlock_BME680_ENABLED(fid,data);

			case block_codes.CCS811_ENABLED                                 %Indicates that an CCS811 VOC/eC02 sensor is present in the system.
				data = OmniTrakFileRead_ReadBlock_CCS811_ENABLED(fid,data);

			case block_codes.SGP30_ENABLED                                  %Indicates that an SGP30 VOC/eC02 sensor is present in the system.
				data = OmniTrakFileRead_ReadBlock_SGP30_ENABLED(fid,data);

			case block_codes.VL53L0X_ENABLED                                %Indicates that an VL53L0X time-of-flight distance sensor is present in the system.
				data = OmniTrakFileRead_ReadBlock_VL53L0X_ENABLED(fid,data);

			case block_codes.ALSPT19_ENABLED                                %Indicates that an ALS-PT19 ambient light sensor is present in the system.
				data = OmniTrakFileRead_ReadBlock_ALSPT19_ENABLED(fid,data);

			case block_codes.MLX90640_ENABLED                               %Indicates that an MLX90640 thermopile array sensor is present in the system.
				data = OmniTrakFileRead_ReadBlock_MLX90640_ENABLED(fid,data);

			case block_codes.ZMOD4410_ENABLED                               %Indicates that an ZMOD4410 VOC/eC02 sensor is present in the system.
				data = OmniTrakFileRead_ReadBlock_ZMOD4410_ENABLED(fid,data);

			case block_codes.AMBULATION_XY_THETA                            %A point in a tracked ambulation path, with absolute x- and y-coordinates in millimeters, with facing direction theta, in degrees.
				data = OmniTrakFileRead_ReadBlock_AMBULATION_XY_THETA(fid,data);

			case block_codes.AMG8833_THERM_CONV                             %The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature.
				data = OmniTrakFileRead_ReadBlock_AMG8833_THERM_CONV(fid,data);

			case block_codes.AMG8833_THERM_FL                               %The current AMG8833 thermistor reading as a converted float32 value, in Celsius.
				data = OmniTrakFileRead_ReadBlock_AMG8833_THERM_FL(fid,data);

			case block_codes.AMG8833_THERM_INT                              %The current AMG8833 thermistor reading as a raw, signed 16-bit integer.
				data = OmniTrakFileRead_ReadBlock_AMG8833_THERM_INT(fid,data);

			case block_codes.AMG8833_PIXELS_CONV                            %The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature.
				data = OmniTrakFileRead_ReadBlock_AMG8833_PIXELS_CONV(fid,data);

			case block_codes.AMG8833_PIXELS_FL                              %The current AMG8833 pixel readings as converted float32 values, in Celsius.
				data = OmniTrakFileRead_ReadBlock_AMG8833_PIXELS_FL(fid,data);

			case block_codes.AMG8833_PIXELS_INT                             %The current AMG8833 pixel readings as a raw, signed 16-bit integers.
				data = OmniTrakFileRead_ReadBlock_AMG8833_PIXELS_INT(fid,data);

			case block_codes.HTPA32X32_PIXELS_FP62                          %The current HTPA32x32 pixel readings as a fixed-point 6/2 type (6 bits for the unsigned integer part, 2 bits for the decimal part), in units of Celcius. This allows temperatures from 0 to 63.75 C.
				data = OmniTrakFileRead_ReadBlock_HTPA32X32_PIXELS_FP62(fid,data);

			case block_codes.HTPA32X32_PIXELS_INT_K                         %The current HTPA32x32 pixel readings represented as 16-bit unsigned integers in units of deciKelvin (dK, or Kelvin * 10).
				data = OmniTrakFileRead_ReadBlock_HTPA32X32_PIXELS_INT_K(fid,data);

			case block_codes.HTPA32X32_AMBIENT_TEMP                         %The current ambient temperature measured by the HTPA32x32, represented as a 32-bit float, in units of Celcius.
				data = OmniTrakFileRead_ReadBlock_HTPA32X32_AMBIENT_TEMP(fid,data);

			case block_codes.HTPA32X32_PIXELS_INT12_C                       %The current HTPA32x32 pixel readings represented as 12-bit signed integers (2 pixels for every 3 bytes) in units of deciCelsius (dC, or Celsius * 10), with values under-range set to the minimum  (2048 dC) and values over-range set to the maximum (2047 dC).
				data = OmniTrakFileRead_ReadBlock_HTPA32X32_PIXELS_INT12_C(fid,data);

			case block_codes.HTPA32X32_HOTTEST_PIXEL_FP62                   %The location and temperature of the hottest pixel in the HTPA32x32 image. This may not be the raw hottest pixel. It may have gone through some processing and filtering to determine the true hottest pixel. The temperature will be in FP62 formatted Celsius.
				data = OmniTrakFileRead_ReadBlock_HTPA32X32_HOTTEST_PIXEL_FP62(fid,data);

			case block_codes.BH1749_RGB                                     %The current red, green, blue, IR, and green2 sensor readings from the BH1749 sensor
				data = OmniTrakFileRead_ReadBlock_BH1749_RGB(fid,data);

			case block_codes.DEBUG_SANITY_CHECK                             %A special block acting as a sanity check, only used in cases of debugging
				data = OmniTrakFileRead_ReadBlock_DEBUG_SANITY_CHECK(fid,data);

			case block_codes.BME280_TEMP_FL                                 %The current BME280 temperature reading as a converted float32 value, in Celsius.
				data = OmniTrakFileRead_ReadBlock_BME280_TEMP_FL(fid,data);

			case block_codes.BMP280_TEMP_FL                                 %The current BMP280 temperature reading as a converted float32 value, in Celsius.
				data = OmniTrakFileRead_ReadBlock_BMP280_TEMP_FL(fid,data);

			case block_codes.BME680_TEMP_FL                                 %The current BME680 temperature reading as a converted float32 value, in Celsius.
				data = OmniTrakFileRead_ReadBlock_BME680_TEMP_FL(fid,data);

			case block_codes.BME280_PRES_FL                                 %The current BME280 pressure reading as a converted float32 value, in Pascals (Pa).
				data = OmniTrakFileRead_ReadBlock_BME280_PRES_FL(fid,data);

			case block_codes.BMP280_PRES_FL                                 %The current BMP280 pressure reading as a converted float32 value, in Pascals (Pa).
				data = OmniTrakFileRead_ReadBlock_BMP280_PRES_FL(fid,data);

			case block_codes.BME680_PRES_FL                                 %The current BME680 pressure reading as a converted float32 value, in Pascals (Pa).
				data = OmniTrakFileRead_ReadBlock_BME680_PRES_FL(fid,data);

			case block_codes.BME280_HUM_FL                                  %The current BM280 humidity reading as a converted float32 value, in percent (%).
				data = OmniTrakFileRead_ReadBlock_BME280_HUM_FL(fid,data);

			case block_codes.BME680_HUM_FL                                  %The current BME680 humidity reading as a converted float32 value, in percent (%).
				data = OmniTrakFileRead_ReadBlock_BME680_HUM_FL(fid,data);

			case block_codes.BME680_GAS_FL                                  %The current BME680 gas resistance reading as a converted float32 value, in units of kOhms
				data = OmniTrakFileRead_ReadBlock_BME680_GAS_FL(fid,data);

			case block_codes.VL53L0X_DIST                                   %The current VL53L0X distance reading as a 16-bit integer, in millimeters (-1 indicates out-of-range).
				data = OmniTrakFileRead_ReadBlock_VL53L0X_DIST(fid,data);

			case block_codes.VL53L0X_FAIL                                   %Indicates the VL53L0X sensor experienced a range failure.
				data = OmniTrakFileRead_ReadBlock_VL53L0X_FAIL(fid,data);

			case block_codes.SGP30_SN                                       %The serial number of the SGP30.
				data = OmniTrakFileRead_ReadBlock_SGP30_SN(fid,data);

			case block_codes.SGP30_EC02                                     %The current SGp30 eCO2 reading distance reading as a 16-bit integer, in parts per million (ppm).
				data = OmniTrakFileRead_ReadBlock_SGP30_EC02(fid,data);

			case block_codes.SGP30_TVOC                                     %The current SGp30 TVOC reading distance reading as a 16-bit integer, in parts per million (ppm).
				data = OmniTrakFileRead_ReadBlock_SGP30_TVOC(fid,data);

			case block_codes.MLX90640_DEVICE_ID                             %The MLX90640 unique device ID saved in the device's EEPROM.
				data = OmniTrakFileRead_ReadBlock_MLX90640_DEVICE_ID(fid,data);

			case block_codes.MLX90640_EEPROM_DUMP                           %Raw download of the entire MLX90640 EEPROM, as unsigned 16-bit integers.
				data = OmniTrakFileRead_ReadBlock_MLX90640_EEPROM_DUMP(fid,data);

			case block_codes.MLX90640_ADC_RES                               %ADC resolution setting on the MLX90640 (16-, 17-, 18-, or 19-bit).
				data = OmniTrakFileRead_ReadBlock_MLX90640_ADC_RES(fid,data);

			case block_codes.MLX90640_REFRESH_RATE                          %Current refresh rate on the MLX90640 (0.25, 0.5, 1, 2, 4, 8, 16, or 32 Hz).
				data = OmniTrakFileRead_ReadBlock_MLX90640_REFRESH_RATE(fid,data);

			case block_codes.MLX90640_I2C_CLOCKRATE                         %Current I2C clock freqency used with the MLX90640 (100, 400, or 1000 kHz).
				data = OmniTrakFileRead_ReadBlock_MLX90640_I2C_CLOCKRATE(fid,data);

			case block_codes.MLX90640_PIXELS_TO                             %The current MLX90640 pixel readings as converted float32 values, in Celsius.
				data = OmniTrakFileRead_ReadBlock_MLX90640_PIXELS_TO(fid,data);

			case block_codes.MLX90640_PIXELS_IM                             %The current MLX90640 pixel readings as converted, but uncalibrationed, float32 values.
				data = OmniTrakFileRead_ReadBlock_MLX90640_PIXELS_IM(fid,data);

			case block_codes.MLX90640_PIXELS_INT                            %The current MLX90640 pixel readings as a raw, unsigned 16-bit integers.
				data = OmniTrakFileRead_ReadBlock_MLX90640_PIXELS_INT(fid,data);

			case block_codes.MLX90640_I2C_TIME                              %The I2C transfer time of the frame data from the MLX90640 to the microcontroller, in milliseconds.
				data = OmniTrakFileRead_ReadBlock_MLX90640_I2C_TIME(fid,data);

			case block_codes.MLX90640_CALC_TIME                             %The calculation time for the uncalibrated or calibrated image captured by the MLX90640.
				data = OmniTrakFileRead_ReadBlock_MLX90640_CALC_TIME(fid,data);

			case block_codes.MLX90640_IM_WRITE_TIME                         %The SD card write time for the MLX90640 float32 image data.
				data = OmniTrakFileRead_ReadBlock_MLX90640_IM_WRITE_TIME(fid,data);

			case block_codes.MLX90640_INT_WRITE_TIME                        %The SD card write time for the MLX90640 raw uint16 data.
				data = OmniTrakFileRead_ReadBlock_MLX90640_INT_WRITE_TIME(fid,data);

			case block_codes.ALSPT19_LIGHT                                  %The current analog value of the ALS-PT19 ambient light sensor, as an unsigned integer ADC value.
				data = OmniTrakFileRead_ReadBlock_ALSPT19_LIGHT(fid,data);

			case block_codes.ZMOD4410_MOX_BOUND                             %The current lower and upper bounds for the ZMOD4410 ADC reading used in calculations.
				data = OmniTrakFileRead_ReadBlock_ZMOD4410_MOX_BOUND(fid,data);

			case block_codes.ZMOD4410_CONFIG_PARAMS                         %Current configuration values for the ZMOD4410.
				data = OmniTrakFileRead_ReadBlock_ZMOD4410_CONFIG_PARAMS(fid,data);

			case block_codes.ZMOD4410_ERROR                                 %Timestamped ZMOD4410 error event.
				data = OmniTrakFileRead_ReadBlock_ZMOD4410_ERROR(fid,data);

			case block_codes.ZMOD4410_READING_FL                            %Timestamped ZMOD4410 reading calibrated and converted to float32.
				data = OmniTrakFileRead_ReadBlock_ZMOD4410_READING_FL(fid,data);

			case block_codes.ZMOD4410_READING_INT                           %Timestamped ZMOD4410 reading saved as the raw uint16 ADC value.
				data = OmniTrakFileRead_ReadBlock_ZMOD4410_READING_INT(fid,data);

			case block_codes.ZMOD4410_ECO2                                  %Timestamped ZMOD4410 eCO2 reading.
				data = OmniTrakFileRead_ReadBlock_ZMOD4410_ECO2(fid,data);

			case block_codes.ZMOD4410_IAQ                                   %Timestamped ZMOD4410 indoor air quality reading.
				data = OmniTrakFileRead_ReadBlock_ZMOD4410_IAQ(fid,data);

			case block_codes.ZMOD4410_TVOC                                  %Timestamped ZMOD4410 total volatile organic compound reading.
				data = OmniTrakFileRead_ReadBlock_ZMOD4410_TVOC(fid,data);

			case block_codes.ZMOD4410_R_CDA                                 %Timestamped ZMOD4410 total volatile organic compound reading.
				data = OmniTrakFileRead_ReadBlock_ZMOD4410_R_CDA(fid,data);

			case block_codes.LSM303_ACC_SETTINGS                            %Current accelerometer reading settings on any enabled LSM303.
				data = OmniTrakFileRead_ReadBlock_LSM303_ACC_SETTINGS(fid,data);

			case block_codes.LSM303_MAG_SETTINGS                            %Current magnetometer reading settings on any enabled LSM303.
				data = OmniTrakFileRead_ReadBlock_LSM303_MAG_SETTINGS(fid,data);

			case block_codes.LSM303_ACC_FL                                  %Current readings from the LSM303 accelerometer, as float values in m/s^2.
				data = OmniTrakFileRead_ReadBlock_LSM303_ACC_FL(fid,data);

			case block_codes.LSM303_MAG_FL                                  %Current readings from the LSM303 magnetometer, as float values in uT.
				data = OmniTrakFileRead_ReadBlock_LSM303_MAG_FL(fid,data);

			case block_codes.LSM303_TEMP_FL                                 %Current readings from the LSM303 temperature sensor, as float value in degrees Celcius
				data = OmniTrakFileRead_ReadBlock_LSM303_TEMP_FL(fid,data);

			case block_codes.SPECTRO_WAVELEN                                %Spectrometer wavelengths, in nanometers.
				data = OmniTrakFileRead_ReadBlock_SPECTRO_WAVELEN(fid,data);

			case block_codes.SPECTRO_TRACE                                  %Spectrometer measurement trace.
				data = OmniTrakFileRead_ReadBlock_SPECTRO_TRACE(fid,data);

			case block_codes.PELLET_DISPENSE                                %Timestamped event for feeding/pellet dispensing.
				data = OmniTrakFileRead_ReadBlock_PELLET_DISPENSE(fid,data);

			case block_codes.PELLET_FAILURE                                 %Timestamped event for feeding/pellet dispensing in which no pellet was detected.
				data = OmniTrakFileRead_ReadBlock_PELLET_FAILURE(fid,data);

			case block_codes.HARD_PAUSE_START                               %Timestamped event marker for the start of a session pause, with no events recorded during the pause.
				data = OmniTrakFileRead_ReadBlock_HARD_PAUSE_START(fid,data);

			case block_codes.HARD_PAUSE_START                               %Timestamped event marker for the stop of a session pause, with no events recorded during the pause.
				data = OmniTrakFileRead_ReadBlock_HARD_PAUSE_START(fid,data);

			case block_codes.SOFT_PAUSE_START                               %Timestamped event marker for the start of a session pause, with non-operant events recorded during the pause.
				data = OmniTrakFileRead_ReadBlock_SOFT_PAUSE_START(fid,data);

			case block_codes.SOFT_PAUSE_START                               %Timestamped event marker for the stop of a session pause, with non-operant events recorded during the pause.
				data = OmniTrakFileRead_ReadBlock_SOFT_PAUSE_START(fid,data);

			case block_codes.TRIAL_START_SERIAL_DATE                        %Timestamped event marker for the start of a trial, with accompanying microsecond clock reading
				data = OmniTrakFileRead_ReadBlock_TRIAL_START_SERIAL_DATE(fid,data);

			case block_codes.POSITION_START_X                               %Starting position of an autopositioner in just the x-direction, with distance in millimeters.
				data = OmniTrakFileRead_ReadBlock_POSITION_START_X(fid,data);

			case block_codes.POSITION_MOVE_X                                %Timestamped movement of an autopositioner in just the x-direction, with distance in millimeters.
				data = OmniTrakFileRead_ReadBlock_POSITION_MOVE_X(fid,data);

			case block_codes.POSITION_START_XY                              %Starting position of an autopositioner in just the x- and y-directions, with distance in millimeters.
				data = OmniTrakFileRead_ReadBlock_POSITION_START_XY(fid,data);

			case block_codes.POSITION_MOVE_XY                               %Timestamped movement of an autopositioner in just the x- and y-directions, with distance in millimeters.
				data = OmniTrakFileRead_ReadBlock_POSITION_MOVE_XY(fid,data);

			case block_codes.POSITION_START_XYZ                             %Starting position of an autopositioner in the x-, y-, and z- directions, with distance in millimeters.
				data = OmniTrakFileRead_ReadBlock_POSITION_START_XYZ(fid,data);

			case block_codes.POSITION_MOVE_XYZ                              %Timestamped movement of an autopositioner in the x-, y-, and z- directions, with distance in millimeters.
				data = OmniTrakFileRead_ReadBlock_POSITION_MOVE_XYZ(fid,data);

			case block_codes.TTL_PULSE                                      %Timestamped event for a TTL pulse output, with channel number, voltage, and duration.
				data = OmniTrakFileRead_ReadBlock_TTL_PULSE(fid,data);

			case block_codes.STREAM_INPUT_NAME                              %Stream input name for the specified input index.
				data = OmniTrakFileRead_ReadBlock_STREAM_INPUT_NAME(fid,data);

			case block_codes.CALIBRATION_BASELINE                           %Starting calibration baseline coefficient, for the specified module index.
				data = OmniTrakFileRead_ReadBlock_CALIBRATION_BASELINE(fid,data);

			case block_codes.CALIBRATION_SLOPE                              %Starting calibration slope coefficient, for the specified module index.
				data = OmniTrakFileRead_ReadBlock_CALIBRATION_SLOPE(fid,data);

			case block_codes.CALIBRATION_BASELINE_ADJUST                    %Timestamped in-session calibration baseline coefficient adjustment, for the specified module index.
				data = OmniTrakFileRead_ReadBlock_CALIBRATION_BASELINE_ADJUST(fid,data);

			case block_codes.CALIBRATION_SLOPE_ADJUST                       %Timestamped in-session calibration slope coefficient adjustment, for the specified module index.
				data = OmniTrakFileRead_ReadBlock_CALIBRATION_SLOPE_ADJUST(fid,data);

			case block_codes.HIT_THRESH_TYPE                                %Type of hit threshold (i.e. peak force), for the specified input.
				data = OmniTrakFileRead_ReadBlock_HIT_THRESH_TYPE(fid,data);

			case block_codes.SECONDARY_THRESH_NAME                          %A name/description of secondary thresholds used in the behavior.
				data = OmniTrakFileRead_ReadBlock_SECONDARY_THRESH_NAME(fid,data);

			case block_codes.INIT_THRESH_TYPE                               %Type of initation threshold (i.e. force or touch), for the specified input.
				data = OmniTrakFileRead_ReadBlock_INIT_THRESH_TYPE(fid,data);

			case block_codes.REMOTE_MANUAL_FEED                             %A timestamped manual feed event, triggered remotely.
				data = OmniTrakFileRead_ReadBlock_REMOTE_MANUAL_FEED(fid,data);

			case block_codes.HWUI_MANUAL_FEED                               %A timestamped manual feed event, triggered from the hardware user interface.
				data = OmniTrakFileRead_ReadBlock_HWUI_MANUAL_FEED(fid,data);

			case block_codes.FW_RANDOM_FEED                                 %A timestamped manual feed event, triggered randomly by the firmware.
				data = OmniTrakFileRead_ReadBlock_FW_RANDOM_FEED(fid,data);

			case block_codes.SWUI_MANUAL_FEED_DEPRECATED                    %A timestamped manual feed event, triggered from a computer software user interface.
				data = OmniTrakFileRead_ReadBlock_SWUI_MANUAL_FEED_DEPRECATED(fid,data);

			case block_codes.FW_OPERANT_FEED                                %A timestamped operant-rewarded feed event, trigged by the OmniHome firmware, with the possibility of multiple feedings.
				data = OmniTrakFileRead_ReadBlock_FW_OPERANT_FEED(fid,data);

			case block_codes.SWUI_MANUAL_FEED                               %A timestamped manual feed event, triggered from a computer software user interface.
				data = OmniTrakFileRead_ReadBlock_SWUI_MANUAL_FEED(fid,data);

			case block_codes.SW_RANDOM_FEED                                 %A timestamped manual feed event, triggered randomly by computer software.
				data = OmniTrakFileRead_ReadBlock_SW_RANDOM_FEED(fid,data);

			case block_codes.SW_OPERANT_FEED                                %A timestamped operant-rewarded feed event, trigged by the PC-based behavioral software, with the possibility of multiple feedings.
				data = OmniTrakFileRead_ReadBlock_SW_OPERANT_FEED(fid,data);

			case block_codes.MOTOTRAK_V3P0_OUTCOME                          %MotoTrak version 3.0 trial outcome data.
				data = OmniTrakFileRead_ReadBlock_MOTOTRAK_V3P0_OUTCOME(fid,data);

			case block_codes.MOTOTRAK_V3P0_SIGNAL                           %MotoTrak version 3.0 trial stream signal.
				data = OmniTrakFileRead_ReadBlock_MOTOTRAK_V3P0_SIGNAL(fid,data);

			case block_codes.POKE_BITMASK                                   %Nosepoke status bitmask, typically written only when it changes.
				data = OmniTrakFileRead_ReadBlock_POKE_BITMASK(fid,data);

			case block_codes.OUTPUT_TRIGGER_NAME                            %Name/description of the output trigger type for the given index.
				data = OmniTrakFileRead_ReadBlock_OUTPUT_TRIGGER_NAME(fid,data);

			case block_codes.VIBRATION_TASK_TRIAL_OUTCOME                   %Vibration task trial outcome data.
				data = OmniTrakFileRead_ReadBlock_VIBRATION_TASK_TRIAL_OUTCOME(fid,data);

			case block_codes.VIBROTACTILE_DETECTION_TASK_TRIAL              %Vibrotactile detection task trial data.
				data = OmniTrakFileRead_ReadBlock_VIBROTACTILE_DETECTION_TASK_TRIAL(fid,data);

			case block_codes.LED_DETECTION_TASK_TRIAL_OUTCOME               %LED detection task trial outcome data.
				data = OmniTrakFileRead_ReadBlock_LED_DETECTION_TASK_TRIAL_OUTCOME(fid,data);

			case block_codes.LIGHT_SRC_MODEL                                %Light source model name.
				data = OmniTrakFileRead_ReadBlock_LIGHT_SRC_MODEL(fid,data);

			case block_codes.LIGHT_SRC_TYPE                                 %Light source type (i.e. LED, LASER, etc).
				data = OmniTrakFileRead_ReadBlock_LIGHT_SRC_TYPE(fid,data);

			case block_codes.STTC_2AFC_TRIAL_OUTCOME                        %SensiTrak tactile discrimination task trial outcome data.
				data = OmniTrakFileRead_ReadBlock_STTC_2AFC_TRIAL_OUTCOME(fid,data);

			case block_codes.STTC_NUM_PADS                                  %Number of pads on the SensiTrak Tactile Carousel module.
				data = OmniTrakFileRead_ReadBlock_STTC_NUM_PADS(fid,data);

			case block_codes.MODULE_MICROSTEP                               %Microstep setting on the specified OTMP module.
				data = OmniTrakFileRead_ReadBlock_MODULE_MICROSTEP(fid,data);

			case block_codes.MODULE_STEPS_PER_ROT                           %Steps per rotation on the specified OTMP module.
				data = OmniTrakFileRead_ReadBlock_MODULE_STEPS_PER_ROT(fid,data);

			case block_codes.MODULE_PITCH_CIRC                              %Pitch circumference, in millimeters, of the driving gear on the specified OTMP module.
				data = OmniTrakFileRead_ReadBlock_MODULE_PITCH_CIRC(fid,data);

			case block_codes.MODULE_CENTER_OFFSET                           %Center offset, in millimeters, for the specified OTMP module.
				data = OmniTrakFileRead_ReadBlock_MODULE_CENTER_OFFSET(fid,data);

			case block_codes.STAP_2AFC_TRIAL_OUTCOME                        %SensiTrak proprioception discrimination task trial outcome data.
				data = OmniTrakFileRead_ReadBlock_STAP_2AFC_TRIAL_OUTCOME(fid,data);

			case block_codes.FR_TASK_TRIAL                                  %Fixed reinforcement task trial data.
				data = OmniTrakFileRead_ReadBlock_FR_TASK_TRIAL(fid,data);

			case block_codes.STOP_TASK_TRIAL                                %Stop task trial data.
				data = OmniTrakFileRead_ReadBlock_STOP_TASK_TRIAL(fid,data);

			otherwise                                                       %No matching block.
				data = OmniTrakFileRead_Unrecognized_Block(fid,data);

	end
end


function data = OmniTrakFileRead_ReadBlock_ALSPT19_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1007
%		ALSPT19_ENABLED

fprintf(1,'Need to finish coding for Block 1007: ALSPT19_ENABLED');


function data = OmniTrakFileRead_ReadBlock_ALSPT19_LIGHT(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_AMBULATION_XY_THETA(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1024
%		DEFINITION:		AMBULATION_XY_THETA
%		DESCRIPTION:	A point in a tracked ambulation path, with absolute x- and y-coordinates in millimeters, with facing direction theta, in degrees.

data = OmniTrakFileRead_Check_Field_Name(data,'ambulation',...
    {'path_xy','orientation','micros'});                                    %Call the subfunction to check for existing fieldnames.

ver = fread(fid,1,'uint8');                                                 %Read in the AMBULATION_XY_THETA data block version.

switch ver                                                                  %Switch between the different data block versions.

    case 1                                                                  %Version 1.
        if isempty(data.ambulation.micros)                                  %If this is the first sample...
            data.ambulation.micros = fread(fid,1,'uint32');                 %Microcontroller microsecond clock timestamp.
            data.ambulation.path_xy = fread(fid,2,'float32')';              %x- and y-coordinates, in millimeters.
            data.ambulation.orientation = fread(fid,1,'float32');           %Animal overhead orientation, in degrees.
        else
            i = size(data.ambulation.micros,1) + 1;                         %Grab a new ambulation path sample index.
            data.ambulation.micros(i,1) = fread(fid,1,'uint32');            %Microcontroller microsecond clock timestamp.
            data.ambulation.path_xy(i,1:2) = fread(fid,2,'float32');        %x- and y-coordinates, in millimeters.
            data.ambulation.orientation(i,1) = fread(fid,1,'float32');      %Animal overhead orientation, in degrees.
        end

    otherwise                                                               %Unrecognized data block version.
        error(['ERROR IN %s: Data block version #%1.0f is not '...
            'recognized!'], upper(mfilename), ver);                         %Show an error.
        
end


function data = OmniTrakFileRead_ReadBlock_AMG8833_ENABLED(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_AMG8833_PIXELS_CONV(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1110
%		AMG8833_PIXELS_CONV

fprintf(1,'Need to finish coding for Block 1110: AMG8833_PIXELS_CONV');


function data = OmniTrakFileRead_ReadBlock_AMG8833_PIXELS_FL(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_AMG8833_PIXELS_INT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1112
%		AMG8833_PIXELS_INT

fprintf(1,'Need to finish coding for Block 1112: AMG8833_PIXELS_INT');


function data = OmniTrakFileRead_ReadBlock_AMG8833_THERM_CONV(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1100
%		AMG8833_THERM_CONV

fprintf(1,'Need to finish coding for Block 1100: AMG8833_THERM_CONV');


function data = OmniTrakFileRead_ReadBlock_AMG8833_THERM_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1101
%		AMG8833_THERM_FL

data = OmniTrakFileRead_Check_Field_Name(data,'temp');                      %Call the subfunction to check for existing fieldnames.
i = length(data.temp) + 1;                                                  %Grab a new temperature reading index.
data.temp(i).src = 'AMG8833';                                               %Save the source of the temperature reading.
data.temp(i).id = fread(fid,1,'uint8');                                     %Read in the AMG8833 sensor index (there may be multiple sensors).
data.temp(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.temp(i).float = fread(fid,1,'float32');                                %Save the temperature reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_AMG8833_THERM_INT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1102
%		AMG8833_THERM_INT

fprintf(1,'Need to finish coding for Block 1102: AMG8833_THERM_INT');


function data = OmniTrakFileRead_ReadBlock_BATTERY_CURRENT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		172
%		BATTERY_CURRENT

data = OmniTrakFileRead_Check_Field_Name(data,'bat','cur');                 %Call the subfunction to check for existing fieldnames.         
j = length(data.bat.current) + 1;                                           %Grab a new reading index.   
data.bat.cur(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.cur(j).reading = double(fread(fid,1,'int16'))/1000;                %Save the average current draw, in amps.


function data = OmniTrakFileRead_ReadBlock_BATTERY_FULL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		173
%		BATTERY_FULL

data = OmniTrakFileRead_Check_Field_Name(data,'bat','full');                %Call the subfunction to check for existing fieldnames.    
j = length(data.bat.full) + 1;                                              %Grab a new reading index.   
data.bat.full(j).timestamp = readtime;                                      %Save the millisecond clock timestamp for the reading.
data.bat.full(j).reading = double(fread(fid,1,'uint16'))/1000;              %Save the battery's full capacity, in amp-hours.


function data = OmniTrakFileRead_ReadBlock_BATTERY_POWER(fid,data)

%	OmniTrak File Block Code (OFBC):
%		175
%		BATTERY_POWER

data = OmniTrakFileRead_Check_Field_Name(data,'bat','pwr');                 %Call the subfunction to check for existing fieldnames.    
j = length(data.bat.pwr) + 1;                                               %Grab a new reading index.   
data.bat.pwr(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.pwr(j).reading = double(fread(fid,1,'int16'))/1000;                %Save the average power draw, in Watts.


function data = OmniTrakFileRead_ReadBlock_BATTERY_REMAIN(fid,data)

%	OmniTrak File Block Code (OFBC):
%		174
%		BATTERY_REMAIN

data = OmniTrakFileRead_Check_Field_Name(data,'bat','rem');                 %Call the subfunction to check for existing fieldnames.    
j = length(data.bat.rem) + 1;                                               %Grab a new reading index.   
data.bat.rem(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.rem(j).reading = double(fread(fid,1,'uint16'))/1000;               %Save the battery's remaining capacity, in amp-hours.


function data = OmniTrakFileRead_ReadBlock_BATTERY_SOC(fid,data)

%	OmniTrak File Block Code (OFBC):
%		170
%		BATTERY_SOC

data = OmniTrakFileRead_Check_Field_Name(data,'bat','soc');                 %Call the subfunction to check for existing fieldnames.         
j = length(data.bat.soc) + 1;                                               %Grab a new reading index.   
data.bat.soc(j).timestamp = fread(fid,1,'uint32');                          %Save the millisecond clock timestamp for the reading.
data.bat.soc(j).percent = fread(fid,1,'uint16');                            %Save the state-of-charge reading, in percent.


function data = OmniTrakFileRead_ReadBlock_BATTERY_SOH(fid,data)

%	OmniTrak File Block Code (OFBC):
%		176
%		BATTERY_SOH

data = OmniTrakFileRead_Check_Field_Name(data,'bat','sof');                 %Call the subfunction to check for existing fieldnames.    
j = length(data.bat.soh) + 1;                                               %Grab a new reading index.   
data.bat.soh(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.soh(j).reading = fread(fid,1,'int16');                             %Save the state-of-health reading, in percent.


function data = OmniTrakFileRead_ReadBlock_BATTERY_STATUS(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_BATTERY_VOLTS(fid,data)

%	OmniTrak File Block Code (OFBC):
%		171
%		BATTERY_VOLTS

data = OmniTrakFileRead_Check_Field_Name(data,'bat','volt');                %Call the subfunction to check for existing fieldnames.         
j = length(data.bat.volt) + 1;                                              %Grab a new reading index.   
data.bat.volt(j).timestamp = readtime;                                      %Save the millisecond clock timestamp for the reading.
data.bat.volt(j).reading = double(fread(fid,1,'uint16'))/1000;              %Save the battery voltage, in volts.


function data = OmniTrakFileRead_ReadBlock_BH1749_RGB(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1120
%		BH1749_RGB

data = OmniTrakFileRead_Check_Field_Name(data,'light');                     %Call the subfunction to check for existing fieldnames.
i = length(data.light) + 1;                                                 %Grab a new ambient light reading index.
data.light(i).src = 'BH1749';                                               %Save the source of the ambient light reading.
data.light(i).id = fread(fid,1,'uint8');                                    %Read in the BME680/688 sensor index (there may be multiple sensors).
data.light(i).timestamp = fread(fid,1,'uint32');                            %Save the microcontroller millisecond clock timestamp for the reading.
data.light(i).rgb = fread(fid,3,'uint16');                                  %Save the primary RGB ADC readings as uint16 values.
data.light(i).nir = fread(fid,1,'uint16');                                  %Save the near-infrared (NIR) ADC reading as a uint16 value.
data.light(i).grn2 = fread(fid,1,'uint16');                                 %Save the secondary Green-2 ADC reading as a uint16 value.


function data = OmniTrakFileRead_ReadBlock_BME280_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1002
%		BME280_ENABLED

fprintf(1,'Need to finish coding for Block 1002: BME280_ENABLED');


function data = OmniTrakFileRead_ReadBlock_BME280_HUM_FL(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_BME280_PRES_FL(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_BME280_TEMP_FL(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_BME680_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1003
%		BME680_ENABLED

fprintf(1,'Need to finish coding for Block 1003: BME680_ENABLED');


function data = OmniTrakFileRead_ReadBlock_BME680_GAS_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1230
%		DEFINITION:		BME680_GAS_FL
%		DESCRIPTION:	The current BME680 gas resistance reading as a converted float32 value, in units of kOhms

data = OmniTrakFileRead_Check_Field_Name(data,'gas');                       %Call the subfunction to check for existing fieldnames.
i = length(data.gas) + 1;                                                   %Grab a new gas resistance reading index.
data.gas(i).src = 'BME68X';                                                 %Save the source of the gas resistance reading.
data.gas(i).id = fread(fid,1,'uint8');                                      %Read in the BME680/688 sensor index (there may be multiple sensors).
data.gas(i).timestamp = fread(fid,1,'uint32');                              %Save the microcontroller millisecond clock timestamp for the reading.
data.gas(i).kohms = fread(fid,1,'float32');                                 %Save the gas resistance reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_BME680_HUM_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1221
%		DEFINITION:		BME680_HUM_FL
%		DESCRIPTION:	The current BME680 humidity reading as a converted float32 value, in percent (%).

data = OmniTrakFileRead_Check_Field_Name(data,'hum');                       %Call the subfunction to check for existing fieldnames.
i = length(data.hum) + 1;                                                   %Grab a new ambient humidity reading index.
data.hum(i).src = 'BME68X';                                                 %Save the source of the ambient humidity reading.
data.hum(i).id = fread(fid,1,'uint8');                                      %Read in the BME680/688 sensor index (there may be multiple sensors).
data.hum(i).timestamp = fread(fid,1,'uint32');                              %Save the microcontroller millisecond clock timestamp for the reading.
data.hum(i).percent = fread(fid,1,'float32');                               %Save the ambient humidity reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_BME680_PRES_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1212
%		BME680_PRES_FL

data = OmniTrakFileRead_Check_Field_Name(data,'pres');                      %Call the subfunction to check for existing fieldnames.
i = length(data.pres) + 1;                                                  %Grab a new ambient pressure reading index.
data.pres(i).src = 'BME68X';                                                %Save the source of the ambient pressure reading.
data.pres(i).id = fread(fid,1,'uint8');                                     %Read in the BME680/688 sensor index (there may be multiple sensors).
data.pres(i).timestamp = fread(fid,1,'uint32');                             %Save the microcontroller millisecond clock timestamp for the reading.
data.pres(i).pascals = fread(fid,1,'float32');                              %Save the ambient pressure reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_BME680_TEMP_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1202
%		BME680_TEMP_FL

data = OmniTrakFileRead_Check_Field_Name(data,'temp');                      %Call the subfunction to check for existing fieldnames.
i = length(data.temp) + 1;                                                  %Grab a new temperature reading index.
data.temp(i).src = 'BME68X';                                                %Save the source of the temperature reading.
data.temp(i).id = fread(fid,1,'uint8');                                     %Read in the BME680/688 sensor index (there may be multiple sensors).
data.temp(i).timestamp = fread(fid,1,'uint32');                             %Save the microcontroller millisecond clock timestamp for the reading.
data.temp(i).celsius = fread(fid,1,'float32');                              %Save the temperature reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_BMP280_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1001
%		BMP280_ENABLED

fprintf(1,'Need to finish coding for Block 1001: BMP280_ENABLED');


function data = OmniTrakFileRead_ReadBlock_BMP280_PRES_FL(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_BMP280_TEMP_FL(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_CALIBRATION_BASELINE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2200
%		CALIBRATION_BASELINE

data = OmniTrakFileRead_Check_Field_Name(data,'calibration');               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the module index.
data.calibration(i).baseline = fread(fid,1,'float32');                      %Save the calibration baseline coefficient.


function data = OmniTrakFileRead_ReadBlock_CALIBRATION_BASELINE_ADJUST(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2202
%		CALIBRATION_BASELINE_ADJUST

fprintf(1,'Need to finish coding for Block 2202: CALIBRATION_BASELINE_ADJUST');


function data = OmniTrakFileRead_ReadBlock_CALIBRATION_SLOPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2201
%		CALIBRATION_SLOPE

data = OmniTrakFileRead_Check_Field_Name(data,'calibration');               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the module index.
data.calibration(i).slope = fread(fid,1,'float32');                         %Save the calibration baseline coefficient.


function data = OmniTrakFileRead_ReadBlock_CALIBRATION_SLOPE_ADJUST(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2203
%		CALIBRATION_SLOPE_ADJUST

fprintf(1,'Need to finish coding for Block 2203: CALIBRATION_SLOPE_ADJUST');


function data = OmniTrakFileRead_ReadBlock_CCS811_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1004
%		CCS811_ENABLED

fprintf(1,'Need to finish coding for Block 1004: CCS811_ENABLED');


function data = OmniTrakFileRead_ReadBlock_CLOCK_FILE_START(fid,data)

%	OmniTrak File Block Code (OFBC):
%		6
%		CLOCK_FILE_START

data = OmniTrakFileRead_Check_Field_Name(data,'file_start','datenum');      %Call the subfunction to check for existing fieldnames.    
data.file_start.datenum = fread(fid,1,'float64');                           %Save the file start 32-bit millisecond clock timestamp.


function data = OmniTrakFileRead_ReadBlock_CLOCK_FILE_STOP(fid,data)

%	OmniTrak File Block Code (OFBC):
%		7
%		CLOCK_FILE_STOP

data = OmniTrakFileRead_Check_Field_Name(data,'file_stop','datenum');       %Call the subfunction to check for existing fieldnames.
data.file_stop.datenum = fread(fid,1,'float64');                            %Save the file stop 32-bit millisecond clock timestamp.


function data = OmniTrakFileRead_ReadBlock_COMPUTER_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		106
%		COMPUTER_NAME

data = OmniTrakFileRead_Check_Field_Name(data,'device','computer');         %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device.computer = char(fread(fid,N,'uchar')');                         %Read in the computer name.


function data = OmniTrakFileRead_ReadBlock_COM_PORT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		107
%		COM_PORT

data = OmniTrakFileRead_Check_Field_Name(data,'device','com_port');         %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device.com_port = char(fread(fid,N,'uchar')');                         %Read in the port name.


function data = OmniTrakFileRead_ReadBlock_CTRL_FW_DATE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	142
%		DEFINITION:		CTRL_FW_DATE
%		DESCRIPTION:	Controller firmware upload date, copied from the macro, written as characters.
%
% str = handles.ctrl.get_firmware_date();                                  
% fwrite(fid,ofbc.CTRL_FW_DATE,'uint16');                       
% fwrite(fid,length(str),'uint8');                                      
% fwrite(fid,str,'uchar');                              

data = OmniTrakFileRead_Check_Field_Name(data,'device','controller',...
    'firmware','upload_time');                                              %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
str = char(fread(fid,N,'uchar')');                                          %Read in the characters of the macro.
if numel(str) > 11                                                          %If there's more than 11 characters in the timestamp...    
    N = N - 11;                                                             %Calculate how many extra bytes were read.
    fseek(fid,-N,'cof');                                                    %Rewind the data file back the extra bytes.
    a = ftell(fid);                                                         %Grab the starting position of the weird chunk.
    block_code = 0;                                                         %Create a block code checker.
    while block_code ~= 143 && ~feof(fid)                                   %Loop until we get to the firmware time.
        block_code = fread(fid,1,'uint16');                                 %Read in two bytes as a block code.
        fseek(fid,-1,'cof');                                                %Rewind one byte.
    end
    fseek(fid,-1,'cof');                                                    %Rewind another byte.
    b = ftell(fid);                                                         %Grab the starting position of the weird chunk.
    fprintf(1,'FW_DATE Weirdness: %1.0f extra bytes.\n',b-a);               %Write the number of bytes in between.
end
date_val = datenum(str(1:11));                                              %Convert the date string to a date number.
if ~isempty(data.device.controller.firmware.upload_time)                    %If there's already an upload time listed...
    time_val = rem(data.device.controller.firmware.upload_time);            %Grab the fractional part of the timestamp.
else                                                                        %Otherwise...
    time_val = 0;                                                           %Set the fraction time to zero.
end
data.device.controller.firmware.upload_time = date_val + time_val;          %Save the date with any existing fractional time.


function data = OmniTrakFileRead_ReadBlock_CTRL_FW_FILENAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	141
%		DEFINITION:		CTRL_FW_FILENAME
%		DESCRIPTION:	Controller firmware filename, copied from the macro, written as characters.
%
% fwrite(fid,ofbc.CTRL_FW_FILENAME,'uint16');  
% fwrite(fid,length(str),'uint8');                
% fwrite(fid,str,'uchar');                                   

data = OmniTrakFileRead_Check_Field_Name(data,'device','controller',...
    'firmware','filename');                                                 %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device.controller.firmware.filename = char(fread(fid,N,'uchar')');     %Read in the firmware filename.
if ~endsWith(data.device.controller.firmware.filename,'ino')                %If the filename doesn't end in *.ino...
    while ~endsWith(data.device.controller.firmware.filename,'.ino')        %Loop until we find the *.ino extension.
        fseek(fid,-N,'cof');                                                %Rewind the file to the start of the characters.
        N = N + 1;                                                          %Increment the character count.
        data.device.controller.firmware.filename = ...
            char(fread(fid,N,'uchar')');                                    %Read in the firmware filename.
%         fprintf(1,'%s\n',data.device.controller.firmware.filename)
    end
end


function data = OmniTrakFileRead_ReadBlock_CTRL_FW_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	143
%		DEFINITION:		CTRL_FW_TIME
%		DESCRIPTION:	Controller firmware upload time, copied from the macro, written as characters.
%
% str = handles.ctrl.get_firmware_time();
% fwrite(fid,ofbc.CTRL_FW_TIME,'uint16');
% fwrite(fid,length(str),'uint8');
% fwrite(fid,str,'uchar');
%

data = OmniTrakFileRead_Check_Field_Name(data,'device','controller',...
    'firmware','upload_time');                                              %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
str = char(fread(fid,N,'uchar')');                                          %Read in the characters of the macro.
if numel(str) > 8                                                           %If there's more than 11 characters in the timestamp...
    N = N - 8;                                                              %Calculate how many extra bytes were read.
    fseek(fid,-N,'cof');                                                    %Rewind the data file back the extra bytes.
    a = ftell(fid);                                                         %Grab the starting position of the weird chunk.
    block_code = 0;                                                         %Create a block code checker.
    while block_code ~= 110 && ~feof(fid)                                   %Loop until we get to the firmware time.
        block_code = fread(fid,1,'uint16');                                 %Read in two bytes as a block code.
        fseek(fid,-1,'cof');                                                %Rewind one byte.
    end
    fseek(fid,-1,'cof');                                                    %Rewind another byte.
    b = ftell(fid);                                                         %Grab the starting position of the weird chunk.
    fprintf(1,'FW_TIME Weirdness: %1.0f extra bytes.\n',b-a);               %Write the number of bytes in between.
end
time_val = rem(datenum(str(1:8)),1);                                        %Convert the time string to a date number.
if ~isempty(data.device.controller.firmware.upload_time)                    %If there's already an upload time listed...
    date_val = fix(data.device.controller.firmware.upload_time);            %Grab the non-fractional part of the timestamp.
else                                                                        %Otherwise...
    date_val = 0;                                                           %Set the non-fractional time to zero.
end
data.device.controller.firmware.upload_time = date_val + time_val;          %Save the date with any existing fractional time.


function data = OmniTrakFileRead_ReadBlock_DEBUG_SANITY_CHECK(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1121
%		DEFINITION:		DEBUG_SANITY_CHECK
%		DESCRIPTION:	A special block acting as a sanity check, only used in cases of debugging

fprintf(1,'Need to finish coding for Block 1121: DEBUG_SANITY_CHECK\n');


function data = OmniTrakFileRead_ReadBlock_DEVICE_ALIAS(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	108
%		DEFINITION:		DEVICE_ALIAS
%		DESCRIPTION:	Human-readable Adjective + Noun alias/name for the device, assigned by Vulintus during manufacturing

data = OmniTrakFileRead_Check_Field_Name(data,'device','alias');            %Call the subfunction to check for existing fieldnames.
nchar = fread(fid,1,'uint8');                                               %Read in the number of characters in the device alias.
data.device.alias = char(fread(fid,nchar,'uchar')');                        %Save the 32-bit SAMD chip ID.


function data = OmniTrakFileRead_ReadBlock_DEVICE_FILE_INDEX(fid,data)

%	OmniTrak File Block Code (OFBC):
%		10
%		DEVICE_FILE_INDEX

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
data.device.file_index = fread(fid,1,'uint32');                             %Save the 32-bit integer file index.


function data = OmniTrakFileRead_ReadBlock_DEVICE_RESET_COUNT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		140
%		DEVICE_RESET_COUNT

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
data.device.reset_count = fread(fid,1,'uint16');                            %Save the device's reset count for the file.


function data = OmniTrakFileRead_ReadBlock_DOWNLOAD_SYSTEM(fid,data)

%	OmniTrak File Block Code (OFBC):
%		43
%		DOWNLOAD_SYSTEM

data = OmniTrakFileRead_Check_Field_Name(data,'file_info','download');      %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.file_info.download.computer = ...
    char(fread(fid,N,'uchar')');                                            %Read in the computer name.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.file_info.download.port = char(fread(fid,N,'uchar')');                 %Read in the port name.


function data = OmniTrakFileRead_ReadBlock_DOWNLOAD_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		42
%		DOWNLOAD_TIME

data = OmniTrakFileRead_Check_Field_Name(data,'file_info','download',...
    'time');                                                                %Call the subfunction to check for existing fieldnames.
data.file_info.download.time = fread(fid,1,'float64');                      %Read in the timestamp for the download.


function data = OmniTrakFileRead_ReadBlock_ESP8266_CHIP_ID(fid,data)

%	OmniTrak File Block Code (OFBC):
%		122
%		ESP8266_CHIP_ID

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
data.device.chip_id = fread(fid,1,'uint32');                                %Save the device's unique chip ID.


function data = OmniTrakFileRead_ReadBlock_ESP8266_FLASH_ID(fid,data)

%	OmniTrak File Block Code (OFBC):
%		123
%		ESP8266_FLASH_ID

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
data.device.flash_id = fread(fid,1,'uint32');                               %Save the device's unique flash chip ID.


function data = OmniTrakFileRead_ReadBlock_ESP8266_IP4_ADDR(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	121
%		DEFINITION:		ESP8266_IP4_ADDR
%		DESCRIPTION:	The local IPv4 address of the device's ESP8266 module.

fprintf(1,'Need to finish coding for Block 121: ESP8266_IP4_ADDR\n');


function data = OmniTrakFileRead_ReadBlock_ESP8266_MAC_ADDR(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	120
%		DEFINITION:		ESP8266_MAC_ADDR
%		DESCRIPTION:	The MAC address of the device's ESP8266 module.

fprintf(1,'Need to finish coding for Block 120: ESP8266_MAC_ADDR\n');


function data = OmniTrakFileRead_ReadBlock_EXP_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		300
%		EXP_NAME

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.exp_name = fread(fid,N,'*char')';                                      %Read in the characters of the user's experiment name.


function data = OmniTrakFileRead_ReadBlock_FEED_SERVO_MAX_RPM(fid,data)

%	OmniTrak File Block Code (OFBC):
%		190
%		FEED_SERVO_MAX_RPM

data = OmniTrakFileRead_Check_Field_Name(data,'device','feeder');           %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.
data.device.feeder(i).max_rpm = fread(fid,1,'float32');                     %Read in the maximum measure speed, in RPM.


function data = OmniTrakFileRead_ReadBlock_FEED_SERVO_SPEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		191
%		FEED_SERVO_SPEED

data = OmniTrakFileRead_Check_Field_Name(data,'device','feeder');           %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.
data.device.feeder(i).servo_speed = fread(fid,1,'uint8');                   %Read in the current speed setting (0-180).


function data = OmniTrakFileRead_ReadBlock_FILE_VERSION(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1
%		FILE_VERSION

fprintf(1,'Need to finish coding for Block 1: FILE_VERSION');


function data = OmniTrakFileRead_ReadBlock_FR_TASK_TRIAL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2800
%		DEFINITION:		FR_TASK_TRIAL
%		DESCRIPTION:	Fixed reinforcement task trial data.


data = OmniTrakFileRead_Check_Field_Name(data,'trial');                     %Call the subfunction to check for existing fieldnames.

ver = fread(fid,1,'uint16');                                                %Read in the FR_TASK_TRIAL data block version

switch ver                                                                  %Switch between the different data block versions.

    case 1                                                                  %Version 1.
        t = fread(fid,1,'uint16');                                          %Read in the trial index.
        data.trial(t).datenum = fread(fid,1,'float64');                     %Read in the serial date number timestamp.
        data.trial(t).outcome = fread(fid,1,'*char');                       %Read in the outcome code.
        data.trial(t).target_poke = fread(fid,1,'uint8');                   %Read in the target nosepoke index.
        data.trial(t).thresh = fread(fid,1,'uint8');                        %Read in the required number of pokes.
        data.trial(t).poke_count = fread(fid,1,'uint16');                   %Read in the number of completed pokes.
        data.trial(t).hit_time = fread(fid,1,'float32');                    %Read in the hit (first reward) time (0 for no reward).
        data.trial(t).reward_dur = fread(fid,1,'float32');                  %Read in the reward window duration (lick availability), in seconds.
        data.trial(t).num_licks = fread(fid,1,'uint16');                    %Read in the number of licks.
        data.trial(t).num_feedings = fread(fid,1,'uint16');                 %Read in the number of feedings/dispensings.

    otherwise                                                               %Unrecognized data block version.
        error(['ERROR IN %s: Data block version #%1.0f is not '...
            'recognized!'], upper(mfilename), ver);                         %Show an error.
        
end


function data = OmniTrakFileRead_ReadBlock_FW_OPERANT_FEED(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_FW_RANDOM_FEED(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_GROUP_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		201
%		GROUP_NAME

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.group = fread(fid,N,'*char')';                                         %Read in the characters of the group name.


function data = OmniTrakFileRead_ReadBlock_HARD_PAUSE_START(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2010
%		HARD_PAUSE_START

fprintf(1,'Need to finish coding for Block 2010: HARD_PAUSE_START');


function data = OmniTrakFileRead_ReadBlock_HIT_THRESH_TYPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2300
%		HIT_THRESH_TYPE

data = OmniTrakFileRead_Check_Field_Name(data,'hit_thresh_type');           %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the signal index.
if isempty(data.hit_thresh_type)                                            %If there's no hit threshold type yet set...
    data.hit_thresh_type = cell(i,1);                                       %Create a cell array to hold the threshold types.
end
N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.hit_thresh_type{i} = fread(fid,N,'*char')';                            %Read in the characters of the user's experiment name.


function data = OmniTrakFileRead_ReadBlock_HTPA32X32_AMBIENT_TEMP(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1115
%		DEFINITION:		HTPA32X32_AMBIENT_TEMP
%		DESCRIPTION:	The current ambient temperature measured by the HTPA32x32, represented as a 32-bit float, in units of Celcius.


data = OmniTrakFileRead_Check_Field_Name(data,'temp');                      %Call the subfunction to check for existing fieldnames.
i = length(data.temp) + 1;                                                  %Grab a new temperature reading index.
data.temp(i).src = 'HTPA32x32';                                             %Save the source of the temperature reading.
data.temp(i).id = fread(fid,1,'uint8');                                     %Read in the HTPA sensor index (there may be multiple sensors).
data.temp(i).timestamp = fread(fid,1,'uint32');                             %Save the microcontroller millisecond clock timestamp for the reading.
data.temp(i).celsius = fread(fid,1,'float32');                              %Save the temperature reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_HTPA32X32_HOTTEST_PIXEL_FP62(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1117
%		DEFINITION:		HTPA32X32_HOTTEST_PIXEL_FP62
%		DESCRIPTION:	The location and temperature of the hottest pixel in the HTPA32x32 image. This may not be the raw hottest pixel. It may have gone through some processing and filtering to determine the true hottest pixel. The temperature will be in FP62 formatted Celsius.

fprintf(1,'Need to finish coding for Block 1117: HTPA32X32_HOTTEST_PIXEL_FP62\n');


function data = OmniTrakFileRead_ReadBlock_HTPA32X32_PIXELS_FP62(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1113
%		DEFINITION:		HTPA32X32_PIXELS_FP62
%		DESCRIPTION:	The current HTPA32x32 pixel readings as a fixed-point 6/2 type (6 bits for the unsigned integer part, 2 bits for the decimal part), in units of Celcius. This allows temperatures from 0 to 63.75 C.

fprintf(1,'Need to finish coding for Block 1113: HTPA32X32_PIXELS_FP62\n');


function data = OmniTrakFileRead_ReadBlock_HTPA32X32_PIXELS_INT12_C(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1116
%		DEFINITION:		HTPA32X32_PIXELS_INT12_C
%		DESCRIPTION:	The current HTPA32x32 pixel readings represented as 12-bit signed integers (2 pixels for every 3 bytes) in units of deciCelsius (dC, or Celsius * 10), with values under-range set to the minimum  (2048 dC) and values over-range set to the maximum (2047 dC).

fprintf(1,'Need to finish coding for Block 1116: HTPA32X32_PIXELS_INT12_C\n');


function data = OmniTrakFileRead_ReadBlock_HTPA32X32_PIXELS_INT_K(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1114
%		DEFINITION:		HTPA32X32_PIXELS_INT_K
%		DESCRIPTION:	The current HTPA32x32 pixel readings represented as 16-bit unsigned integers in units of deciKelvin (dK, or Kelvin * 10).


data = OmniTrakFileRead_Check_Field_Name(data,'htpa','id');                 %Call the subfunction to check for existing fieldnames.
id = fread(fid,1,'uint8');                                                  %Read in the HTPA sensor index (there may be multiple sensors).
if isempty(data.htpa(1).id)                                                 %If this is the first reading for any HTPA sensor.
    sensor_i = 1;                                                           %Set the sensor index to 1.
    data.htpa(sensor_i).id = id;                                            %Save the sensor index.
else                                                                        %Otherwise...
    existing_ids = vertcat(data.htpa.id);                                   %Grab all of the existing HTAP sensor IDs.
    sensor_i = find(id == existing_ids);                                    %Find the index for the current sensor.
end
data.htpa = OmniTrakFileRead_Check_Field_Name(data.htpa,'pixels');          %Call the subfunction to check for existing fieldnames.
reading_i = length(data.htpa(sensor_i).pixels) + 1;                         %Increment the sensor index.
data.htpa(sensor_i).pixels(reading_i).timestamp = fread(fid,1,'uint32');    %Save the microcontroller millisecond clock timestamp for the reading.
% temp = fread(fid,1024,'uint8');                                             %Read in the pixel values as 16-bit unsigned integers of deciKelvin.
temp = fread(fid,1024,'uint16');                                            %Read in the pixel values as 16-bit unsigned integers of deciKelvin.
data.htpa(sensor_i).pixels(reading_i).decikelvin = reshape(temp,32,32)';    %Reshape the values into a 32x32 matrix.


function data = OmniTrakFileRead_ReadBlock_HWUI_MANUAL_FEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2401
%		HWUI_MANUAL_FEED

data = OmniTrakFileRead_Check_Field_Name(data,'pellet',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.                
j = size(data.pellet(i).time,1) + 1;                                        %Find the next index for the pellet timestamp for this dispenser.
if j == 1                                                                   %If this is the first manual feeding...
    data.feed(i).time = fread(fid,1,'float64');                             %Save the millisecond clock timestamp.
    data.feed(i).num = fread(fid,1,'uint16');                               %Save the number of feedings.
    data.feed(i).source = {'manual_hardware'};                              %Save the feed trigger source.  
else                                                                        %Otherwise, if this isn't the first manual feeding...
    data.feed(i).time(j,1) = fread(fid,1,'float64');                        %Save the millisecond clock timestamp.
    data.feed(i).num(j,1) = fread(fid,1,'uint16');                          %Save the number of feedings.
    data.feed(i).source{j,1} = 'manual_hardware';                           %Save the feed trigger source.
end


function data = OmniTrakFileRead_ReadBlock_INCOMPLETE_BLOCK(fid,data)

%	OmniTrak File Block Code (OFBC):
%		50
%		INCOMPLETE_BLOCK

fprintf(1,'Need to finish coding for Block 50: INCOMPLETE_BLOCK');


function data = OmniTrakFileRead_ReadBlock_INIT_THRESH_TYPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2320
%		INIT_THRESH_TYPE

fprintf(1,'Need to finish coding for Block 2320: INIT_THRESH_TYPE');


function data = OmniTrakFileRead_ReadBlock_LED_DETECTION_TASK_TRIAL_OUTCOME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2710
%		LED_DETECTION_TASK_TRIAL_OUTCOME

data = OmniTrakFileRead_Check_Field_Name(data,'trial');                     %Call the subfunction to check for existing fieldnames.
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


function data = OmniTrakFileRead_ReadBlock_LIGHT_SRC_MODEL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2711
%		LIGHT_SRC_MODEL

data = OmniTrakFileRead_Check_Field_Name(data,'light_src','chan');          %Call the subfunction to check for existing fieldnames.
module_i = fread(fid,1,'uint8');                                            %Read in the module index.
ls_i = fread(fid,1,'uint16');                                               %Read in the light source channel index.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters in the light source model.
data.light_src(module_i).chan(ls_i).model = fread(fid,N,'*char')';          %Read in the characters of the light source model.


function data = OmniTrakFileRead_ReadBlock_LIGHT_SRC_TYPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2712
%		LIGHT_SRC_TYPE

data = OmniTrakFileRead_Check_Field_Name(data,'light_src','chan');          %Call the subfunction to check for existing fieldnames.
module_i = fread(fid,1,'uint8');                                            %Read in the module index.
ls_i = fread(fid,1,'uint16');                                               %Read in the light source channel index.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters in the light source type.
data.light_src(module_i).chan(ls_i).type = fread(fid,N,'*char')';           %Read in the characters of the light source type.


function data = OmniTrakFileRead_ReadBlock_LSM303_ACC_FL(fid,data)

%   Block Code: 1802
%   Block Definition: LSM303_ACC_FL
%   Description: "Current readings from the LSM303D accelerometer, as float values in m/s^2."
%   Status:
%   Block Format:
%     * 1x (uint8): LSM303D I2C address or ID.
%     * 1x (uint32): microcontroller timestamp, whole number of milliseconds.
%     * 3x (float32): x, y, & z acceleration readings, in m/s^2.


data = OmniTrakFileRead_Check_Field_Name(data,'accel');                     %Call the subfunction to check for existing fieldnames.
i = length(data.accel) + 1;                                                 %Grab a new accelerometer reading index.
data.accel(i).src = 'LSM303';                                               %Save the source of the accelerometer reading.
data.accel(i).id = fread(fid,1,'uint8');                                    %Read in the accelerometer sensor index (there may be multiple sensors).
data.accel(i).time = fread(fid,1,'uint32');                                 %Save the millisecond clock timestamp for the reading.
data.accel(i).xyz = fread(fid,3,'float32');                                 %Save the accelerometer x-y-z readings as float-32 values.


function data = OmniTrakFileRead_ReadBlock_LSM303_ACC_SETTINGS(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1800
%		LSM303_ACC_SETTINGS

fprintf(1,'Need to finish coding for Block 1800: LSM303_ACC_SETTINGS');


function data = OmniTrakFileRead_ReadBlock_LSM303_MAG_FL(fid,data)

%   Block Code: 1803
%   Block Definition: LSM303_MAG_FL
%   Description: "Current readings from the LSM303D magnetometer, as float values in uT."
%   Status:
%   Block Format:
%     * 1x (uint8): LSM303D I2C address or ID.
%     * 1x (uint32): microcontroller timestamp, whole number of milliseconds.
%     * 3x (float32): x, y, & z magnetometer readings, in uT.


data = OmniTrakFileRead_Check_Field_Name(data,'mag');                       %Call the subfunction to check for existing fieldnames.
i = length(data.mag) + 1;                                                   %Grab a new magnetometer reading index.
data.mag(i).src = 'LSM303';                                                 %Save the source of the magnetometer reading.
data.mag(i).id = fread(fid,1,'uint8');                                      %Read in the magnetometer sensor index (there may be multiple sensors).
data.mag(i).time = fread(fid,1,'uint32');                                   %Save the millisecond clock timestamp for the reading.
data.mag(i).xyz = fread(fid,3,'float32');                                   %Save the magnetometer x-y-z readings as float-32 values.


function data = OmniTrakFileRead_ReadBlock_LSM303_MAG_SETTINGS(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1801
%		LSM303_MAG_SETTINGS

fprintf(1,'Need to finish coding for Block 1801: LSM303_MAG_SETTINGS');


function data = OmniTrakFileRead_ReadBlock_LSM303_TEMP_FL(fid,data)

%   Block Code: 1804
%   Block Definition: LSM303_TEMP_FL
%   Description: ."Current readings from the LSM303 temperature sensor, as float value in degrees Celsius."
%   Status:
%   Block Format:
%     * 1x (uint8) LSM303 I2C address or ID. 
%     * 1x (uint32) millisecond timestamp. 
%     * 1x (float32) temperature reading, in Celsius.


data = OmniTrakFileRead_Check_Field_Name(data,'temp');                      %Call the subfunction to check for existing fieldnames.
i = length(data.temp) + 1;                                                  %Grab a new temperature reading index.
data.temp(i).src = 'LSM303';                                                %Save the source of the temperature reading.
data.temp(i).id = fread(fid,1,'uint8');                                     %Read in the HTPA sensor index (there may be multiple sensors).
data.temp(i).timestamp = fread(fid,1,'uint32');                             %Save the microcontroller millisecond clock timestamp for the reading.
data.temp(i).celsius = fread(fid,1,'float32');                              %Save the temperature reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_MLX90640_ADC_RES(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1502
%		MLX90640_ADC_RES

fprintf(1,'Need to finish coding for Block 1502: MLX90640_ADC_RES');


function data = OmniTrakFileRead_ReadBlock_MLX90640_CALC_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1521
%		MLX90640_CALC_TIME

fprintf(1,'Need to finish coding for Block 1521: MLX90640_CALC_TIME');


function data = OmniTrakFileRead_ReadBlock_MLX90640_DEVICE_ID(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1500
%		MLX90640_DEVICE_ID

fprintf(1,'Need to finish coding for Block 1500: MLX90640_DEVICE_ID');


function data = OmniTrakFileRead_ReadBlock_MLX90640_EEPROM_DUMP(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1501
%		MLX90640_EEPROM_DUMP

fprintf(1,'Need to finish coding for Block 1501: MLX90640_EEPROM_DUMP');


function data = OmniTrakFileRead_ReadBlock_MLX90640_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1008
%		MLX90640_ENABLED

fprintf(1,'Need to finish coding for Block 1008: MLX90640_ENABLED');


function data = OmniTrakFileRead_ReadBlock_MLX90640_I2C_CLOCKRATE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1504
%		MLX90640_I2C_CLOCKRATE

fprintf(1,'Need to finish coding for Block 1504: MLX90640_I2C_CLOCKRATE');


function data = OmniTrakFileRead_ReadBlock_MLX90640_I2C_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1520
%		MLX90640_I2C_TIME

fprintf(1,'Need to finish coding for Block 1520: MLX90640_I2C_TIME');


function data = OmniTrakFileRead_ReadBlock_MLX90640_IM_WRITE_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1522
%		MLX90640_IM_WRITE_TIME

fprintf(1,'Need to finish coding for Block 1522: MLX90640_IM_WRITE_TIME');


function data = OmniTrakFileRead_ReadBlock_MLX90640_INT_WRITE_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1523
%		MLX90640_INT_WRITE_TIME

fprintf(1,'Need to finish coding for Block 1523: MLX90640_INT_WRITE_TIME');


function data = OmniTrakFileRead_ReadBlock_MLX90640_PIXELS_IM(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1511
%		MLX90640_PIXELS_IM

fprintf(1,'Need to finish coding for Block 1511: MLX90640_PIXELS_IM');


function data = OmniTrakFileRead_ReadBlock_MLX90640_PIXELS_INT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1512
%		MLX90640_PIXELS_INT

fprintf(1,'Need to finish coding for Block 1512: MLX90640_PIXELS_INT');


function data = OmniTrakFileRead_ReadBlock_MLX90640_PIXELS_TO(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_MLX90640_REFRESH_RATE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1503
%		MLX90640_REFRESH_RATE

fprintf(1,'Need to finish coding for Block 1503: MLX90640_REFRESH_RATE');


function data = OmniTrakFileRead_ReadBlock_MODULE_CENTER_OFFSET(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2731
%		DEFINITION:		MODULE_CENTER_OFFSET
%		DESCRIPTION:	Center offset, in millimeters, for the specified OTMP module.
%
% fwrite(fid,ofbc.MODULE_CENTER_OFFSET,'uint16');
% fwrite(fid,1,'uint8');
% val = double(handles.ctrl.stap_get_center_offset())/1000;
% fwrite(fid,val,'single');
%

data = OmniTrakFileRead_Check_Field_Name(data,'module','center_offset');    %Call the subfunction to check for existing fieldnames.
module_i = fread(fid,1,'uint8');                                            %Read in the module index.
data.module(module_i).center_offset = fread(fid,1,'single');                %Read in the handle's center offset, in millimeters.


function data = OmniTrakFileRead_ReadBlock_MODULE_FW_DATE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	145
%		DEFINITION:		MODULE_FW_DATE
%		DESCRIPTION:	OTMP Module firmware upload date, copied from the macro, written as characters.

fprintf(1,'Need to finish coding for Block 145: MODULE_FW_DATE\n');


function data = OmniTrakFileRead_ReadBlock_MODULE_FW_FILENAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	144
%		DEFINITION:		MODULE_FW_FILENAME
%		DESCRIPTION:	OTMP Module firmware filename, copied from the macro, written as characters.

fprintf(1,'Need to finish coding for Block 144: MODULE_FW_FILENAME\n');


function data = OmniTrakFileRead_ReadBlock_MODULE_FW_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	146
%		DEFINITION:		MODULE_FW_TIME
%		DESCRIPTION:	OTMP Module firmware upload time, copied from the macro, written as characters.

fprintf(1,'Need to finish coding for Block 146: MODULE_FW_TIME\n');


function data = OmniTrakFileRead_ReadBlock_MODULE_MICROSTEP(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2722
%		DEFINITION:		MODULE_MICROSTEP
%		DESCRIPTION:	Microstep setting on the specified OTMP module.
%
% fwrite(fid,ofbc.MODULE_MICROSTEP,'uint16');
% fwrite(fid,1,'uint8');
% fwrite(fid,handles.ctrl.sttc_get_microstep(),'uint8');
%

data = OmniTrakFileRead_Check_Field_Name(data,'module','microstep');        %Call the subfunction to check for existing fieldnames.
module_i = fread(fid,1,'uint8');                                            %Read in the module index.
data.module(module_i).microstep = fread(fid,1,'uint8');                     %Read in the microstop setting.


function data = OmniTrakFileRead_ReadBlock_MODULE_PITCH_CIRC(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2730
%		DEFINITION:		MODULE_PITCH_CIRC
%		DESCRIPTION:	Pitch circumference, in millimeters, of the driving gear on the specified OTMP module.
%
% fwrite(fid,ofbc.MODULE_PITCH_CIRC,'uint16');
% fwrite(fid,1,'uint8');
% val = double(handles.ctrl.stap_get_pitch_circumference())/1000;
% fwrite(fid,val,'single');
%

data = OmniTrakFileRead_Check_Field_Name(data,'module',...
    'pitch_circumference');                                                 %Call the subfunction to check for existing fieldnames.
module_i = fread(fid,1,'uint8');                                            %Read in the module index.
data.module(module_i).pitch_circumference = fread(fid,1,'single');          %Read in the pitch circumference of the gear, in millimeters.


function data = OmniTrakFileRead_ReadBlock_MODULE_STEPS_PER_ROT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2723
%		DEFINITION:		MODULE_STEPS_PER_ROT
%		DESCRIPTION:	Steps per rotation on the specified OTMP module.
%
% fwrite(fid,ofbc.MODULE_STEPS_PER_ROT,'uint16');
% fwrite(fid,1,'uint8');
% fwrite(fid,handles.ctrl.sttc_get_steps_per_rot(),'uint16');
%

data = OmniTrakFileRead_Check_Field_Name(data,'module','steps_per_rot');    %Call the subfunction to check for existing fieldnames.
module_i = fread(fid,1,'uint8');                                            %Read in the module index.
data.module(module_i).steps_per_rot = fread(fid,1,'uint16');                %Read in the number of steps per rotation.


function data = OmniTrakFileRead_ReadBlock_MOTOTRAK_V3P0_OUTCOME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2500
%		DEFINITION:		MOTOTRAK_V3P0_OUTCOME
%		DESCRIPTION:	MotoTrak version 3.0 trial outcome data.
%

data = OmniTrakFileRead_Check_Field_Name(data,'trial');                     %Call the subfunction to check for existing fieldnames.
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


function data = OmniTrakFileRead_ReadBlock_MOTOTRAK_V3P0_SIGNAL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2501
%		MOTOTRAK_V3P0_SIGNAL

data = OmniTrakFileRead_Check_Field_Name(data,'trial');                     %Call the subfunction to check for existing fieldnames.
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


function data = OmniTrakFileRead_ReadBlock_MS_FILE_START(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2
%		MS_FILE_START

data = OmniTrakFileRead_Check_Field_Name(data,'file_start','ms');           %Call the subfunction to check for existing fieldnames.    
data.file_start.ms = fread(fid,1,'uint32');                                 %Save the file start 32-bit millisecond clock timestamp.


function data = OmniTrakFileRead_ReadBlock_MS_FILE_STOP(fid,data)

%	OmniTrak File Block Code (OFBC):
%		3
%		MS_FILE_STOP

data = OmniTrakFileRead_Check_Field_Name(data,'file_stop',[]);              %Call the subfunction to check for existing fieldnames.   
data.file_stop.ms = fread(fid,1,'uint32');                                  %Save the file stop 32-bit millisecond clock timestamp.


function data = OmniTrakFileRead_ReadBlock_MS_TIMER_ROLLOVER(fid,data)

%	OmniTrak File Block Code (OFBC):
%		23
%		MS_TIMER_ROLLOVER

fprintf(1,'Need to finish coding for Block 23: MS_TIMER_ROLLOVER');


function data = OmniTrakFileRead_ReadBlock_CLOCK_SYNC(fid,data)

%	OmniTrak File Block Code (OFBC):
%		22
%		CLOCK_SYNC

fprintf(1,'Need to finish coding for Block 22: CLOCK_SYNC');


function data = OmniTrakFileRead_ReadBlock_NTP_SYNC(fid,data)

%	OmniTrak File Block Code (OFBC):
%		20
%		NTP_SYNC

fprintf(1,'Need to finish coding for Block 20: NTP_SYNC');


function data = OmniTrakFileRead_ReadBlock_NTP_SYNC_FAIL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		21
%		NTP_SYNC_FAIL

fprintf(1,'Need to finish coding for Block 21: NTP_SYNC_FAIL');


function data = OmniTrakFileRead_ReadBlock_ORIGINAL_FILENAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		40
%		ORIGINAL_FILENAME

fprintf(1,'Need to finish coding for Block 40: ORIGINAL_FILENAME');


function data = OmniTrakFileRead_ReadBlock_OUTPUT_TRIGGER_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2600
%		OUTPUT_TRIGGER_NAME

fprintf(1,'Need to finish coding for Block 2600: OUTPUT_TRIGGER_NAME');


function data = OmniTrakFileRead_ReadBlock_PELLET_DISPENSE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2000
%		PELLET_DISPENSE

fprintf(1,'Need to finish coding for Block 2000: PELLET_DISPENSE');


function data = OmniTrakFileRead_ReadBlock_PELLET_FAILURE(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_POKE_BITMASK(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2560
%		DEFINITION:		POKE_BITMASK
%		DESCRIPTION:	Nosepoke status bitmask, typically written only when it changes.

ver = fread(fid,1,'uint8');                                                 %#ok<NASGU> %Data block version.

data = OmniTrakFileRead_Check_Field_Name(data,'poke',...
    {'datenum','micros','status'});                                         %Call the subfunction to check for existing fieldnames.         
j = size(data.poke.datenum,1) + 1;                                          %Find the next index for the pellet timestamp for this dispenser.
if isempty(data.poke.datenum)                                               %If the serial date number timestamp field is empty...
    data.poke.datenum = NaN;                                                %Initialize the field with a NaN.
end
data.poke.datenum(j,1) = fread(fid,1,'float64');                            %Save the serial date number timestamp.
if isempty(data.poke.micros)                                                %If the microcontroller microsecond timestamp field is empty...
    data.poke.micros = NaN;                                                 %Initialize the field with a NaN.
end
data.poke.micros(j,1) = fread(fid,1,'float32');                             %Save the microcontroller microsecond timestamp.
num_pokes = fread(fid,1,'uint8');                                           %Read in the number of nosepokes.
poke_mask = fread(fid,1,'uint8');                                           %Read in the nosepoke bitmask.
poke_status = zeros(1,num_pokes);                                           %Create a matrix to hold the nosepoke status.
for i = 1:num_pokes                                                         %Step through each nosepoke.
    poke_status(i) = bitget(poke_mask,i);                                   %Grab the status for each nosepoke.
end
if j == 1                                                                   %If this is the first nosepoke event...
    data.poke.status = poke_status;                                         %Create the status matrix.
else                                                                        %Otherwise...
    data.poke.status(j,:) = poke_status;                                    %Add the new status to the matrix.
end


function data = OmniTrakFileRead_ReadBlock_POSITION_MOVE_X(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2021
%		POSITION_MOVE_X

data = OmniTrakFileRead_Check_Field_Name(data,'pos','move');                %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the module index.
j = size(data.pos(i).move, 1) + 1;                                          %Find a new row index in the positioner movement matrix.
data.pos(i).move(j,:) = nan(1,4);                                           %Add 4 NaNs to a new row in the movement matrix.            
data.pos(i).move(j,1) = fread(fid,1,'uint32');                              %Save the millisecond clock timestamp for the movement.
data.pos(i).move(j,2) = fread(fid,1,'float32');                             %Save the new positioner x-value as a float32 value.     


function data = OmniTrakFileRead_ReadBlock_POSITION_MOVE_XY(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2023
%		POSITION_MOVE_XY

fprintf(1,'Need to finish coding for Block 2023: POSITION_MOVE_XY');


function data = OmniTrakFileRead_ReadBlock_POSITION_MOVE_XYZ(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2025
%		POSITION_MOVE_XYZ

fprintf(1,'Need to finish coding for Block 2025: POSITION_MOVE_XYZ');


function data = OmniTrakFileRead_ReadBlock_POSITION_START_X(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2020
%		POSITION_START_X

data = OmniTrakFileRead_Check_Field_Name(data,'pos','start');               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the module index.
data.pos(i).start = [fread(fid,1,'float32'), NaN, NaN];                     %Save the starting positioner x-value as a float32 value.   


function data = OmniTrakFileRead_ReadBlock_POSITION_START_XY(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2022
%		POSITION_START_XY

data = OmniTrakFileRead_Check_Field_Name(data,'pos','start');               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the module index.
data.pos(i).start = [fread(fid,2,'float32'), NaN];                          %Save the starting positioner x- and y-value as a float32 value.   


function data = OmniTrakFileRead_ReadBlock_POSITION_START_XYZ(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2024
%		POSITION_START_XYZ

fprintf(1,'Need to finish coding for Block 2024: POSITION_START_XYZ');


function data = OmniTrakFileRead_ReadBlock_PRIMARY_INPUT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		111
%		PRIMARY_INPUT

data = OmniTrakFileRead_Check_Field_Name(data,'input');                     %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.input(1).primary = fread(fid,N,'*char')';                              %Read in the characters of the primary module name.


function data = OmniTrakFileRead_ReadBlock_PRIMARY_MODULE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	110
%		DEFINITION:		PRIMARY_MODULE
%		DESCRIPTION:	Primary module name, for systems with interchangeable modules.
%
%   UPDATE LOG:
%   2024-01-19 - Drew Sloan - Added handling for old files in which the
%                             character count was written as a uint16.
%

data = OmniTrakFileRead_Check_Field_Name(data,'module');                    %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
temp_str = fread(fid,N,'*char')';                                           %Read in the characters of the primary module name.
if temp_str(1) == 0                                                         %If the first character is zero...
    fseek(fid,-(N+1),'cof');                                                %Rewind to the character count.
    N = fread(fid,1,'uint16');                                              %Read in the number of characters.
    temp_str = fread(fid,N,'*char')';                                       %Read in the characters of the primary module name.
end
data.module(1).name = temp_str;                                             %Save the primary module name.


function data = OmniTrakFileRead_ReadBlock_REMOTE_MANUAL_FEED(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_RENAMED_FILE(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_RTC_STRING(fid,data)

%	OmniTrak File Block Code (OFBC):
%		31
%		RTC_STRING

fprintf(1,'Need to finish coding for Block 31: RTC_STRING');


function data = OmniTrakFileRead_ReadBlock_RTC_STRING_DEPRECATED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		30
%		RTC_STRING_DEPRECATED

fprintf(1,'Need to finish coding for Block 30: RTC_STRING_DEPRECATED');


function data = OmniTrakFileRead_ReadBlock_RTC_VALUES(fid,data)

%	OmniTrak File Block Code (OFBC):
%		32
%		RTC_VALUES

data = OmniTrakFileRead_Check_Field_Name(data,'clock');                     %Call the subfunction to check for existing fieldnames.    
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


function data = OmniTrakFileRead_ReadBlock_SAMD_CHIP_ID(fid,data)

%	OmniTrak File Block Code (OFBC):
%		112
%		SAMD_CHIP_ID

data = OmniTrakFileRead_Check_Field_Name(data,'device','samd_chip_id');     %Call the subfunction to check for existing fieldnames.    
data.device.samd_chip_id = fread(fid,4,'uint32');                           %Save the 32-bit SAMD chip ID.


function data = OmniTrakFileRead_ReadBlock_SECONDARY_THRESH_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2310
%		SECONDARY_THRESH_NAME

fprintf(1,'Need to finish coding for Block 2310: SECONDARY_THRESH_NAME');


function data = OmniTrakFileRead_ReadBlock_SGP30_EC02(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_SGP30_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1005
%		SGP30_ENABLED

fprintf(1,'Need to finish coding for Block 1005: SGP30_ENABLED');


function data = OmniTrakFileRead_ReadBlock_SGP30_SN(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1400
%		SGP30_SN

fprintf(1,'Need to finish coding for Block 1400: SGP30_SN');


function data = OmniTrakFileRead_ReadBlock_SGP30_TVOC(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_SOFT_PAUSE_START(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2012
%		SOFT_PAUSE_START

fprintf(1,'Need to finish coding for Block 2012: SOFT_PAUSE_START');


function data = OmniTrakFileRead_ReadBlock_SPECTRO_TRACE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1901
%		SPECTRO_TRACE

data = OmniTrakFileRead_Check_Field_Name(data,'spectro','trace');           %Call the subfunction to check for existing fieldnames.
spectro_i = fread(fid,1,'uint8');                                           %Read in the spectrometer index.
t = numel(data.spectro(spectro_i).trace) + 1;                               %Find the next trace index.
data.spectro(spectro_i).trace(t).module = fread(fid,1,'uint8');             %Read in the module index.
data.spectro(spectro_i).trace(t).chan = fread(fid,1,'uint16');              %Read in the light source channel index.
data.spectro(spectro_i).trace(t).time = fread(fid,1,'float64');             %Read in the trace timestamp.
data.spectro(spectro_i).trace(t).intensity = fread(fid,1,'float32');        %Read in the light source intensity.
data.spectro(spectro_i).trace(t).position = fread(fid,1,'float32');         %Read in the light source position.
data.spectro(spectro_i).trace(t).integration = fread(fid,1,'float32');      %Read in the integration time.
data.spectro(spectro_i).trace(t).minus_background = fread(fid,1,'uint8');   %Read in the the background subtraction flag.
N = fread(fid,1,'uint32');                                                  %Read in the number of wavelengths tested by the spectrometer.
reps = fread(fid,1,'uint16');                                               %Read in the number of repetitions in the trace.
data.spectro(spectro_i).trace(t).data = nan(reps,N);                        %Pre-allocate a data field.
for i = 1:reps                                                              %Step through each repetition.
    data.spectro(spectro_i).trace(t).data(i,:) = fread(fid,N,'float64');    %Read in each repetition.
end


function data = OmniTrakFileRead_ReadBlock_SPECTRO_WAVELEN(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1900
%		SPECTRO_WAVELEN

data = OmniTrakFileRead_Check_Field_Name(data,'spectro','wavelengths');     %Call the subfunction to check for existing fieldnames.
spectro_i = fread(fid,1,'uint8');                                           %Read in the spectrometer index.
N = fread(fid,1,'uint32');                                                  %Read in the number of wavelengths tested by the spectrometer.
data.spectro(spectro_i).wavelengths = fread(fid,N,'float32')';              %Read in the characters of the light source model.


function data = OmniTrakFileRead_ReadBlock_STAGE_DESCRIPTION(fid,data)

%	OmniTrak File Block Code (OFBC):
%		401
%		STAGE_DESCRIPTION

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.stage_description = fread(fid,N,'*char')';                             %Read in the characters of the behavioral session stage description.


function data = OmniTrakFileRead_ReadBlock_STAGE_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		400
%		STAGE_NAME

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.stage_name = fread(fid,N,'*char')';                                    %Read in the characters of the behavioral session stage name.


function data = OmniTrakFileRead_ReadBlock_STAP_2AFC_TRIAL_OUTCOME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2740
%		DEFINITION:		STAP_2AFC_TRIAL_OUTCOME
%		DESCRIPTION:	SensiTrak proprioception discrimination task trial outcome data.

%   2022/03/16 - Drew Sloan - Function first created.
%

try
    spot = ftell(fid);
data = OmniTrakFileRead_Check_Field_Name(data,'trial');                     %Call the subfunction to check for existing fieldnames.
t = fread(fid,1,'uint16');                                                  %Trial index.
data.trial(t).start_time = fread(fid,1,'float64');                          %Trial start time (serial date number).
data.trial(t).start_millis = fread(fid,1,'uint32');                         %Trial start time (Arduino millisecond clock).
data.trial(t).outcome = fread(fid,1,'*char');                               %Character code for the outcome.
data.trial(t).visited_feeder = fread(fid,1,'*char');                        %Character code for the visited feeder.
N = fread(fid,1,'uint8');                                                   %Number of feedings.
data.trial(t).feed_time = fread(fid,N,'float64');                           %Feeding times.
data.trial(t).max_touch_dur = fread(fid,1,'float32');                       %Touch duration maximum limit.
data.trial(t).min_touch_dur = fread(fid,1,'float32');                       %Touch duration minimum limit.
data.trial(t).touch_dur = fread(fid,1,'float32');                           %Read in the actual touch duration.
data.trial(t).choice_time = fread(fid,1,'float32');                         %Feeder choice time limit.
data.trial(t).response_time = fread(fid,1,'float32');                       %Feeder response time.

data.trial(t).movement_start = fread(fid,1,'uint32');                       %Movement start time (Arduino millisecond clock).
N = fread(fid,1,'uint8');                                                   %Number of characters in the excursion type.
data.trial(t).excursion_type = fread(fid,N,'*char')';                       %Excursion type.
if data.trial(t).excursion_type(1) == 'C'
    fseek(fid,-(N + 5),'cof');
    N = fread(fid,1,'uint8');                                                   %Number of characters in the excursion type.
    data.trial(t).excursion_type = fread(fid,N,'*char')';                       %Excursion type.
    data.trial(t).movement_start = NaN;
end
data.trial(t).amplitude = fread(fid,1,'float32');                           %Excursion amplitude, in millimeters.
data.trial(t).speed = fread(fid,1,'float32');                               %Excursion speed, in millimeters/second.

num_signals = fread(fid,1,'uint8');                                         %Number of data signals (besides the timestamp).
N = fread(fid,1,'uint32');                                                  %Number of samples in each stream.
data.trial(t).times = fread(fid,N,'uint32');                                %Read in the millisecond clock timestampes.
data.trial(t).signal = nan(N,num_signals);                                  %Create a matrix to hold the sensor signals.
for i = 1:num_signals                                                       %Step through the signals.
    data.trial(t).signal(:,i) = fread(fid,N,'float32');                     %Read in each signal.
end
catch
    disp(spot);
end


function data = OmniTrakFileRead_ReadBlock_STOP_TASK_TRIAL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2801
%		DEFINITION:		STOP_TASK_TRIAL
%		DESCRIPTION:	Stop task trial data.

fprintf(1,'Need to finish coding for Block 2801: STOP_TASK_TRIAL\n');


function data = OmniTrakFileRead_ReadBlock_STREAM_INPUT_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2100
%		STREAM_INPUT_NAME

fprintf(1,'Need to finish coding for Block 2100: STREAM_INPUT_NAME');


function data = OmniTrakFileRead_ReadBlock_STTC_2AFC_TRIAL_OUTCOME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2720
%		DEFINITION:		STTC_2AFC_TRIAL_OUTCOME
%		DESCRIPTION:	SensiTrak tactile discrimination task trial outcome data.
%
%   2022/03/16 - Drew Sloan - Function first created.
%

data = OmniTrakFileRead_Check_Field_Name(data,'trial');                     %Call the subfunction to check for existing fieldnames.
t = fread(fid,1,'uint16');                                                  %Trial index.
data.trial(t).start_time = fread(fid,1,'float64');                          %Trial start time (serial date number).
data.trial(t).start_millis = fread(fid,1,'uint32');                         %Trial start time (Arduino millisecond clock).
data.trial(t).outcome = fread(fid,1,'*char');                               %Character code for the outcome.
data.trial(t).visited_feeder = fread(fid,1,'*char');                        %Character code for the visited feeder.
N = fread(fid,1,'uint8');                                                   %Number of feedings.
data.trial(t).feed_time = fread(fid,N,'float64');                           %Feeding times.
data.trial(t).max_touch_dur = fread(fid,1,'float32');                       %Touch duration maximum limit.
data.trial(t).min_touch_dur = fread(fid,1,'float32');                       %Touch duration minimum limit.
data.trial(t).touch_dur = fread(fid,1,'float32');                           %Read in the actual touch duration.
data.trial(t).choice_time = fread(fid,1,'float32');                         %Feeder choice time limit.
data.trial(t).response_time = fread(fid,1,'float32');                       %Feeder response time.

data.trial(t).pad_index = fread(fid,1,'uint8');                             %Texture pad index.
N = fread(fid,1,'uint8');                                                   %Number of characters in the pad label.
data.trial(t).pad_label = fread(fid,N,'*char')';                            %Texture pad label.

num_signals = fread(fid,1,'uint8');                                         %Number of data signals (besides the timestamp).
N = fread(fid,1,'uint32');                                                  %Number of samples in each stream.
data.trial(t).times = fread(fid,N,'uint32');                                %Read in the millisecond clock timestampes.
data.trial(t).signal = nan(N,num_signals);                                  %Create a matrix to hold the sensor signals.
for i = 1:num_signals                                                       %Step through the signals.
    data.trial(t).signal(:,i) = fread(fid,N,'float32');                     %Read in each signal.
end


function data = OmniTrakFileRead_ReadBlock_STTC_NUM_PADS(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2721
%		DEFINITION:		STTC_NUM_PADS
%		DESCRIPTION:	Number of pads on the SensiTrak Tactile Carousel module.
%
% fwrite(fid,ofbc.STTC_NUM_PADS,'uint16');
% fwrite(fid,1,'uint8');
% fwrite(fid,handles.ctrl.sttc_get_num_pads(),'uint8');

data = OmniTrakFileRead_Check_Field_Name(data,'module','num_pads');         %Call the subfunction to check for existing fieldnames.
module_i = fread(fid,1,'uint8');                                            %Read in the module index.
data.module(module_i).num_pads = fread(fid,1,'uint8');                      %Read in the number of texture pads.
if data.module(module_i).num_pads > 10                                      %If there's more than 10 texture pads.
    temp = 0;                                                               %Create a variable to hold the block code.
    while (temp ~= 2722) && ~feof(fid)                                      %Loop until we find the next expected block code.        
        fseek(fid,-1,'cof');                                                %Rewind one byte.
        temp = fread(fid,1,'uint16');                                       %Read in an unsigned 16-bit integer.
%         fprintf(1,'ftell(fid) = %1.0f, temp = %1.0f\n',ftell(fid),temp);
    end
    fseek(fid,-3,'cof');                                                    %Rewind 3 bytes.
    data.module(module_i).num_pads = fread(fid,1,'uint8');                  %Read in the number of texture pads.
end


function data = OmniTrakFileRead_ReadBlock_SUBJECT_DEPRECATED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		4
%		SUBJECT_DEPRECATED

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.subject = fread(fid,N,'*char')';                                       %Read in the characters of the subject's name.


function data = OmniTrakFileRead_ReadBlock_SUBJECT_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		200
%		SUBJECT_NAME

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.subject = fread(fid,N,'*char')';                                       %Read in the characters of the subject's name.


function data = OmniTrakFileRead_ReadBlock_SWUI_MANUAL_FEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2405
%		SWUI_MANUAL_FEED

data = OmniTrakFileRead_Check_Field_Name(data,'feed',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.
if length(data.feed) < i                                                    %If the structure doesn't yet have this dispenser index...
    for j = (length(data.feed)+1):i                                         %Step through each missing index.
        data.feed(i) = struct('time',[],'num',[],'source',[]);              %Add new indices to the structure.
    end 
end
j = size(data.feed(i).time,1) + 1;                                          %Find the next index for the feed timestamp for this dispenser.
if j == 1                                                                   %If this is the first manual feeding...
    data.feed(i).time = fread(fid,1,'float64');                             %Save the millisecond clock timestamp.
    data.feed(i).num = fread(fid,1,'uint16');                               %Save the number of feedings.
    data.feed(i).source = {'manual_software'};                              %Save the feed trigger source.  
else                                                                        %Otherwise, if this isn't the first manual feeding...
    data.feed(i).time(j,1) = fread(fid,1,'float64');                        %Save the millisecond clock timestamp.
    data.feed(i).num(j,1) = fread(fid,1,'uint16');                          %Save the number of feedings.
    data.feed(i).source{j,1} = 'manual_software';                           %Save the feed trigger source.
end


function data = OmniTrakFileRead_ReadBlock_SWUI_MANUAL_FEED_DEPRECATED(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_SW_OPERANT_FEED(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_SW_RANDOM_FEED(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_SYSTEM_FW_VER(fid,data)

%	OmniTrak File Block Code (OFBC):
%		103
%		SYSTEM_FW_VER

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device.fw_version = char(fread(fid,N,'uchar')');                       %Read in the firmware version.


function data = OmniTrakFileRead_ReadBlock_SYSTEM_HW_VER(fid,data)

%	OmniTrak File Block Code (OFBC):
%		102
%		SYSTEM_HW_VER

data = OmniTrakFileRead_Check_Field_Name(data,'device');                    %Call the subfunction to check for existing fieldnames.    
data.device.hw_version = fread(fid,1,'float32');                            %Save the device hardware version.


function data = OmniTrakFileRead_ReadBlock_SYSTEM_MFR(fid,data)

%	OmniTrak File Block Code (OFBC):
%		105
%		SYSTEM_MFR

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field.
    data.device = [];                                                       %Create the field.
end
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device.manufacturer = char(fread(fid,N,'uchar')');                     %Read in the manufacturer.


function data = OmniTrakFileRead_ReadBlock_SYSTEM_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		101
%		SYSTEM_NAME

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field.
    data.device = [];                                                       %Create the field.
end
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device.system_name = fread(fid,N,'*char')';                            %Read in the characters of the system name.


function data = OmniTrakFileRead_ReadBlock_SYSTEM_SN(fid,data)

%	OmniTrak File Block Code (OFBC):
%		104
%		SYSTEM_SN

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field.
    data.device = [];                                                       %Create the field.
end
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device.serial_num = char(fread(fid,N,'uchar')');                       %Read in the serial number.


function data = OmniTrakFileRead_ReadBlock_SYSTEM_TYPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		100
%		SYSTEM_TYPE

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field.
    data.device = [];                                                       %Create the field.
end
data.device.type = fread(fid,1,'uint8');                                    %Save the device type value.


function data = OmniTrakFileRead_ReadBlock_TASK_TYPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		301
%		TASK_TYPE

data = OmniTrakFileRead_Check_Field_Name(data,'task');                    %Call the subfunction to check for existing fieldnames.                
N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.task(1).type = fread(fid,N,'*char')';                                  %Read in the characters of the user's task type.


function data = OmniTrakFileRead_ReadBlock_TIME_ZONE_OFFSET(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	25
%		DEFINITION:		TIME_ZONE_OFFSET
%		DESCRIPTION:	Computer clock time zone offset from UTC.       
%
% fwrite(fid,ofbc.TIME_ZONE_OFFSET,'uint16');                          
% dt = datenum(datetime('now','TimeZone','local')) - ...
%     datenum(datetime('now','TimeZone','UTC'));                         
% fwrite(fid,dt,'float64');    

data = OmniTrakFileRead_Check_Field_Name(data,'clock');                     %Call the subfunction to check for existing fieldnames.
data.clock(1).time_zone = fread(fid,1,'float64');                           %Read in the time zone adjustment relative to UTC.


function data = OmniTrakFileRead_ReadBlock_TIME_ZONE_OFFSET_HHMM(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	26
%		DEFINITION:		TIME_ZONE_OFFSET_HHMM
%		DESCRIPTION:	Computer clock time zone offset from UTC as two integers, one for hours, and the other for minutes


data = OmniTrakFileRead_Check_Field_Name(data,'clock');                     %Call the subfunction to check for existing fieldnames.    
i = length(data.clock) + 1;                                                 %Find the next available index for a new real-time clock synchronization.
hr = fread(fid,1,'int8');                                                   %Read in the hour of the time zone offset.
min = fread(fid,1,'uint8');                                                 %Read in the minutes of the time zone offset.
if hr < 0                                                                   %If the time zone offset is less than one.
    data.clock(i).time_zone = double(hr) - double(min)/60;                  %Save the time zone offset in fractional hours.
else                                                                        %Otherwise...
    data.clock(i).time_zone = double(hr) + double(min)/60;                  %Save the time zone offset in fractional hours.
end


function data = OmniTrakFileRead_ReadBlock_TRIAL_START_SERIAL_DATE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2014
%		DEFINITION:		TRIAL_START_SERIAL_DATE
%		DESCRIPTION:	Timestamped event marker for the start of a trial, with accompanying microsecond clock reading

data = OmniTrakFileRead_Check_Field_Name(data,'trial','start','datenum');   %Call the subfunction to check for existing fieldnames.

timestamp = fread(fid,1,'float64');                                         %Read in the serial date number timestamp.
t = fread(fid,1,'uint16');                                                  %Read in the trial index.
data.trial(t).start.datenum = timestamp;                                    %Save the serial date number timestamp for the trial.


function data = OmniTrakFileRead_ReadBlock_TTL_PULSE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2048
%		DEFINITION:		TTL_PULSE
%		DESCRIPTION:	Timestamped event for a TTL pulse output, with channel number, voltage, and duration.

data = OmniTrakFileRead_Check_Field_Name(data,'ttl');                       %Call the subfunction to check for existing fieldnames.

ver = fread(fid,1,'uint8');                                                 %Read in the AMBULATION_XY_THETA data block version.

switch ver                                                                  %Switch between the different data block versions.

    case 1                                                                  %Version 1.
        i = length(data.ttl) + 1;                                           %Increment the TTL pulse index.
        data.ttl(i).datenum = fread(fid,1,'float64');                       %Serial date number.
        data.ttl(i).chan = fread(fid,1,'uint8')';                           %Output channel.
        data.ttl(i).volts = fread(fid,1,'float32')';                        %Output voltage.
        data.ttl(i).dur = fread(fid,1,'uint32');                            %Pulse duration, in milliseconds.

    otherwise                                                               %Unrecognized data block version.
        error(['ERROR IN %s: Data block version #%1.0f is not '...
            'recognized!'], upper(mfilename), ver);                         %Show an error.
        
end


function data = OmniTrakFileRead_ReadBlock_USER_SYSTEM_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		130
%		USER_SYSTEM_NAME

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
if N < 255                                                                  %If there's less than 255 characters in the system name.
    data.device.user_system_name = fread(fid,N,'*char')';                   %Read in the characters of the system name.
else                                                                        %Otherwise...
    data.device.user_system_name = 'USER_SYSTEM_NAME_ERROR';                %Show that there was an error in the system name.
    temp = 'xxx';                                                           %Create a temporary string for comparison.
    while ~strcmpi(temp,'COM')                                              %Loop until we find the characters "COM"...
        fseek(fid,-2,'cof');                                                %Rewind 2 bytes.
        temp = fread(fid,3,'*char')';                                       %Read in the characters of the system name.
    end
    fseek(fid,-6,'cof');                                                    %Rewind 5 bytes.
end


function data = OmniTrakFileRead_ReadBlock_USER_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		60
%		USER_TIME

data = OmniTrakFileRead_Check_Field_Name(data,'clock');                     %Call the subfunction to check for existing fieldnames.    
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


function data = OmniTrakFileRead_ReadBlock_US_TIMER_ROLLOVER(fid,data)

%	OmniTrak File Block Code (OFBC):
%		24
%		US_TIMER_ROLLOVER

fprintf(1,'Need to finish coding for Block 24: US_TIMER_ROLLOVER');


function data = OmniTrakFileRead_ReadBlock_VIBRATION_TASK_TRIAL_OUTCOME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2700
%		VIBRATION_TASK_TRIAL_OUTCOME

data = OmniTrakFileRead_Check_Field_Name(data,'trial');                     %Call the subfunction to check for existing fieldnames.
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


function data = OmniTrakFileRead_ReadBlock_VIBROTACTILE_DETECTION_TASK_TRIAL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2701
%		DEFINITION:		VIBROTACTILE_DETECTION_TASK_TRIAL
%		DESCRIPTION:	Vibrotactile detection task trial data.

fprintf(1,'Need to finish coding for Block 2701: VIBROTACTILE_DETECTION_TASK_TRIAL\n');


function data = OmniTrakFileRead_ReadBlock_VL53L0X_DIST(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_VL53L0X_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1006
%		VL53L0X_ENABLED

fprintf(1,'Need to finish coding for Block 1006: VL53L0X_ENABLED');


function data = OmniTrakFileRead_ReadBlock_VL53L0X_FAIL(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_WINC1500_IP4_ADDR(fid,data)

%	OmniTrak File Block Code (OFBC):
%		151
%		WINC1500_IP4_ADDR

fprintf(1,'Need to finish coding for Block 151: WINC1500_IP4_ADDR');


function data = OmniTrakFileRead_ReadBlock_WINC1500_MAC_ADDR(fid,data)

%	OmniTrak File Block Code (OFBC):
%		150
%		WINC1500_MAC_ADDR

data = OmniTrakFileRead_Check_Field_Name(data,'device');                    %Call the subfunction to check for existing fieldnames.
data.device.mac_addr = fread(fid,6,'uint8');                                %Save the device MAC address.


function data = OmniTrakFileRead_ReadBlock_ZMOD4410_CONFIG_PARAMS(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1701
%		ZMOD4410_CONFIG_PARAMS

fprintf(1,'Need to finish coding for Block 1701: ZMOD4410_CONFIG_PARAMS');


function data = OmniTrakFileRead_ReadBlock_ZMOD4410_ECO2(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1710
%		ZMOD4410_ECO2

fprintf(1,'Need to finish coding for Block 1710: ZMOD4410_ECO2');


function data = OmniTrakFileRead_ReadBlock_ZMOD4410_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1009
%		ZMOD4410_ENABLED

fprintf(1,'Need to finish coding for Block 1009: ZMOD4410_ENABLED');


function data = OmniTrakFileRead_ReadBlock_ZMOD4410_ERROR(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1702
%		ZMOD4410_ERROR

fprintf(1,'Need to finish coding for Block 1702: ZMOD4410_ERROR');


function data = OmniTrakFileRead_ReadBlock_ZMOD4410_IAQ(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1711
%		ZMOD4410_IAQ

fprintf(1,'Need to finish coding for Block 1711: ZMOD4410_IAQ');


function data = OmniTrakFileRead_ReadBlock_ZMOD4410_MOX_BOUND(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1700
%		ZMOD4410_MOX_BOUND

fprintf(1,'Need to finish coding for Block 1700: ZMOD4410_MOX_BOUND');


function data = OmniTrakFileRead_ReadBlock_ZMOD4410_READING_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1703
%		ZMOD4410_READING_FL

fprintf(1,'Need to finish coding for Block 1703: ZMOD4410_READING_FL');


function data = OmniTrakFileRead_ReadBlock_ZMOD4410_READING_INT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1704
%		ZMOD4410_READING_INT

data = OmniTrakFileRead_Check_Field_Name(data,'gas_adc');                   %Call the subfunction to check for existing fieldnames.
i = length(data.gas_adc) + 1;                                               %Grab a new TVOC reading index.
data.gas_adc(i).src = 'ZMOD4410';                                           %Save the source of the TVOC reading.
data.gas_adc(i).id = fread(fid,1,'uint8');                                  %Read in the SGP30 sensor index (there may be multiple sensors).
data.gas_adc(i).time = fread(fid,1,'uint32');                               %Save the millisecond clock timestamp for the reading.
data.gas_adc(i).int = fread(fid,1,'uint16');                                %Save the TVOC reading as an unsigned 16-bit value.


function data = OmniTrakFileRead_ReadBlock_ZMOD4410_R_CDA(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1713
%		ZMOD4410_R_CDA

fprintf(1,'Need to finish coding for Block 1713: ZMOD4410_R_CDA');


function data = OmniTrakFileRead_ReadBlock_ZMOD4410_TVOC(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1712
%		ZMOD4410_TVOC

fprintf(1,'Need to finish coding for Block 1712: ZMOD4410_TVOC');


function data = OmniTrakFileRead_Unrecognized_Block(fid, data)

fseek(fid,-2,'cof');                                                        %Rewind 2 bytes.
data.unrecognized_block = [];                                               %Create an unrecognized block field.
data.unrecognized_block.pos = ftell(fid);                                   %Save the file position.
data.unrecognized_block.code = fread(fid,1,'uint16');                       %Read in the data block code.


function waitbar = big_waitbar(varargin)

figsize = [2,16];                                                           %Set the default figure size, in centimeters.
barcolor = 'b';                                                             %Set the default waitbar color.
titlestr = 'Waiting...';                                                    %Set the default waitbar title.
txtstr = 'Waiting...';                                                      %Set the default waitbar string.
val = 0;                                                                    %Set the default value of the waitbar to zero.

str = {'FigureSize','Color','Title','String','Value'};                      %List the allowable parameter names.
for i = 1:2:length(varargin)                                                %Step through any optional input arguments.
    if ~ischar(varargin{i}) || ~any(strcmpi(varargin{i},str))               %If the first optional input argument isn't one of the expected property names...
        beep;                                                               %Play the Matlab warning noise.
        cprintf('red','%s\n',['ERROR IN BIG_WAITBAR: Property '...
            'name not recognized! Optional input properties are:']);        %Show an error.
        for j = 1:length(str)                                               %Step through each allowable parameter name.
            cprintf('red','\t%s\n',str{j});                                 %List each parameter name in the command window, in red.
        end
        return                                                              %Skip execution of the rest of the function.
    else                                                                    %Otherwise...
        if strcmpi(varargin{i},'FigureSize')                                %If the optional input property is "FigureSize"...
            figsize = varargin{i+1};                                        %Set the figure size to that specified, in centimeters.            
        elseif strcmpi(varargin{i},'Color')                                 %If the optional input property is "Color"...
            barcolor = varargin{i+1};                                       %Set the waitbar color the specified color.
        elseif strcmpi(varargin{i},'Title')                                 %If the optional input property is "Title"...
            titlestr = varargin{i+1};                                       %Set the waitbar figure title to the specified string.
        elseif strcmpi(varargin{i},'String')                                %If the optional input property is "String"...
            txtstr = varargin{i+1};                                         %Set the waitbar text to the specified string.
        elseif strcmpi(varargin{i},'Value')                                 %If the optional input property is "Value"...
            val = varargin{i+1};                                            %Set the waitbar value to the specified value.
        end
    end    
end

orig_units = get(0,'units');                                                %Grab the current system units.
set(0,'units','centimeters');                                               %Set the system units to centimeters.
pos = get(0,'Screensize');                                                  %Grab the screensize.
h = figsize(1);                                                             %Set the height of the figure.
w = figsize(2);                                                             %Set the width of the figure.
fig = figure('numbertitle','off',...
    'name',titlestr,...
    'units','centimeters',...
    'Position',[pos(3)/2-w/2, pos(4)/2-h/2, w, h],...
    'menubar','none',...
    'resize','off');                                                        %Create a figure centered in the screen.
ax = axes('units','centimeters',...
    'position',[0.25,0.25,w-0.5,h/2-0.3],...
    'parent',fig);                                                          %Create axes for showing loading progress.
if val > 1                                                                  %If the specified value is greater than 1...
    val = 1;                                                                %Set the value to 1.
elseif val < 0                                                              %If the specified value is less than 0...
    val = 0;                                                                %Set the value to 0.
end    
obj = fill(val*[0 1 1 0 0],[0 0 1 1 0],barcolor,'edgecolor','k');           %Create a fill object to show loading progress.
set(ax,'xtick',[],'ytick',[],'box','on','xlim',[0,1],'ylim',[0,1]);         %Set the axis limits and ticks.
txt = uicontrol(fig,'style','text','units','centimeters',...
    'position',[0.25,h/2+0.05,w-0.5,h/2-0.3],'fontsize',10,...
    'horizontalalignment','left','backgroundcolor',get(fig,'color'),...
    'string',txtstr);                                                       %Create a text object to show the current point in the wait process.  
set(0,'units',orig_units);                                                  %Set the system units back to the original units.

waitbar.type = 'big_waitbar';                                               %Set the structure type.
waitbar.title = @(str)SetTitle(fig,str);                                    %Set the function for changing the waitbar title.
waitbar.string = @(str)SetString(fig,txt,str);                              %Set the function for changing the waitbar string.
% waitbar.value = @(val)SetVal(fig,obj,val);                                  %Set the function for changing waitbar value.
waitbar.value = @(varargin)GetSetVal(fig,obj,varargin{:});                  %Set the function for reading/setting the waitbar value.
waitbar.color = @(val)SetColor(fig,obj,val);                                %Set the function for changing waitbar color.
waitbar.close = @()CloseWaitbar(fig);                                       %Set the function for closing the waitbar.
waitbar.isclosed = @()WaitbarIsClosed(fig);                                 %Set the function for checking whether the waitbar figure is closed.

drawnow;                                                                    %Immediately show the waitbar.


%% This function sets the name/title of the waitbar figure.
function SetTitle(fig,str)
if ishandle(fig)                                                            %If the waitbar figure is still open...
    set(fig,'name',str);                                                    %Set the figure name to the specified string.
    drawnow;                                                                %Immediately update the figure.
else                                                                        %Otherwise...
    warning('Cannot update the waitbar figure. It has been closed.');       %Show a warning.
end


%% This function sets the string on the waitbar figure.
function SetString(fig,txt,str)
if ishandle(fig)                                                            %If the waitbar figure is still open...
    set(txt,'string',str);                                                  %Set the string in the text object to the specified string.
    drawnow;                                                                %Immediately update the figure.
else                                                                        %Otherwise...
    warning('Cannot update the waitbar figure. It has been closed.');       %Show a warning.
end


% %% This function sets the current value of the waitbar.
% function SetVal(fig,obj,val)
% if ishandle(fig)                                                            %If the waitbar figure is still open...
%     if val > 1                                                              %If the specified value is greater than 1...
%         val = 1;                                                            %Set the value to 1.
%     elseif val < 0                                                          %If the specified value is less than 0...
%         val = 0;                                                            %Set the value to 0.
%     end
%     set(obj,'xdata',val*[0 1 1 0 0]);                                       %Set the patch object to extend to the specified value.
%     drawnow;                                                                %Immediately update the figure.
% else                                                                        %Otherwise...
%     warning('Cannot update the waitbar figure. It has been closed.');       %Show a warning.
% end


%% This function reads/sets the waitbar value.
function val = GetSetVal(fig,obj,varargin)
if ishandle(fig)                                                            %If the waitbar figure is still open...
    if nargin > 2                                                           %If a value was passed.
        val = varargin{1};                                                  %Grab the specified value.
        if val > 1                                                          %If the specified value is greater than 1...
            val = 1;                                                        %Set the value to 1.
        elseif val < 0                                                      %If the specified value is less than 0...
            val = 0;                                                        %Set the value to 0.
        end
        set(obj,'xdata',val*[0 1 1 0 0]);                                   %Set the patch object to extend to the specified value.
        drawnow;                                                            %Immediately update the figure.
    else                                                                    %Otherwise...
        val = get(obj,'xdata');                                             %Grab the x-coordinates from the patch object.
        val = val(2);                                                       %Return the right-hand x-coordinate.
    end
else                                                                        %Otherwise...
    warning('Cannot access the waitbar figure. It has been closed.');       %Show a warning.
end
    


%% This function sets the color of the waitbar.
function SetColor(fig,obj,val)
if ishandle(fig)                                                            %If the waitbar figure is still open...
    set(obj,'facecolor',val);                                               %Set the patch object to have the specified facecolor.
    drawnow;                                                                %Immediately update the figure.
else                                                                        %Otherwise...
    warning('Cannot update the waitbar figure. It has been closed.');       %Show a warning.
end


%% This function closes the waitbar figure.
function CloseWaitbar(fig)
if ishandle(fig)                                                            %If the waitbar figure is still open...
    close(fig);                                                             %Close the waitbar figure.
    drawnow;                                                                %Immediately update the figure to allow it to close.
end


%% This function returns a logical value indicate whether the waitbar figure has been closed.
function isclosed = WaitbarIsClosed(fig)
isclosed = ~ishandle(fig);                                                  %Check to see if the figure handle is still a valid handle.


function count = cprintf(style,format,varargin)
% CPRINTF displays styled formatted text in the Command Window
%
% Syntax:
%    count = cprintf(style,format,...)
%
% Description:
%    CPRINTF processes the specified text using the exact same FORMAT
%    arguments accepted by the built-in SPRINTF and FPRINTF functions.
%
%    CPRINTF then displays the text in the Command Window using the
%    specified STYLE argument. The accepted styles are those used for
%    Matlab's syntax highlighting (see: File / Preferences / Colors / 
%    M-file Syntax Highlighting Colors), and also user-defined colors.
%
%    The possible pre-defined STYLE names are:
%
%       'Text'                 - default: black
%       'Keywords'             - default: blue
%       'Comments'             - default: green
%       'Strings'              - default: purple
%       'UnterminatedStrings'  - default: dark red
%       'SystemCommands'       - default: orange
%       'Errors'               - default: light red
%       'Hyperlinks'           - default: underlined blue
%
%       'Black','Cyan','Magenta','Blue','Green','Red','Yellow','White'
%
%    STYLE beginning with '-' or '_' will be underlined. For example:
%          '-Blue' is underlined blue, like 'Hyperlinks';
%          '_Comments' is underlined green etc.
%
%    STYLE beginning with '*' will be bold (R2011b+ only). For example:
%          '*Blue' is bold blue;
%          '*Comments' is bold green etc.
%    Note: Matlab does not currently support both bold and underline,
%          only one of them can be used in a single cprintf command. But of
%          course bold and underline can be mixed by using separate commands.
%
%    STYLE also accepts a regular Matlab RGB vector, that can be underlined
%    and bolded: -[0,1,1] means underlined cyan, '*[1,0,0]' is bold red.
%
%    STYLE is case-insensitive and accepts unique partial strings just
%    like handle property names.
%
%    CPRINTF by itself, without any input parameters, displays a demo
%
% Example:
%    cprintf;   % displays the demo
%    cprintf('text',   'regular black text');
%    cprintf('hyper',  'followed %s','by');
%    cprintf('key',    '%d colored', 4);
%    cprintf('-comment','& underlined');
%    cprintf('err',    'elements\n');
%    cprintf('cyan',   'cyan');
%    cprintf('_green', 'underlined green');
%    cprintf(-[1,0,1], 'underlined magenta');
%    cprintf([1,0.5,0],'and multi-\nline orange\n');
%    cprintf('*blue',  'and *bold* (R2011b+ only)\n');
%    cprintf('string');  % same as fprintf('string') and cprintf('text','string')
%
% Bugs and suggestions:
%    Please send to Yair Altman (altmany at gmail dot com)
%
% Warning:
%    This code heavily relies on undocumented and unsupported Matlab
%    functionality. It works on Matlab 7+, but use at your own risk!
%
%    A technical description of the implementation can be found at:
%    <a href="http://undocumentedmatlab.com/blog/cprintf/">http://UndocumentedMatlab.com/blog/cprintf/</a>
%
% Limitations:
%    1. In R2011a and earlier, a single space char is inserted at the
%       beginning of each CPRINTF text segment (this is ok in R2011b+).
%
%    2. In R2011a and earlier, consecutive differently-colored multi-line
%       CPRINTFs sometimes display incorrectly on the bottom line.
%       As far as I could tell this is due to a Matlab bug. Examples:
%         >> cprintf('-str','under\nline'); cprintf('err','red\n'); % hidden 'red', unhidden '_'
%         >> cprintf('str','regu\nlar'); cprintf('err','red\n'); % underline red (not purple) 'lar'
%
%    3. Sometimes, non newline ('\n')-terminated segments display unstyled
%       (black) when the command prompt chevron ('>>') regains focus on the
%       continuation of that line (I can't pinpoint when this happens). 
%       To fix this, simply newline-terminate all command-prompt messages.
%
%    4. In R2011b and later, the above errors appear to be fixed. However,
%       the last character of an underlined segment is not underlined for
%       some unknown reason (add an extra space character to make it look better)
%
%    5. In old Matlab versions (e.g., Matlab 7.1 R14), multi-line styles
%       only affect the first line. Single-line styles work as expected.
%       R14 also appends a single space after underlined segments.
%
%    6. Bold style is only supported on R2011b+, and cannot also be underlined.
%
% Change log:
%    2012-08-09: Graceful degradation support for deployed (compiled) and non-desktop applications; minor bug fixes
%    2012-08-06: Fixes for R2012b; added bold style; accept RGB string (non-numeric) style
%    2011-11-27: Fixes for R2011b
%    2011-08-29: Fix by Danilo (FEX comment) for non-default text colors
%    2011-03-04: Performance improvement
%    2010-06-27: Fix for R2010a/b; fixed edge case reported by Sharron; CPRINTF with no args runs the demo
%    2009-09-28: Fixed edge-case problem reported by Swagat K
%    2009-05-28: corrected nargout behavior sugegsted by Andreas Gäb
%    2009-05-13: First version posted on <a href="http://www.mathworks.com/matlabcentral/fileexchange/authors/27420">MathWorks File Exchange</a>
%
% See also:
%    sprintf, fprintf

% License to use and modify this code is granted freely to all interested, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.

% Programmed and Copyright by Yair M. Altman: altmany(at)gmail.com
% $Revision: 1.08 $  $Date: 2012/10/17 21:41:09 $

  persistent majorVersion minorVersion
  if isempty(majorVersion)
      %v = version; if str2double(v(1:3)) <= 7.1
      %majorVersion = str2double(regexprep(version,'^(\d+).*','$1'));
      %minorVersion = str2double(regexprep(version,'^\d+\.(\d+).*','$1'));
      %[a,b,c,d,versionIdStrs]=regexp(version,'^(\d+)\.(\d+).*');  %#ok unused
      v = sscanf(version, '%d.', 2);
      majorVersion = v(1); %str2double(versionIdStrs{1}{1});
      minorVersion = v(2); %str2double(versionIdStrs{1}{2});
  end

  % The following is for debug use only:
  %global docElement txt el
  if ~exist('el','var') || isempty(el),  el=handle([]);  end  %#ok mlint short-circuit error ("used before defined")
  if nargin<1, showDemo(majorVersion,minorVersion); return;  end
  if isempty(style),  return;  end
  if all(ishandle(style)) && length(style)~=3
      dumpElement(style);
      return;
  end

  % Process the text string
  if nargin<2, format = style; style='text';  end
  %error(nargchk(2, inf, nargin, 'struct'));
  %str = sprintf(format,varargin{:});

  % In compiled mode
  try useDesktop = usejava('desktop'); catch, useDesktop = false; end
  if isdeployed | ~useDesktop %#ok<OR2> - for Matlab 6 compatibility
      % do not display any formatting - use simple fprintf()
      % See: http://undocumentedmatlab.com/blog/bold-color-text-in-the-command-window/#comment-103035
      % Also see: https://mail.google.com/mail/u/0/?ui=2&shva=1#all/1390a26e7ef4aa4d
      % Also see: https://mail.google.com/mail/u/0/?ui=2&shva=1#all/13a6ed3223333b21
      count1 = fprintf(format,varargin{:});
  else
      % Else (Matlab desktop mode)
      % Get the normalized style name and underlining flag
      [underlineFlag, boldFlag, style] = processStyleInfo(style);

      % Set hyperlinking, if so requested
      if underlineFlag
          format = ['<a href="">' format '</a>'];

          % Matlab 7.1 R14 (possibly a few newer versions as well?)
          % have a bug in rendering consecutive hyperlinks
          % This is fixed by appending a single non-linked space
          if majorVersion < 7 || (majorVersion==7 && minorVersion <= 1)
              format(end+1) = ' ';
          end
      end

      % Set bold, if requested and supported (R2011b+)
      if boldFlag
          if (majorVersion > 7 || minorVersion >= 13)
              format = ['<strong>' format '</strong>'];
          else
              boldFlag = 0;
          end
      end

      % Get the current CW position
      cmdWinDoc = com.mathworks.mde.cmdwin.CmdWinDocument.getInstance;
      lastPos = cmdWinDoc.getLength;

      % If not beginning of line
      bolFlag = 0;  %#ok
      %if docElement.getEndOffset - docElement.getStartOffset > 1
          % Display a hyperlink element in order to force element separation
          % (otherwise adjacent elements on the same line will be merged)
          if majorVersion<7 || (majorVersion==7 && minorVersion<13)
              if ~underlineFlag
                  fprintf('<a href=""> </a>');  %fprintf('<a href=""> </a>\b');
              elseif format(end)~=10  % if no newline at end
                  fprintf(' ');  %fprintf(' \b');
              end
          end
          %drawnow;
          bolFlag = 1;
      %end

      % Get a handle to the Command Window component
      mde = com.mathworks.mde.desk.MLDesktop.getInstance;
      cw = mde.getClient('Command Window');
      xCmdWndView = cw.getComponent(0).getViewport.getComponent(0);

      % Store the CW background color as a special color pref
      % This way, if the CW bg color changes (via File/Preferences), 
      % it will also affect existing rendered strs
      com.mathworks.services.Prefs.setColorPref('CW_BG_Color',xCmdWndView.getBackground);

      % Display the text in the Command Window
      count1 = fprintf(2,format,varargin{:});

      %awtinvoke(cmdWinDoc,'remove',lastPos,1);   % TODO: find out how to remove the extra '_'
      drawnow;  % this is necessary for the following to work properly (refer to Evgeny Pr in FEX comment 16/1/2011)
      docElement = cmdWinDoc.getParagraphElement(lastPos+1);
      if majorVersion<7 || (majorVersion==7 && minorVersion<13)
          if bolFlag && ~underlineFlag
              % Set the leading hyperlink space character ('_') to the bg color, effectively hiding it
              % Note: old Matlab versions have a bug in hyperlinks that need to be accounted for...
              %disp(' '); dumpElement(docElement)
              setElementStyle(docElement,'CW_BG_Color',1+underlineFlag,majorVersion,minorVersion); %+getUrlsFix(docElement));
              %disp(' '); dumpElement(docElement)
              el(end+1) = handle(docElement);  %#ok used in debug only
          end

          % Fix a problem with some hidden hyperlinks becoming unhidden...
          fixHyperlink(docElement);
          %dumpElement(docElement);
      end

      % Get the Document Element(s) corresponding to the latest fprintf operation
      while docElement.getStartOffset < cmdWinDoc.getLength
          % Set the element style according to the current style
          %disp(' '); dumpElement(docElement)
          specialFlag = underlineFlag | boldFlag;
          setElementStyle(docElement,style,specialFlag,majorVersion,minorVersion);
          %disp(' '); dumpElement(docElement)
          docElement2 = cmdWinDoc.getParagraphElement(docElement.getEndOffset+1);
          if isequal(docElement,docElement2),  break;  end
          docElement = docElement2;
          %disp(' '); dumpElement(docElement)
      end

      % Force a Command-Window repaint
      % Note: this is important in case the rendered str was not '\n'-terminated
      xCmdWndView.repaint;

      % The following is for debug use only:
      el(end+1) = handle(docElement);  %#ok used in debug only
      %elementStart  = docElement.getStartOffset;
      %elementLength = docElement.getEndOffset - elementStart;
      %txt = cmdWinDoc.getText(elementStart,elementLength);
  end

  if nargout
      count = count1;
  end
  return;  % debug breakpoint

% Process the requested style information
function [underlineFlag,boldFlag,style] = processStyleInfo(style)
  underlineFlag = 0;
  boldFlag = 0;

  % First, strip out the underline/bold markers
  if ischar(style)
      % Styles containing '-' or '_' should be underlined (using a no-target hyperlink hack)
      %if style(1)=='-'
      underlineIdx = (style=='-') | (style=='_');
      if any(underlineIdx)
          underlineFlag = 1;
          %style = style(2:end);
          style = style(~underlineIdx);
      end

      % Check for bold style (only if not underlined)
      boldIdx = (style=='*');
      if any(boldIdx)
          boldFlag = 1;
          style = style(~boldIdx);
      end
      if underlineFlag && boldFlag
          warning('YMA:cprintf:BoldUnderline','Matlab does not support both bold & underline')
      end

      % Check if the remaining style sting is a numeric vector
      %styleNum = str2num(style); %#ok<ST2NM>  % not good because style='text' is evaled!
      %if ~isempty(styleNum)
      if any(style==' ' | style==',' | style==';')
          style = str2num(style); %#ok<ST2NM>
      end
  end

  % Style = valid matlab RGB vector
  if isnumeric(style) && length(style)==3 && all(style<=1) && all(abs(style)>=0)
      if any(style<0)
          underlineFlag = 1;
          style = abs(style);
      end
      style = getColorStyle(style);

  elseif ~ischar(style)
      error('YMA:cprintf:InvalidStyle','Invalid style - see help section for a list of valid style values')

  % Style name
  else
      % Try case-insensitive partial/full match with the accepted style names
      validStyles = {'Text','Keywords','Comments','Strings','UnterminatedStrings','SystemCommands','Errors', ...
                     'Black','Cyan','Magenta','Blue','Green','Red','Yellow','White', ...
                     'Hyperlinks'};
      matches = find(strncmpi(style,validStyles,length(style)));

      % No match - error
      if isempty(matches)
          error('YMA:cprintf:InvalidStyle','Invalid style - see help section for a list of valid style values')

      % Too many matches (ambiguous) - error
      elseif length(matches) > 1
          error('YMA:cprintf:AmbigStyle','Ambiguous style name - supply extra characters for uniqueness')

      % Regular text
      elseif matches == 1
          style = 'ColorsText';  % fixed by Danilo, 29/8/2011

      % Highlight preference style name
      elseif matches < 8
          style = ['Colors_M_' validStyles{matches}];

      % Color name
      elseif matches < length(validStyles)
          colors = [0,0,0; 0,1,1; 1,0,1; 0,0,1; 0,1,0; 1,0,0; 1,1,0; 1,1,1];
          requestedColor = colors(matches-7,:);
          style = getColorStyle(requestedColor);

      % Hyperlink
      else
          style = 'Colors_HTML_HTMLLinks';  % CWLink
          underlineFlag = 1;
      end
  end

% Convert a Matlab RGB vector into a known style name (e.g., '[255,37,0]')
function styleName = getColorStyle(rgb)
  intColor = int32(rgb*255);
  javaColor = java.awt.Color(intColor(1), intColor(2), intColor(3));
  styleName = sprintf('[%d,%d,%d]',intColor);
  com.mathworks.services.Prefs.setColorPref(styleName,javaColor);

% Fix a bug in some Matlab versions, where the number of URL segments
% is larger than the number of style segments in a doc element
function delta = getUrlsFix(docElement)  %#ok currently unused
  tokens = docElement.getAttribute('SyntaxTokens');
  links  = docElement.getAttribute('LinkStartTokens');
  if length(links) > length(tokens(1))
      delta = length(links) > length(tokens(1));
  else
      delta = 0;
  end

% fprintf(2,str) causes all previous '_'s in the line to become red - fix this
function fixHyperlink(docElement)
  try
      tokens = docElement.getAttribute('SyntaxTokens');
      urls   = docElement.getAttribute('HtmlLink');
      urls   = urls(2);
      links  = docElement.getAttribute('LinkStartTokens');
      offsets = tokens(1);
      styles  = tokens(2);
      doc = docElement.getDocument;

      % Loop over all segments in this docElement
      for idx = 1 : length(offsets)-1
          % If this is a hyperlink with no URL target and starts with ' ' and is collored as an error (red)...
          if strcmp(styles(idx).char,'Colors_M_Errors')
              character = char(doc.getText(offsets(idx)+docElement.getStartOffset,1));
              if strcmp(character,' ')
                  if isempty(urls(idx)) && links(idx)==0
                      % Revert the style color to the CW background color (i.e., hide it!)
                      styles(idx) = java.lang.String('CW_BG_Color');
                  end
              end
          end
      end
  catch
      % never mind...
  end

% Set an element to a particular style (color)
function setElementStyle(docElement,style,specialFlag, majorVersion,minorVersion)
  %global tokens links urls urlTargets  % for debug only
  global oldStyles
  if nargin<3,  specialFlag=0;  end
  % Set the last Element token to the requested style:
  % Colors:
  tokens = docElement.getAttribute('SyntaxTokens');
  try
      styles = tokens(2);
      oldStyles{end+1} = styles.cell;

      % Correct edge case problem
      extraInd = double(majorVersion>7 || (majorVersion==7 && minorVersion>=13));  % =0 for R2011a-, =1 for R2011b+
      %{
      if ~strcmp('CWLink',char(styles(end-hyperlinkFlag))) && ...
          strcmp('CWLink',char(styles(end-hyperlinkFlag-1)))
         extraInd = 0;%1;
      end
      hyperlinkFlag = ~isempty(strmatch('CWLink',tokens(2)));
      hyperlinkFlag = 0 + any(cellfun(@(c)(~isempty(c)&&strcmp(c,'CWLink')),tokens(2).cell));
      %}

      styles(end-extraInd) = java.lang.String('');
      styles(end-extraInd-specialFlag) = java.lang.String(style);  %#ok apparently unused but in reality used by Java
      if extraInd
          styles(end-specialFlag) = java.lang.String(style);
      end

      oldStyles{end} = [oldStyles{end} styles.cell];
  catch
      % never mind for now
  end
  
  % Underlines (hyperlinks):
  %{
  links = docElement.getAttribute('LinkStartTokens');
  if isempty(links)
      %docElement.addAttribute('LinkStartTokens',repmat(int32(-1),length(tokens(2)),1));
  else
      %TODO: remove hyperlink by setting the value to -1
  end
  %}

  % Correct empty URLs to be un-hyperlinkable (only underlined)
  urls = docElement.getAttribute('HtmlLink');
  if ~isempty(urls)
      urlTargets = urls(2);
      for urlIdx = 1 : length(urlTargets)
          try
              if urlTargets(urlIdx).length < 1
                  urlTargets(urlIdx) = [];  % '' => []
              end
          catch
              % never mind...
              a=1;  %#ok used for debug breakpoint...
          end
      end
  end
  
  % Bold: (currently unused because we cannot modify this immutable int32 numeric array)
  %{
  try
      %hasBold = docElement.isDefined('BoldStartTokens');
      bolds = docElement.getAttribute('BoldStartTokens');
      if ~isempty(bolds)
          %docElement.addAttribute('BoldStartTokens',repmat(int32(1),length(bolds),1));
      end
  catch
      % never mind - ignore...
      a=1;  %#ok used for debug breakpoint...
  end
  %}
  
  return;  % debug breakpoint

% Display information about element(s)
function dumpElement(docElements)
  %return;
  numElements = length(docElements);
  cmdWinDoc = docElements(1).getDocument;
  for elementIdx = 1 : numElements
      if numElements > 1,  fprintf('Element #%d:\n',elementIdx);  end
      docElement = docElements(elementIdx);
      if ~isjava(docElement),  docElement = docElement.java;  end
      %docElement.dump(java.lang.System.out,1)
      disp(' ');
      disp(docElement)
      tokens = docElement.getAttribute('SyntaxTokens');
      if isempty(tokens),  continue;  end
      links = docElement.getAttribute('LinkStartTokens');
      urls  = docElement.getAttribute('HtmlLink');
      try bolds = docElement.getAttribute('BoldStartTokens'); catch, bolds = []; end
      txt = {};
      tokenLengths = tokens(1);
      for tokenIdx = 1 : length(tokenLengths)-1
          tokenLength = diff(tokenLengths(tokenIdx+[0,1]));
          if (tokenLength < 0)
              tokenLength = docElement.getEndOffset - docElement.getStartOffset - tokenLengths(tokenIdx);
          end
          txt{tokenIdx} = cmdWinDoc.getText(docElement.getStartOffset+tokenLengths(tokenIdx),tokenLength).char;  %#ok
      end
      lastTokenStartOffset = docElement.getStartOffset + tokenLengths(end);
      txt{end+1} = cmdWinDoc.getText(lastTokenStartOffset, docElement.getEndOffset-lastTokenStartOffset).char;  %#ok
      %cmdWinDoc.uiinspect
      %docElement.uiinspect
      txt = strrep(txt',sprintf('\n'),'\n');
      try
          data = [tokens(2).cell m2c(tokens(1)) m2c(links) m2c(urls(1)) cell(urls(2)) m2c(bolds) txt];
          if elementIdx==1
              disp('    SyntaxTokens(2,1) - LinkStartTokens - HtmlLink(1,2) - BoldStartTokens - txt');
              disp('    ==============================================================================');
          end
      catch
          try
              data = [tokens(2).cell m2c(tokens(1)) m2c(links) txt];
          catch
              disp([tokens(2).cell m2c(tokens(1)) txt]);
              try
                  data = [m2c(links) m2c(urls(1)) cell(urls(2))];
              catch
                  % Mtlab 7.1 only has urls(1)...
                  data = [m2c(links) urls.cell];
              end
          end
      end
      disp(data)
  end

% Utility function to convert matrix => cell
function cells = m2c(data)
  %datasize = size(data);  cells = mat2cell(data,ones(1,datasize(1)),ones(1,datasize(2)));
  cells = num2cell(data);

% Display the help and demo
function showDemo(majorVersion,minorVersion)
  fprintf('cprintf displays formatted text in the Command Window.\n\n');
  fprintf('Syntax: count = cprintf(style,format,...);  click <a href="matlab:help cprintf">here</a> for details.\n\n');
  url = 'http://UndocumentedMatlab.com/blog/cprintf/';
  fprintf(['Technical description: <a href="' url '">' url '</a>\n\n']);
  fprintf('Demo:\n\n');
  boldFlag = majorVersion>7 || (majorVersion==7 && minorVersion>=13);
  s = ['cprintf(''text'',    ''regular black text'');' 10 ...
       'cprintf(''hyper'',   ''followed %s'',''by'');' 10 ...
       'cprintf(''key'',     ''%d colored'',' num2str(4+boldFlag) ');' 10 ...
       'cprintf(''-comment'',''& underlined'');' 10 ...
       'cprintf(''err'',     ''elements:\n'');' 10 ...
       'cprintf(''cyan'',    ''cyan'');' 10 ...
       'cprintf(''_green'',  ''underlined green'');' 10 ...
       'cprintf(-[1,0,1],  ''underlined magenta'');' 10 ...
       'cprintf([1,0.5,0], ''and multi-\nline orange\n'');' 10];
   if boldFlag
       % In R2011b+ the internal bug that causes the need for an extra space
       % is apparently fixed, so we must insert the sparator spaces manually...
       % On the other hand, 2011b enables *bold* format
       s = [s 'cprintf(''*blue'',   ''and *bold* (R2011b+ only)\n'');' 10];
       s = strrep(s, ''')',' '')');
       s = strrep(s, ''',5)',' '',5)');
       s = strrep(s, '\n ','\n');
   end
   disp(s);
   eval(s);


%%%%%%%%%%%%%%%%%%%%%%%%%% TODO %%%%%%%%%%%%%%%%%%%%%%%%%
% - Fix: Remove leading space char (hidden underline '_')
% - Fix: Find workaround for multi-line quirks/limitations
% - Fix: Non-\n-terminated segments are displayed as black
% - Fix: Check whether the hyperlink fix for 7.1 is also needed on 7.2 etc.
% - Enh: Add font support


