function data =  OmniTrakFileRead_ReadBlock_CAPSENSE_VALUE(fid,data)

%
% OmniTrakFileRead_ReadBlock_CAPSENSE_VALUE.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_CAPSENSE_VALUE reads the values from a
%   "CAPSENSE_VALUE" data block in a Vulintus *.OmniTrak format file and
%   adds them to a data structure for analysis.
%
%   Data block value:       0x0A11
%   Data block name:        CAPSENSE_VALUE
%   Data block description: Capacitive sensor reading for one sensor, in 
%                           ADC ticks or clock cycles.
%
%   UPDATE LOG:
%   2025-06-05 - Drew Sloan - Function first created.
%


ver = fread(fid,1,'uint8');                                                 %#ok<NASGU> %Data block version.

data = OmniTrakFileRead_Check_Field_Name(data,'capsense',...
    {'datenum','micros','status','value'});                                 %Call the subfunction to check for existing fieldnames.         
i = size(data.capsense.datenum,1) + 1;                                      %Find the next bitmask index.

if i == 1                                                                   %If this is the first bitmask reading...
    data.capsense.datenum = fread(fid,1,'float64');                         %Save the serial date number timestamp.
    data.capsense.micros = fread(fid,1,'float32');                          %Save the microcontroller microsecond timestamp.
else                                                                        %Otherwise...
    data.capsense.datenum(i,1) = fread(fid,1,'float64');                    %Save the serial date number timestamp.
    data.capsense.micros(i,1) = fread(fid,1,'float32');                     %Save the microcontroller microsecond timestamp.
end

num_sensors = fread(fid,1,'uint8');                                         %Read in the number of sensors.
capsense_mask = fread(fid,1,'uint8');                                       %Read in the sensor status bitmask.
capsense_status = bitget(capsense_mask,1:num_sensors);                      %Grab the status for each nosecapsense.
if i == 1                                                                   %If this is the first nosepoke event...
    data.capsense.status = capsense_status;                                 %Create the status matrix.
else                                                                        %Otherwise...
    data.capsense.status(i,:) = capsense_status;                            %Add the new status to the matrix.
end

sensor_index = fread(fid,1,'uint8');                                        %Read the sensor index.
sensor_val = fread(fid,1,'uint16');                                         %Read the sensor value.
j = size(data.capsense.value,1) + 1;                                        %Find the next value index.
if j == 1                                                                   %If this is the first value reading...
    data.capsense.status = [sensor_index, sensor_val, i];                   %Create the status matrix.
else                                                                        %Otherwise...
    data.capsense.status(j,:) = [sensor_index, sensor_val, i];              %Add the new status to the matrix.
end
