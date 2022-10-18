function data = OmniTrakFileRead(file,varargin)

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

if nargin > 1                                                               %If there's any optional input arguments...
    
end

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
                
        switch block                                                        %Switch between the recognized block codes.

            case block_codes.INCOMPLETE_BLOCK                               %If the file will end in an incomplete block...
                fprintf(1,'Need to finish coding for block: INCOMPLETE_BLOCK\n');
                
            case block_codes.FILE_VERSION                                   %If the block code is for the file version...
                fprintf(1,'Need to finish coding for block: FILE_VERSION\n');
                
            case block_codes.MS_FILE_START                                  %If the block code is for the file start timestamp...
                data = Check_Field_Name(data,'file_start',[]);              %Call the subfunction to check for existing fieldnames.    
                data.file_start.ms = fread(fid,1,'uint32');                 %Save the file start 32-bit millisecond clock timestamp.

            case block_codes.MS_FILE_STOP                                   %If the block code is for the file stop timestamp...
                data = Check_Field_Name(data,'file_stop',[]);               %Call the subfunction to check for existing fieldnames.   
                data.file_stop.ms = fread(fid,1,'uint32');                  %Save the file stop 32-bit millisecond clock timestamp.
                
            case block_codes.CLOCK_FILE_START                               %If the block code is for the file start timestamp...
                data = Check_Field_Name(data,'file_start',[]);              %Call the subfunction to check for existing fieldnames.    
                data.file_start.datenum = fread(fid,1,'float64');           %Save the file start 32-bit millisecond clock timestamp.

            case block_codes.CLOCK_FILE_STOP                                %If the block code is for the file stop timestamp...
                data = Check_Field_Name(data,'file_stop',[]);               %Call the subfunction to check for existing fieldnames.   
                data.file_stop.datenum = fread(fid,1,'float64');            %Save the file stop 32-bit millisecond clock timestamp.

            case block_codes.DEVICE_FILE_INDEX                              %If the block code is for the device's current file index.
                if ~isfield(data,'device')                                  %If the structure doesn't yet have an "device" field..
                    data.device = [];                                       %Create the field.
                end
                data.device.file_index = fread(fid,1,'uint32');             %Save the 32-bit integer file index.

            case block_codes.NTP_SYNC                                       %If the block code is for an NTP clock synchronization.
                if ~isfield(data,'ntp_sync')                                %If the structure doesn't yet have an "ntp_sync" field..
                    data.ntp_sync = [];                                     %Create the field.
                end
                i = length(data.ntp_sync) + 1;                              %Find the next available index for a new NTP synchronization pair.
                data.ntp_sync(i).ntp = fread(fid,1,'uint32');               %Save the 32-bit NTP clock timestamp (number of seconds since 01/01/1900).
                data.ntp_sync(i).ms = fread(fid,1,'uint32');                %Save the 32-bit millisecond clock timestamp.
                data.ntp_sync(i).rollovers = fread(fid,1,'uint8');          %Save the number of rollovers since the last successful synchronization.

            case block_codes.NTP_SYNC_FAIL                                  %If the block code is for an NTP synchronization failure...
                fprintf(1,'Need to finish coding for block: NTP_SYNC_FAIL\n');

            case block_codes.MS_US_CLOCK_SYNC
                fprintf(1,'Need to finish coding for block: MS_US_CLOCK_SYNC\n');

            case block_codes.MS_TIMER_ROLLOVER
                fprintf(1,'Need to finish coding for block: MS_TIMER_ROLLOVER\n');

            case block_codes.US_TIMER_ROLLOVER
                fprintf(1,'Need to finish coding for block: US_TIMER_ROLLOVER\n');

            case block_codes.RTC_STRING_DEPRECATED
                fprintf(1,'Need to finish coding for block: RTC_STRING_DEPRECATED\n');

            case block_codes.RTC_STRING
                fprintf(1,'Need to finish coding for block: RTC_STRING\n');

            case block_codes.RTC_VALUES                                     %Current date/time values from the real-time clock.
                data = Check_Field_Name(data,'clock',[]);                   %Call the subfunction to check for existing fieldnames.    
                i = length(data.clock) + 1;                                 %Find the next available index for a new real-time clock synchronization.
                data.clock(i).ms = fread(fid,1,'uint32');                   %Save the 32-bit millisecond clock timestamp.
                yr = fread(fid,1,'uint16');                                 %Read in the year.
                mo = fread(fid,1,'uint8');                                  %Read in the month.
                dy = fread(fid,1,'uint8');                                  %Read in the day.
                hr = fread(fid,1,'uint8');                                  %Read in the hour.
                mn = fread(fid,1,'uint8');                                  %Read in the minute.
                sc = fread(fid,1,'uint8');                                  %Read in the second.            
                data.clock(i).datenum = datenum(yr, mo, dy, hr, mn, sc);    %Save the RTC time as a MATLAB serial date number.
                data.clock(i).source = 'RTC';                               %Indicate that the date/time source was a real-time clock.

            case block_codes.ORIGINAL_FILENAME                              %Original filename, if renamed.
                fprintf(1,'Need to finish coding for block: ORIGINAL_FILENAME\n');

            case block_codes.RENAMED_FILE                                   %Timestamped event information for file name changes.
                data = Check_Field_Name(data,'file_info','rename');         %Call the subfunction to check for existing fieldnames.
                i = length(data.file_info.rename) + 1;                      %Find the next available index for a renaming event.
                data.file_info.rename(i).time = fread(fid,1,'float64');     %Read in the timestamp for the renaming.
                N = fread(fid,1,'uint16');                                  %Read in the number of characters in the old filename.
                data.file_info.rename(i).old = char(fread(fid,N,'uchar')'); %Read in the old filename.
                N = fread(fid,1,'uint16');                                  %Read in the number of characters in the new filename.
                data.file_info.rename(i).new = char(fread(fid,N,'uchar')'); %Read in the new filename.                   

            case block_codes.DOWNLOAD_TIME                                  %Timestamp for when the data was downloaded from a device.
                data = Check_Field_Name(data,'file_info','download');       %Call the subfunction to check for existing fieldnames.
                data.file_info.download.time = fread(fid,1,'float64');      %Read in the timestamp for the download.

            case block_codes.DOWNLOAD_SYSTEM                                %System information for how the data was downloaded from the device.
                data = Check_Field_Name(data,'file_info','download');       %Call the subfunction to check for existing fieldnames.
                N = fread(fid,1,'uint8');                                   %Read in the number of characters.
                data.file_info.download.computer = ...
                    char(fread(fid,N,'uchar')');                            %Read in the computer name.
                N = fread(fid,1,'uint8');                                   %Read in the number of characters.
                data.file_info.download.port = char(fread(fid,N,'uchar')'); %Read in the port name.
                
            case block_codes.USER_TIME                                      %Current date/time values from the real-time clock.
                data = Check_Field_Name(data,'clock',[]);                   %Call the subfunction to check for existing fieldnames.    
                i = length(data.clock) + 1;                                 %Find the next available index for a new real-time clock synchronization.
                data.clock(i).ms = fread(fid,1,'uint32');                   %Save the 32-bit millisecond clock timestamp.
                yr = double(fread(fid,1,'uint8')) + 2000;                   %Read in the year.
                mo = fread(fid,1,'uint8');                                  %Read in the month.
                dy = fread(fid,1,'uint8');                                  %Read in the day.
                hr = fread(fid,1,'uint8');                                  %Read in the hour.
                mn = fread(fid,1,'uint8');                                  %Read in the minute.
                sc = fread(fid,1,'uint8');                                  %Read in the second.            
                data.clock(i).datenum = datenum(yr, mo, dy, hr, mn, sc);    %Save the RTC time as a MATLAB serial date number.
                data.clock(i).source = 'USER';                              %Indicate that the date/time source was a real-time clock.

            case block_codes.SYSTEM_TYPE                                    %If the block code is for Vulintus system ID code...
                if ~isfield(data,'device')                                  %If the structure doesn't yet have an "device" field.
                    data.device = [];                                       %Create the field.
                end
                data.device.type = fread(fid,1,'uint8');                    %Save the device type value.

            case block_codes.SYSTEM_NAME                                    %If the block code is for the Vulintus system name.
                if ~isfield(data,'device')                                  %If the structure doesn't yet have an "device" field.
                    data.device = [];                                       %Create the field.
                end
                N = fread(fid,1,'uint16');                                  %Read in the number of characters.
                data.device.system_name = fread(fid,N,'*char')';            %Read in the characters of the system name.

            case block_codes.SYSTEM_HW_VER                                  %If the block code is for the device hardware version...
                if ~isfield(data,'device')                                  %If the structure doesn't yet have an "device" field.
                    data.device = [];                                       %Create the field.
                end
                data.device.hw_version = fread(fid,1,'float32');            %Save the device hardware version.
                
            case block_codes.SYSTEM_FW_VER                                  %If the block code is for the device firmware version...
                if ~isfield(data,'device')                                  %If the structure doesn't yet have an "device" field..
                    data.device = [];                                       %Create the field.
                end
                N = fread(fid,1,'uint8');                                   %Read in the number of characters.
                data.device.fw_version = char(fread(fid,N,'uchar')');       %Read in the firmware version.
                
            case block_codes.SYSTEM_SN                                      %If the block code is for the device serial number...
                if ~isfield(data,'device')                                  %If the structure doesn't yet have an "device" field.
                    data.device = [];                                       %Create the field.
                end
                N = fread(fid,1,'uint8');                                   %Read in the number of characters.
                data.device.serial_num = char(fread(fid,N,'uchar')');       %Read in the serial number.
                
%             case block_codes.SYSTEM_MFR                                     %If the block code is for the device manufacturer (non-Vulintus)...
%                 if ~isfield(data,'device')                                  %If the structure doesn't yet have an "device" field.
%                     data.device = [];                                       %Create the field.
%                 end
%                 N = fread(fid,1,'uint8');                                   %Read in the number of characters.
%                 data.device.manufacturer = char(fread(fid,N,'uchar')');     %Read in the manufacturer.
                
            case block_codes.COMPUTER_NAME                                  %Computer name for a PC-connected systems.
                data = Check_Field_Name(data,'device','computer');          %Call the subfunction to check for existing fieldnames.
                N = fread(fid,1,'uint8');                                   %Read in the number of characters.
                data.device.computer = char(fread(fid,N,'uchar')');         %Read in the computer name.

            case block_codes.COM_PORT                                       %COM port ID for a PC-connected systems.
                data = Check_Field_Name(data,'device','com');               %Call the subfunction to check for existing fieldnames.
                N = fread(fid,1,'uint8');                                   %Read in the number of characters.
                data.file_info.download.port = char(fread(fid,N,'uchar')'); %Read in the port name.
                
            case block_codes.PRIMARY_MODULE                                 %If the block code is for the primary module name...
                data = Check_Field_Name(data,'module',[]);                  %Call the subfunction to check for existing fieldnames.
                N = fread(fid,1,'uint16');                                  %Read in the number of characters.
                data.module.primary = fread(fid,N,'*char')';                %Read in the characters of the primary module name.
                
            case block_codes.PRIMARY_INPUT                                  %If the block code is for the primary input name...
                data = Check_Field_Name(data,'input',[]);                   %Call the subfunction to check for existing fieldnames.
                N = fread(fid,1,'uint16');                                  %Read in the number of characters.
                data.input.primary = fread(fid,N,'*char')';                 %Read in the characters of the primary module name.

            case {block_codes.ESP8266_MAC_ADDR,...
                    block_codes.WINC1500_MAC_ADDR}                          %If the block code is for ESP8266 MAC address...
                data = Check_Field_Name(data,'device',[]);                  %Call the subfunction to check for existing fieldnames.
                data.device.mac_addr = fread(fid,6,'uint8');                %Save the device MAC address.

            case {block_codes.ESP8266_IP4_ADDR,...
                    block_codes.WINC1500_IP4_ADDR}                          %If the block code is for ESP8266 IP4 address...
                fprintf(1,'Need to finish coding for block: ESP8266_IP4_ADDR / ATWINC1500_IP4_ADDR\n');

            case block_codes.ESP8266_CHIP_ID                                %If the block code is for ESP8266 unique chip ID...
                if ~isfield(data,'device')                                  %If the structure doesn't yet have an "device" field..
                    data.device = [];                                       %Create the field.
                end
                data.device.chip_id = fread(fid,1,'uint32');                %Save the device's unique chip ID.

            case block_codes.ESP8266_FLASH_ID                               %If the block code is for ESP8266 unique flash chip ID...
                if ~isfield(data,'device')                                  %If the structure doesn't yet have an "device" field..
                    data.device = [];                                       %Create the field.
                end
                data.device.flash_id = fread(fid,1,'uint32');               %Save the device's unique flash chip ID.

            case block_codes.USER_SYSTEM_NAME                               %If the block code is for the user's system name...
                if ~isfield(data,'device')                                  %If the structure doesn't yet have an "device" field..
                    data.device = [];                                       %Create the field.
                end
                N = fread(fid,1,'uint8');                                   %Read in the number of characters.
                data.device.user_system_name = fread(fid,N,'*char')';       %Read in the characters of the system name.

           case block_codes.OTS_SYSTEM_NAME                                 %If the block code is for the non-Vulintus system name... << DELETE
                if ~isfield(data,'device')                                  %If the structure doesn't yet have an "device" field.
                    data.device = [];                                       %Create the field.
                end
                N = fread(fid,1,'uint8');                                   %Read in the number of characters.
                data.device.system_name = fread(fid,N,'*char')';            %Read in the characters of the system name.
                                
            case block_codes.OTS_MFR_NAME                                   %If the block code is for the device manufacturer (non-Vulintus)...  << DELETE
                if ~isfield(data,'device')                                  %If the structure doesn't yet have an "device" field.
                    data.device = [];                                       %Create the field.
                end
                N = fread(fid,1,'uint8');                                   %Read in the number of characters.
                data.device.manufacturer = char(fread(fid,N,'uchar')');     %Read in the manufacturer.
                
            case block_codes.DEVICE_RESET_COUNT                             %If the block code is for the device reset count...
                if ~isfield(data,'device')                                  %If the structure doesn't yet have an "device" field..
                    data.device = [];                                       %Create the field.
                end
                data.device.reset_count = fread(fid,1,'uint16');            %Save the device's reset count for the file.

            case block_codes.BATTERY_SOC                                    %Current battery state-of charge, in percent, measured the BQ27441.
                data = Check_Field_Name(data,'bat','soc');                  %Call the subfunction to check for existing fieldnames.         
                j = length(data.bat.soc) + 1;                               %Grab a new reading index.   
                data.bat.soc(j).timestamp = fread(fid,1,'uint32');          %Save the millisecond clock timestamp for the reading.
                data.bat.soc(j).percent = fread(fid,1,'uint16');            %Save the state-of-charge reading, in percent.

            case block_codes.BATTERY_VOLTS                                  %Current battery voltage, in millivolts, measured by the BQ27441.
                data = Check_Field_Name(data,'bat','volt');                 %Call the subfunction to check for existing fieldnames.         
                j = length(data.bat.volt) + 1;                              %Grab a new reading index.   
                data.bat.volt(j).timestamp = readtime;                      %Save the millisecond clock timestamp for the reading.
                data.bat.volt(j).reading = ...
                    double(fread(fid,1,'uint16'))/1000;                     %Save the battery voltage, in volts.

            case block_codes.BATTERY_CURRENT                                %Average current draw from the battery, in milli-amps, measured by the BQ27441.
                data = Check_Field_Name(data,'bat','cur');                  %Call the subfunction to check for existing fieldnames.         
                j = length(data.bat.current) + 1;                           %Grab a new reading index.   
                data.bat.cur(j).timestamp = readtime;                       %Save the millisecond clock timestamp for the reading.
                data.bat.cur(j).reading = ...
                    double(fread(fid,1,'int16'))/1000;                      %Save the average current draw, in amps.

            case block_codes.BATTERY_FULL                                   %Full capacity of the battery, in milli-amp hours, measured by the BQ27441.
                data = Check_Field_Name(data,'bat','full');                 %Call the subfunction to check for existing fieldnames.    
                j = length(data.bat.full) + 1;                              %Grab a new reading index.   
                data.bat.full(j).timestamp = readtime;                      %Save the millisecond clock timestamp for the reading.
                data.bat.full(j).reading = ...
                    double(fread(fid,1,'uint16'))/1000;                     %Save the battery's full capacity, in amp-hours.

            case block_codes.BATTERY_REMAIN                                     %Remaining capacity of the battery, in milli-amp hours, measured by the BQ27441.
                data = Check_Field_Name(data,'bat','rem');                      %Call the subfunction to check for existing fieldnames.    
                j = length(data.bat.rem) + 1;                                   %Grab a new reading index.   
                data.bat.rem(j).timestamp = readtime;                           %Save the millisecond clock timestamp for the reading.
                data.bat.rem(j).reading = ...
                    double(fread(fid,1,'uint16'))/1000;                     %Save the battery's remaining capacity, in amp-hours.

            case block_codes.BATTERY_POWER                                  %Average power draw, in milliWatts, measured by the BQ27441.
                data = Check_Field_Name(data,'bat','pwr');                  %Call the subfunction to check for existing fieldnames.    
                j = length(data.bat.pwr) + 1;                               %Grab a new reading index.   
                data.bat.pwr(j).timestamp = readtime;                       %Save the millisecond clock timestamp for the reading.
                data.bat.pwr(j).reading = ...
                    double(fread(fid,1,'int16'))/1000;                      %Save the average power draw, in Watts.

            case block_codes.BATTERY_SOH                                        %Battery state-of-health, in percent, measured by the BQ27441.
                data = Check_Field_Name(data,'bat','sof');                      %Call the subfunction to check for existing fieldnames.    
                j = length(data.bat.soh) + 1;                                   %Grab a new reading index.   
                data.bat.soh(j).timestamp = readtime;                           %Save the millisecond clock timestamp for the reading.
                data.bat.soh(j).reading = fread(fid,1,'int16');                 %Save the state-of-health reading, in percent.

            case block_codes.BATTERY_STATUS                                 %Combined battery state-of-charge, voltage, current, capacity, power, and state-of-health, measured by the BQ27441.
                readtime = fread(fid,1,'uint32');                           %Grab the millisecond clock timestamp for the readings.
                data = Check_Field_Name(data,'bat','soc');                  %Call the subfunction to check for existing fieldnames.
                j = length(data.bat.soc) + 1;                               %Grab a new reading index.   
                data.bat.soc(j).timestamp = readtime;                       %Save the millisecond clock timestamp for the reading.
                data.bat.soc(j).reading = fread(fid,1,'uint16');            %Save the state-of-charge reading, in percent.
                data = Check_Field_Name(data,'bat','volt');                 %Call the subfunction to check for existing fieldnames.        
                j = length(data.bat.volt) + 1;                              %Grab a new reading index.   
                data.bat.volt(j).timestamp = readtime;                      %Save the millisecond clock timestamp for the reading.
                data.bat.volt(j).reading = ...
                    double(fread(fid,1,'uint16'))/1000;                     %Save the battery voltage, in volts.
                data = Check_Field_Name(data,'bat','cur');                  %Call the subfunction to check for existing fieldnames.        
                j = length(data.bat.cur) + 1;                               %Grab a new reading index.   
                data.bat.cur(j).timestamp = readtime;                       %Save the millisecond clock timestamp for the reading.
                data.bat.cur(j).reading = ...
                    double(fread(fid,1,'int16'))/1000;                      %Save the average current draw, in amps.
                data = Check_Field_Name(data,'bat','full');                 %Call the subfunction to check for existing fieldnames.        
                j = length(data.bat.full) + 1;                              %Grab a new reading index.   
                data.bat.full(j).timestamp = readtime;                      %Save the millisecond clock timestamp for the reading.
                data.bat.full(j).reading = ...
                    double(fread(fid,1,'uint16'))/1000;                     %Save the battery's full capacity, in amp-hours.
                data = Check_Field_Name(data,'bat','rem');                  %Call the subfunction to check for existing fieldnames.        
                j = length(data.bat.rem) + 1;                               %Grab a new reading index.   
                data.bat.rem(j).timestamp = readtime;                       %Save the millisecond clock timestamp for the reading.
                data.bat.rem(j).reading = ...
                    double(fread(fid,1,'uint16'))/1000;                     %Save the battery's remaining capacity, in amp-hours.
                data = Check_Field_Name(data,'bat','pwr');                  %Call the subfunction to check for existing fieldnames.        
                j = length(data.bat.pwr) + 1;                               %Grab a new reading index.   
                data.bat.pwr(j).timestamp = readtime;                       %Save the millisecond clock timestamp for the reading.
                data.bat.pwr(j).reading = ...
                    double(fread(fid,1,'int16'))/1000;                      %Save the average power draw, in Watts.
                data = Check_Field_Name(data,'bat','soh');                  %Call the subfunction to check for existing fieldnames.
                j = length(data.bat.soh) + 1;                               %Grab a new reading index.   
                data.bat.soh(j).timestamp = readtime;                       %Save the millisecond clock timestamp for the reading.
                data.bat.soh(j).reading = fread(fid,1,'int16');             %Save the state-of-health reading, in percent.
                
            case block_codes.FEED_SERVO_MAX_RPM                             %Maximum measured speed of the feeder servo (OmniHome).
                data = Check_Field_Name(data,'device','feeder');            %Call the subfunction to check for existing fieldnames.
                i = fread(fid,1,'uint8');                                   %Read in the dispenser index.
                data.device.feeder(i).max_rpm = fread(fid,1,'float32');     %Read in the maximum measure speed, in RPM.
                
            case block_codes.FEED_SERVO_SPEED                               %Current speed setting for the feeder servo (OmniHome).
                data = Check_Field_Name(data,'device','feeder');            %Call the subfunction to check for existing fieldnames.
                i = fread(fid,1,'uint8');                                   %Read in the dispenser index.
                data.device.feeder(i).servo_speed = fread(fid,1,'uint8');   %Read in the current speed setting (0-180).

            case {block_codes.SUBJECT_NAME, block_codes.SUBJECT_DEPRECATED} %A single subject's name.
                N = fread(fid,1,'uint16');                                  %Read in the number of characters.
                data.subject = fread(fid,N,'*char')';                       %Read in the characters of the subject's name.

            case block_codes.GROUP_NAME                                     %The subject's or subjects' experimental group name.
                N = fread(fid,1,'uint16');                                  %Read in the number of characters.
                data.subject = fread(fid,N,'*char')';                       %Read in the characters of the subject's name.

            case block_codes.EXP_NAME                                       %The user's name for the current experiment.
                N = fread(fid,1,'uint16');                                  %Read in the number of characters.
                data.exp_name = fread(fid,N,'*char')';                      %Read in the characters of the user's experiment name.
                
            case block_codes.TASK_TYPE                                      %The user's name for the task type.
                data = Check_Field_Name(data,'task',[]);                    %Call the subfunction to check for existing fieldnames.                
                N = fread(fid,1,'uint16');                                  %Read in the number of characters.
                data.task.type = fread(fid,N,'*char')';                     %Read in the characters of the user's task type.

            case block_codes.STAGE_NAME                                     %The behavioral session stage name.
                N = fread(fid,1,'uint16');                                  %Read in the number of characters.
                data.stage_name = fread(fid,N,'*char')';                    %Read in the characters of the behavioral session stage name.

            case block_codes.STAGE_DESCRIPTION                              %The behavioral session stage description.
                N = fread(fid,1,'uint16');                                  %Read in the number of characters.
                data.stage_description = fread(fid,N,'*char')';             %Read in the characters of the behavioral session stage description.

            case block_codes.AMG8833_THERM_FL                               %If the block code is for an AMG8833 pixel reading.            
                data = Check_Field_Name(data,'temp',[]);                    %Call the subfunction to check for existing fieldnames.
                i = length(data.temp) + 1;                                  %Grab a new temperature reading index.
                data.temp(i).src = 'AMG8833';                               %Save the source of the temperature reading.
                data.temp(i).id = fread(fid,1,'uint8');                     %Read in the AMG8833 sensor index (there may be multiple sensors).
                data.temp(i).time = fread(fid,1,'uint32');                  %Save the millisecond clock timestamp for the reading.
                data.temp(i).float = fread(fid,1,'float32');                %Save the temperature reading as a float32 value.

            case block_codes.AMG8833_PIXELS_FL                              %The current AMG8833 pixel readings as converted float32 values, in Celsius.
                id = fread(fid,1,'uint8');                                  %Read in the AMG8833 sensor index (there may be multiple sensors).
                if ~isfield(data,'amg')                                     %If the structure doesn't yet have an "amg" field..
                    data.amg = [];                                          %Create the field.
                    data.amg(1).id = id;                                    %Save the file-specified index for this AMG8833.
                end
                temp = vertcat(data.amg(:).id);                             %Grab all of the existing AMG8833 indices.
                i = find(temp == id);                                       %Find the field index for the current AMG8833.
                if ~isfield(data.amg,'pixels')                              %If the "amg" field doesn't yet have an "pixels" field..
                    data.amg.pixels = [];                                   %Create the "pixels" field. 
                end            
                j = length(data.amg(i).pixels) + 1;                         %Grab a new reading index.   
                data.amg(i).pixels(j).timestamp = fread(fid,1,'uint32');    %Save the millisecond clock timestamp for the reading.
                data.amg(i).pixels(j).float = nan(8,8);                     %Create an 8x8 matrix to hold the pixel values.
                for k = 8:-1:1                                              %Step through the rows of pixels.
                    data.amg(i).pixels(j).float(k,:) = ...
                        fliplr(fread(fid,8,'float32'));                     %Read in each row of pixel values.
                end

            case block_codes.MLX90640_PIXELS_TO                             %The current MLX90640 pixel readings as converted float32 values, in Celsius.
                id = fread(fid,1,'uint8');                                  %Read in the AMG8833 sensor index (there may be multiple sensors).
                if ~isfield(data,'mlx')                                     %If the structure doesn't yet have an "amg" field..
                    data.mlx = [];                                          %Create the field.
                    data.mlx(1).id = id;                                    %Save the file-specified index for this AMG8833.
                end
                temp = vertcat(data.mlx(:).id);                             %Grab all of the existing AMG8833 indices.
                i = find(temp == id);                                       %Find the field index for the current AMG8833.
                if ~isfield(data.mlx,'pixels')                              %If the "amg" field doesn't yet have an "pixels" field..
                    data.mlx.pixels = [];                                   %Create the "pixels" field. 
                end            
                j = length(data.mlx(i).pixels) + 1;                         %Grab a new reading index.   
                data.mlx(i).pixels(j).timestamp = fread(fid,1,'uint32');    %Save the millisecond clock timestamp for the reading.
                data.mlx(i).pixels(j).float = nan(24,32);                   %Create an 8x8 matrix to hold the pixel values.
                for k = 1:24                                                %Step through the rows of pixels.
                    data.mlx(i).pixels(j).float(k,:) = ...
                        fliplr(fread(fid,32,'float32'));                    %Read in each row of pixel values.
                end

            case block_codes.BME280_TEMP_FL                                 %The current BME280 temperature reading as a converted float32 value, in Celsius.
                if ~isfield(data,'temp')                                    %If the structure doesn't yet have a "temp" field..
                    data.temp = [];                                         %Create the field.
                end
                i = length(data.temp) + 1;                                  %Grab a new temperature reading index.
                data.temp(i).src = 'BME280';                                %Save the source of the temperature reading.
                data.temp(i).id = fread(fid,1,'uint8');                     %Read in the BME280 sensor index (there may be multiple sensors).
                data.temp(i).time = fread(fid,1,'uint32');                  %Save the millisecond clock timestamp for the reading.
                data.temp(i).float = fread(fid,1,'float32');                %Save the temperature reading as a float32 value.

            case block_codes.BMP280_TEMP_FL                                 %The current BMP280 temperature reading as a converted float32 value, in Celsius.
                if ~isfield(data,'temp')                                    %If the structure doesn't yet have a "temp" field..
                    data.temp = [];                                         %Create the field.
                end
                i = length(data.temp) + 1;                                  %Grab a new temperature reading index.
                data.temp(i).src = 'BMP280';                                %Save the source of the temperature reading.
                data.temp(i).id = fread(fid,1,'uint8');                     %Read in the BMP280 sensor index (there may be multiple sensors).
                data.temp(i).time = fread(fid,1,'uint32');                  %Save the millisecond clock timestamp for the reading.
                data.temp(i).float = fread(fid,1,'float32');                %Save the temperature reading as a float32 value.

            case block_codes.BME280_PRES_FL
                if ~isfield(data,'pres')                                        %If the structure doesn't yet have a "pres" field..
                    data.pres = [];                                             %Create the field.
                end
                i = length(data.pres) + 1;                                      %Grab a new pressure reading index.
                data.pres(i).src = 'BME280';                                    %Save the source of the pressure reading.
                data.pres(i).id = fread(fid,1,'uint8');                         %Read in the BME280 sensor index (there may be multiple sensors).
                data.pres(i).time = fread(fid,1,'uint32');                      %Save the millisecond clock timestamp for the reading.
                data.pres(i).float = fread(fid,1,'float32');                    %Save the pressure reading as a float32 value.

            case block_codes.BMP280_PRES_FL
                if ~isfield(data,'pres')                                        %If the structure doesn't yet have a "pres" field..
                    data.pres = [];                                             %Create the field.
                end
                i = length(data.pres) + 1;                                      %Grab a new pressure reading index.
                data.pres(i).src = 'BMP280';                                    %Save the source of the pressure reading.
                data.pres(i).id = fread(fid,1,'uint8');                         %Read in the BMP280 sensor index (there may be multiple sensors).
                data.pres(i).time = fread(fid,1,'uint32');                      %Save the millisecond clock timestamp for the reading.
                data.pres(i).float = fread(fid,1,'float32');                    %Save the pressure reading as a float32 value.

            case block_codes.BME280_HUM_FL
                if ~isfield(data,'hum')                                         %If the structure doesn't yet have a "hum" field..
                    data.hum = [];                                              %Create the field.
                end
                i = length(data.hum) + 1;                                       %Grab a new pressure reading index.
                data.hum(i).src = 'BME280';                                     %Save the source of the pressure reading.
                data.hum(i).id = fread(fid,1,'uint8');                          %Read in the BME280 sensor index (there may be multiple sensors).
                data.hum(i).time = fread(fid,1,'uint32');                       %Save the millisecond clock timestamp for the reading.
                data.hum(i).float = fread(fid,1,'float32');                     %Save the pressure reading as a float32 value.

            case block_codes.VL53L0X_DIST
                if ~isfield(data,'dist')                                        %If the structure doesn't yet have a "dist" field..
                    data.dist = [];                                             %Create the field.
                end
                i = length(data.dist) + 1;                                      %Grab a new distance reading index.
                data.dist(i).src = 'VL53L0X';                                   %Save the source of the distance reading.
                data.dist(i).id = fread(fid,1,'uint8');                         %Read in the VL53L0X sensor index (there may be multiple sensors).
                data.dist(i).time = fread(fid,1,'uint32');                      %Save the millisecond clock timestamp for the reading.
                data.dist(i).int = fread(fid,1,'uint16');                       %Save the distance reading as an unsigned 16-bit value.            

            case block_codes.VL53L0X_FAIL
                if ~isfield(data,'dist')                                        %If the structure doesn't yet have a "dist" field..
                    data.dist = [];                                             %Create the field.
                end
                i = length(data.dist) + 1;                                      %Grab a new distance reading index.
                data.dist(i).src = 'SGP30';                                     %Save the source of the distance reading.
                data.dist(i).id = fread(fid,1,'uint8');                         %Read in the VL53L0X sensor index (there may be multiple sensors).
                data.dist(i).time = fread(fid,1,'uint32');                      %Save the millisecond clock timestamp for the reading.
                data.dist(i).int = NaN;                                         %Save a NaN in place of a value to indicate a read failure.

            case block_codes.SGP30_SN
                fprintf(1,'Need to finish coding for block: SGP30_SN\n');

            case block_codes.SGP30_EC02
                if ~isfield(data,'eco2')                                        %If the structure doesn't yet have a "eco2" field..
                    data.eco2 = [];                                             %Create the field.
                end
                i = length(data.eco2) + 1;                                      %Grab a new eCO2 reading index.
                data.eco2(i).src = 'SGP30';                                     %Save the source of the eCO2 reading.
                data.eco2(i).id = fread(fid,1,'uint8');                         %Read in the SGP30 sensor index (there may be multiple sensors).
                data.eco2(i).time = fread(fid,1,'uint32');                      %Save the millisecond clock timestamp for the reading.
                data.eco2(i).int = fread(fid,1,'uint16');                       %Save the eCO2 reading as an unsigned 16-bit value.

            case block_codes.SGP30_TVOC
                if ~isfield(data,'tvoc')                                        %If the structure doesn't yet have a "tvoc" field..
                    data.tvoc = [];                                             %Create the field.
                end
                i = length(data.tvoc) + 1;                                      %Grab a new TVOC reading index.
                data.tvoc(i).src = 'SGP30';                                     %Save the source of the TVOC reading.
                data.tvoc(i).id = fread(fid,1,'uint8');                         %Read in the SGP30 sensor index (there may be multiple sensors).
                data.tvoc(i).time = fread(fid,1,'uint32');                      %Save the millisecond clock timestamp for the reading.
                data.tvoc(i).int = fread(fid,1,'uint16');                       %Save the TVOC reading as an unsigned 16-bit value.

            case block_codes.ALSPT19_LIGHT
                if ~isfield(data,'amb')                                     %If the structure doesn't yet have an "amb" field..
                    data.amb = [];                                          %Create the field.
                end
                i = length(data.amb) + 1;                                   %Grab a new ambient light reading index.
                data.amb(i).src = 'ALSPT19';                                %Save the source of the ambient light reading.
                data.amb(i).id = fread(fid,1,'uint8');                      %Read in the ambient light sensor index (there may be multiple sensors).
                data.amb(i).time = fread(fid,1,'uint32');                   %Save the millisecond clock timestamp for the reading.
                data.amb(i).int = fread(fid,1,'uint16');                    %Save the ambient light reading as an unsigned 16-bit value.

            case block_codes.ZMOD4410_MOX_BOUND                             %The current lower and upper bounds for the ZMOD4410 ADC reading used in calculations.
                fprintf(1,'Need to finish coding for block: ZMOD4410_MOX_BOUND\n');

            case block_codes.ZMOD4410_CONFIG_PARAMS                         %Current configuration values for the ZMOD4410.
                fprintf(1,'Need to finish coding for block: ZMOD4410_CONFIG_PARAMS\n');

            case block_codes.ZMOD4410_ERROR                                 %Timestamped ZMOD4410 error event.
                fprintf(1,'Need to finish coding for block: ZMOD4410_ERROR\n');

            case block_codes.ZMOD4410_READING_FL                            %Timestamped ZMOD4410 reading calibrated and converted to float32.
                fprintf(1,'Need to finish coding for block: ZMOD4410_READING_FL\n');

            case block_codes.ZMOD4410_READING_INT                           %Timestamped ZMOD4410 reading saved as the raw uint16 ADC value.
                data = Check_Field_Name(data,'gas_adc',[]);                 %Call the subfunction to check for existing fieldnames.
                i = length(data.gas_adc) + 1;                               %Grab a new TVOC reading index.
                data.gas_adc(i).src = 'ZMOD4410';                           %Save the source of the TVOC reading.
                data.gas_adc(i).id = fread(fid,1,'uint8');                  %Read in the SGP30 sensor index (there may be multiple sensors).
                data.gas_adc(i).time = fread(fid,1,'uint32');               %Save the millisecond clock timestamp for the reading.
                data.gas_adc(i).int = fread(fid,1,'uint16');                %Save the TVOC reading as an unsigned 16-bit value.

            case block_codes.ZMOD4410_ECO2                                  %Timestamped ZMOD4410 eCO2 reading.
                fprintf(1,'Need to finish coding for block: ZMOD4410_ECO2\n');

            case block_codes.ZMOD4410_IAQ                                   %Timestamped ZMOD4410 indoor air quality reading.
                fprintf(1,'Need to finish coding for block: ZMOD4410_IAQ\n');

            case block_codes.ZMOD4410_TVOC                                  %Timestamped ZMOD4410 total volatile organic compound reading, in ppm
                fprintf(1,'Need to finish coding for block: ZMOD4410_TVOC\n');

            case block_codes.ZMOD4410_R_CDA                       
                fprintf(1,'Need to finish coding for block: ZMOD4410_R_CDA\n');

            case block_codes.LSM303_ACC_SETTINGS                       
                fprintf(1,'Need to finish coding for block: LSM303_ACC_SETTINGS\n');

            case block_codes.LSM303_MAG_SETTINGS                       
                fprintf(1,'Need to finish coding for block: LSM303_MAG_SETTINGS\n');

            case block_codes.LSM303_ACC_FL                       
                data = Check_Field_Name(data,'acc',[]);                     %Call the subfunction to check for existing fieldnames.
                i = length(data.acc) + 1;                                   %Grab a new accelerometer reading index.
                data.acc(i).src = 'LSM303';                                 %Save the source of the accelerometer reading.
                data.acc(i).id = fread(fid,1,'uint8');                      %Read in the accelerometer sensor index (there may be multiple sensors).
                data.acc(i).time = fread(fid,1,'uint32');                   %Save the millisecond clock timestamp for the reading.
                data.acc(i).xyz = fread(fid,3,'float32');                   %Save the accelerometer x-y-z readings as float-32 values.

            case block_codes.LSM303_MAG_FL                       
                fprintf(1,'Need to finish coding for block: LSM303_MAG_FL\n');            

            case block_codes.PELLET_DISPENSE                       
                fprintf(1,'Need to finish coding for block: PELLET_DISPENSE\n');    

            case block_codes.PELLET_FAILURE                       
                data = Check_Field_Name(data,'pellet','fail');              %Call the subfunction to check for existing fieldnames.
                i = fread(fid,1,'uint8');                                   %Read in the dispenser index.
                if length(data.pellet) < i                                  %If there's no entry yet for this dispenser...
                    data.pellet(i).fail = fread(fid,1,'uint32');            %Save the millisecond clock timestamp for the pellet dispensing failure.
                else                                                        %Otherwise, if there's an entry for this dispenser.
                    j = size(data.pellet(i).fail,1) + 1;                    %Find the next index for the pellet failure timestamp.
                    data.pellet(i).fail(j) = fread(fid,1,'uint32');         %Save the millisecond clock timestamp for the pellet dispensing failure.
                end            

            case block_codes.POSITION_START_X                               %Positioner starting x-value.
                data = Check_Field_Name(data,'pos','start');                %Call the subfunction to check for existing fieldnames.
                i = fread(fid,1,'uint8');                                   %Read in the module index.
                data.pos(i).start = [fread(fid,1,'float32'), NaN, NaN];     %Save the starting positioner x-value as a float32 value.            

            case block_codes.POSITION_MOVE_X                                %Movement of a positioner in the x-direction.
                data = Check_Field_Name(data,'pos','move');                 %Call the subfunction to check for existing fieldnames.
                i = fread(fid,1,'uint8');                                   %Read in the module index.
                j = size(data.pos(i).move, 1) + 1;                          %Find a new row index in the positioner movement matrix.
                data.pos(i).move(j,:) = nan(1,4);                           %Add 4 NaNs to a new row in the movement matrix.            
                data.pos(i).move(j,1) = fread(fid,1,'uint32');              %Save the millisecond clock timestamp for the movement.
                data.pos(i).move(j,2) = fread(fid,1,'float32');             %Save the new positioner x-value as a float32 value.      

            case block_codes.POSITION_START_XY              
                data = Check_Field_Name(data,'pos','start');                %Call the subfunction to check for existing fieldnames.
                i = fread(fid,1,'uint8');                                   %Read in the module index.
                data.pos(i).start = [fread(fid,2,'float32'), NaN];          %Save the starting positioner x- and y-value as a float32 value.    

                fprintf(1,'Need to finish coding for block: POSITION_START_XY\n');

            case block_codes.POSITION_MOVE_XY                       
                fprintf(1,'Need to finish coding for block: POSITION_MOVE_XY\n');

            case block_codes.STREAM_INPUT_NAME                       
                fprintf(1,'Need to finish coding for block: STREAM_INPUT_NAME\n');

            case block_codes.CALIBRATION_BASELINE                               %Baseline coefficient of the calibration function.
                data = Check_Field_Name(data,'calibration',[]);                 %Call the subfunction to check for existing fieldnames.
                i = fread(fid,1,'uint8');                                       %Read in the module index.
                data.calibration(i).baseline = fread(fid,1,'float32');          %Save the calibration baseline coefficient.

            case block_codes.CALIBRATION_SLOPE                                  %Slope coefficient of the calibration function.
                data = Check_Field_Name(data,'calibration',[]);                 %Call the subfunction to check for existing fieldnames.
                i = fread(fid,1,'uint8');                                       %Read in the module index.
                data.calibration(i).slope = fread(fid,1,'float32');             %Save the calibration baseline coefficient.

            case block_codes.CALIBRATION_BASELINE_ADJUST                       
                fprintf(1,'Need to finish coding for block: CALIBRATION_BASELINE_ADJUST\n');

            case block_codes.CALIBRATION_SLOPE_ADJUST                       
                fprintf(1,'Need to finish coding for block: CALIBRATION_SLOPE_ADJUST\n');

            case block_codes.HIT_THRESH_TYPE                         
                data = Check_Field_Name(data,'hit_thresh_type',[]);             %Call the subfunction to check for existing fieldnames.
                i = fread(fid,1,'uint8');                                       %Read in the signal index.
                if isempty(data.hit_thresh_type)                                %If there's no hit threshold type yet set...
                    data.hit_thresh_type = cell(i,1);                           %Create a cell array to hold the threshold types.
                end
                N = fread(fid,1,'uint16');                                      %Read in the number of characters.
                data.hit_thresh_type{i} = fread(fid,N,'*char')';                %Read in the characters of the user's experiment name.

            case block_codes.SECONDARY_THRESH_NAME                         
                fprintf(1,'Need to finish coding for block: SECONDARY_THRESH_NAME\n');

            case block_codes.REMOTE_MANUAL_FEED                         
                data = Check_Field_Name(data,'pellet',...
                    {'time','num','source'});                               %Call the subfunction to check for existing fieldnames.
                i = fread(fid,1,'uint8');                                   %Read in the dispenser index.                
                j = size(data.pellet(i).time,1) + 1;                        %Find the next index for the pellet timestamp for this dispenser.
                data.pellet(i).time(j,1) = fread(fid,1,'uint32');           %Save the millisecond clock timestamp.
                data.pellet(i).num(j,1) = fread(fid,1,'uint16');            %Save the number of feedings.
                data.pellet(i).source{j,1} = 'manual_remote';               %Save the feed trigger source.   

            case block_codes.HWUI_MANUAL_FEED                               %Hardware interface-initiated feeding.
                data = Check_Field_Name(data,'pellet',...
                    {'time','num','source'});                               %Call the subfunction to check for existing fieldnames.
                i = fread(fid,1,'uint8');                                   %Read in the dispenser index.                
                j = size(data.pellet(i).time,1) + 1;                        %Find the next index for the pellet timestamp for this dispenser.
                data.pellet(i).time(j,1) = fread(fid,1,'uint32');           %Save the millisecond clock timestamp.
                data.pellet(i).num(j,1) = fread(fid,1,'uint16');            %Save the number of feedings.
                data.pellet(i).source{j,1} = 'manual_hardware';             %Save the feed trigger source.   

            case block_codes.FW_RANDOM_FEED                                 %Random feeding event.
                data = Check_Field_Name(data,'pellet',...
                    {'time','num','source'});                               %Call the subfunction to check for existing fieldnames.
                i = fread(fid,1,'uint8');                                   %Read in the dispenser index.                
                j = size(data.pellet(i).time,1) + 1;                        %Find the next index for the pellet timestamp for this dispenser.
                data.pellet(i).time(j,1) = fread(fid,1,'uint32');           %Save the millisecond clock timestamp.
                data.pellet(i).num(j,1) = fread(fid,1,'uint16');            %Save the number of feedings.
                data.pellet(i).source{j,1} = 'random_firmware';             %Save the feed trigger source.     
                
            case block_codes.SWUI_MANUAL_FEED_DEPRECATED                    %Software interface-initiated feeding.
                data = Check_Field_Name(data,'pellet',...
                    {'time','num','source'});                               %Call the subfunction to check for existing fieldnames.
                i = 1;                                                      %Read in the dispenser index.                
                j = size(data.pellet(i).time,1) + 1;                        %Find the next index for the pellet timestamp for this dispenser.
                data.pellet(i).time(j,1) = fread(fid,1,'float64');          %Save the millisecond clock timestamp.
                data.pellet(i).num(j,1) = fread(fid,1,'uint8');             %Save the number of feedings.
                data.pellet(i).source{j,1} = 'manual_software';             %Save the feed trigger source.
                
            case block_codes.FW_OPERANT_FEED                                %Operant behavior-triggered feeding.
                data = Check_Field_Name(data,'pellet',...
                    {'time','num','source'});                               %Call the subfunction to check for existing fieldnames.
                i = fread(fid,1,'uint8');                                   %Read in the dispenser index.                
                j = size(data.pellet(i).time,1) + 1;                        %Find the next index for the pellet timestamp for this dispenser.
                data.pellet(i).time(j,1) = fread(fid,1,'uint32');           %Save the millisecond clock timestamp.
                data.pellet(i).num(j,1) = fread(fid,1,'uint16');            %Save the number of feedings.
                data.pellet(i).source{j,1} = 'operant_firmware';            %Save the feed trigger source.      
                
            case block_codes.SWUI_MANUAL_FEED                               %Software interface-initiated feeding.
                data = Check_Field_Name(data,'pellet',...
                    {'time','num','source'});                               %Call the subfunction to check for existing fieldnames.
                i = fread(fid,1,'uint8');                                   %Read in the dispenser index.                
                j = size(data.pellet(i).time,1) + 1;                        %Find the next index for the pellet timestamp for this dispenser.
                data.pellet(i).time(j,1) = fread(fid,1,'float64');          %Save the millisecond clock timestamp.
                data.pellet(i).num(j,1) = fread(fid,1,'uint16');            %Save the number of feedings.
                data.pellet(i).source{j,1} = 'manual_software';             %Save the feed trigger source.  
                
            case block_codes.SW_RANDOM_FEED                                 %Software interface-initiated feeding.
                data = Check_Field_Name(data,'pellet',...
                    {'time','num','source'});                               %Call the subfunction to check for existing fieldnames.
                i = fread(fid,1,'uint8');                                   %Read in the dispenser index.                
                j = size(data.pellet(i).time,1) + 1;                        %Find the next index for the pellet timestamp for this dispenser.
                data.pellet(i).time(j,1) = fread(fid,1,'float64');          %Save the millisecond clock timestamp.
                data.pellet(i).num(j,1) = fread(fid,1,'uint16');            %Save the number of feedings.
                data.pellet(i).source{j,1} = 'random_software';             %Save the feed trigger source.   
                
            case block_codes.SW_OPERANT_FEED                                %Operant behavior-triggered feeding.
                data = Check_Field_Name(data,'pellet',...
                    {'time','num','source'});                               %Call the subfunction to check for existing fieldnames.
                i = fread(fid,1,'uint8');                                   %Read in the dispenser index.                
                j = size(data.pellet(i).time,1) + 1;                        %Find the next index for the pellet timestamp for this dispenser.
                data.pellet(i).time(j,1) = fread(fid,1,'float64');          %Save the millisecond clock timestamp.
                data.pellet(i).num(j,1) = fread(fid,1,'uint16');            %Save the number of feedings.
                data.pellet(i).source{j,1} = 'operant_software';            %Save the feed trigger source.   

            case block_codes.MOTOTRAK_V3P0_OUTCOME                 
                data = Check_Field_Name(data,'trial',[]);                       %Call the subfunction to check for existing fieldnames.
                t = fread(fid,1,'uint16');                                      %Read in the trial index.
                data.trial(t).start_time = fread(fid,1,'uint32');               %Save the millisecond clock timestamp for the trial start.
                data.trial(t).outcome = fread(fid,1,'*char');                   %Read in the character code for the outcome.
                pre_N = fread(fid,1,'uint16');                                  %Read in the number of pre-trial samples.
                hitwin_N = fread(fid,1,'uint16');                               %Read in the number of hit window samples.
                post_N = fread(fid,1,'uint16');                                 %Read in the number of post-trial samples.
                data.trial(t).N_samples = [pre_N, hitwin_N, post_N];            %Save the number of samples for each phase of the trial.
                data.trial(t).init_thresh = fread(fid,1,'float32');             %Read in the initiation threshold.
                data.trial(t).hit_thresh = fread(fid,1,'float32');              %Read in the hit threshold.
                N = fread(fid,1,'uint8');                                       %Read in the number of secondary hit thresholds.
                if N > 0                                                        %If there were any secondary hit thresholds...
                    data.trial(t).secondary_hit_thresh = ...
                        fread(fid,N,'float32')';                                %Read in each secondary hit threshold.
                end
                N = fread(fid,1,'uint8');                                       %Read in the number of hits.
                if N > 0                                                        %If there were any hits...
                    data.trial(t).hit_time = fread(fid,N,'uint32')';            %Read in each millisecond clock timestamp for each hit.
                end
                N = fread(fid,1,'uint8');                                       %Read in the number of output triggers.
                if N > 0                                                        %If there were any output triggers...
                    data.trial(t).trig_time = fread(fid,1,'uint32');            %Read in each millisecond clock timestamp for each output trigger.
                end
                num_signals = fread(fid,1,'uint8');                             %Read in the number of signal streams.
                if ~isfield(data.trial,'times')                                 %If the sample times field doesn't yet exist...
                    data.trial(t).times = nan(pre_N + hitwin_N + post_N,1); %Pre-allocate a matrix to hold sample times.
                end
                if ~isfield(data.trial,'signal')                            %If the signal matrix field doesn't yet exist...
                    data.trial(t).signal = ...
                        nan(pre_N + hitwin_N + post_N,3);                   %Pre-allocate a matrix to hold signal samples.
                end
                for i = 1:pre_N                                             %Step through the samples starting at the hit window.
                    data.trial(t).times(i) = fread(fid,1,'uint32');         %Save the millisecond clock timestamp for the sample.
                    data.trial(t).signal(i,:) = ...
                        fread(fid,num_signals,'int16');                     %Save the signal samples.
                end        

            case block_codes.MOTOTRAK_V3P0_SIGNAL                         
                data = Check_Field_Name(data,'trial',[]);                   %Call the subfunction to check for existing fieldnames.
                t = fread(fid,1,'uint16');                                  %Read in the trial index.
                num_signals = fread(fid,1,'uint8');                         %Read in the number of signal streams.
                pre_N = fread(fid,1,'uint16');                              %Read in the number of pre-trial samples.
                hitwin_N = fread(fid,1,'uint16');                           %Read in the number of hit window samples.
                post_N = fread(fid,1,'uint16');                             %Read in the number of post-trial samples.
                data.trial(t).N_samples = [pre_N, hitwin_N, post_N];        %Save the number of samples for each phase of the trial.
                data.trial(t).times = nan(pre_N + hitwin_N + post_N,1);     %Pre-allocate a matrix to hold sample times, in microseconds.
                data.trial(t).signal = nan(pre_N + hitwin_N + post_N,3);    %Pre-allocate a matrix to hold signal samples.
                for i = (pre_N + 1):(pre_N + hitwin_N + post_N)             %Step through the samples starting at the hit window.
                    data.trial(t).times(i) = fread(fid,1,'uint32');         %Save the microsecond clock timestamp for the sample.
                    data.trial(t).signal(i,:) = ...
                        fread(fid,num_signals,'int16');                     %Save the signal samples.
                end
                
            case block_codes.VIBRATION_TASK_TRIAL_OUTCOME                         
                data = Check_Field_Name(data,'trial',[]);                   %Call the subfunction to check for existing fieldnames.
                t = fread(fid,1,'uint16');                                  %Read in the trial index.
                data.trial(t).start_time = fread(fid,1,'float64');          %Read in the trial start time (serial date number).
                data.trial(t).outcome = fread(fid,1,'*char');               %Read in the trial outcome.
                N = fread(fid,1,'uint8');                                   %Read in the number of feedings.
                data.trial(t).feed_time = fread(fid,N,'float64');           %Read in the feeding times.
                data.trial(t).hit_win = fread(fid,1,'float32');             %Read in the hit window.
                data.trial(t).vib_dur = fread(fid,1,'float32');             %Read in the vibration pulse duration.
                data.trial(t).vib_rate = fread(fid,1,'float32');            %Read in the vibration pulse rate.
                data.trial(t).actual_vib_rate = fread(fid,1,'float32');     %Read in the actual vibration pulse rate.
                data.trial(t).gap_length = fread(fid,1,'float32');          %Read in the gap length.
                data.trial(t).actual_gap_length = fread(fid,1,'float32');   %Read in the actual gap length.
                data.trial(t).hold_time = fread(fid,1,'float32');           %Read in the hold time.
                data.trial(t).time_held = fread(fid,1,'float32');           %Read in the time held.
                data.trial(t).vib_n = fread(fid,1,'uint16');                %Read in the number of vibration pulses.
                data.trial(t).gap_start = fread(fid,1,'uint16');            %Read in the number of vibration gap start index.
                data.trial(t).gap_stop = fread(fid,1,'uint16');             %Read in the number of vibration gap stop index.
                data.trial(t).debounce_samples = fread(fid,1,'uint16');     %Read in the number of debounce samples.
                data.trial(t).pre_samples = fread(fid,1,'uint32');          %Read in the number of pre-trial samples.
                num_signals = fread(fid,1,'uint8');                         %Read in the number of signal streams.
                N = fread(fid,1,'uint32');                                  %Read in the number of samples.
                data.trial(t).times = fread(fid,N,'uint32');                %Read in the millisecond clock timestampes.
                data.trial(t).signal = nan(N,num_signals);                  %Create a matrix to hold the sensor signals.
                for i = 1:num_signals                                       %Step through the signals.
                    data.trial(t).signal(:,i) = fread(fid,N,'float32');    %Read in each signal.
                end
                
            case block_codes.LED_DETECTION_TASK_TRIAL_OUTCOME                         
                data = Check_Field_Name(data,'trial',[]);                   %Call the subfunction to check for existing fieldnames.
                t = fread(fid,1,'uint16');                                  %Read in the trial index.
                data.trial(t).start_time = fread(fid,1,'float64');          %Read in the trial start time (serial date number).
                data.trial(t).start_millis = fread(fid,1,'uint32');         %Read in the trial start time (Arduino millisecond clock).
                data.trial(t).outcome = fread(fid,1,'*char');               %Read in the trial outcome.
                N = fread(fid,1,'uint8');                                   %Read in the number of feedings.
                data.trial(t).feed_time = fread(fid,N,'float64');           %Read in the feeding times.
                data.trial(t).hit_win = fread(fid,1,'float32');             %Read in the hit window.
                data.trial(t).ls_index = fread(fid,1,'uint8');              %Read in the light source index (1-8).
                data.trial(t).ls_pwm = fread(fid,1,'uint8');                %Read in the light source intensity (PWM).                
                data.trial(t).ls_dur = fread(fid,1,'float32');              %Read in the light stimulus duration.
                data.trial(t).hold_time = fread(fid,1,'float32');           %Read in the hold time.
                data.trial(t).time_held = fread(fid,1,'float32');           %Read in the time held.
                num_signals = fread(fid,1,'uint8');                         %Read in the number of signal streams.
                num_signals = 1;                                            %%<<REMOVE AFTER DEBUGGING.
                N = fread(fid,1,'uint32');                                  %Read in the number of samples.                
                data.trial(t).times = fread(fid,N,'uint32');                %Read in the millisecond clock timestampes.
                data.trial(t).signal = nan(N,num_signals);                  %Create a matrix to hold the sensor signals.
                data.trial(t).signal(:,1) = fread(fid,N,'uint16');          %Read in the nosepoke signal.
                for i = 2:num_signals                                       %Step through the non-nosepoke signals.
                    data.trial(t).signal(:,i) = fread(fid,N,'float32');     %Read in each non-nosepoke signal.
                end

            otherwise
                i = (block == f_values);                                    %Find the index for the matching block code.
                fprintf(1,'%s\n',f_names{i});                               %Print the block code name.

                fprintf(1,'UNRECOGNIZED BLOCK CODE: %1.0f!\n',block);       %Print the block code.
                fclose(fid);                                                %Close the file.
                return                                                      %Skip execution of the rest of the function.

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


%% This subfunction checks to see if field/subfield names already exist and creates them if they don't exit.
function data = Check_Field_Name(data,fieldname,subfieldname)
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