function OmniTrakFileWrite_WriteBlock_Byte_Bitmask(fid, block_code, micros, num_sensors, bitmask)

%
% OmniTrakFileWrite_WriteBlock_Byte_Bitmask.m
%   
%   copyright 2024, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_BYTE_BITMASK writes the boolean status of
%   an array of sensors as a bitmask, with the microcontroller microsecond
%   and computer serial date number timestamps.
%   
%   UPDATE LOG:
%   2024-04-23 - Drew Sloan - Function first created.
%   2025-06-04 - Drew Sloan - Renamed from
%                             "OmniTrakFileWrite_WriteBlock_POKE_BITMASK"
%                             to 
%                             "OmniTrakFileWrite_WriteBlock_Byte_Bitmask".
%

data_block_version = 1;                                                     %POKE_STATUS block version.

fwrite(fid, block_code, 'uint16');                                          %OmniTrak file format block code.
fwrite(fid, data_block_version, 'uint8');                                   %Data block version.

fwrite(fid, now, 'float64');                                                %Serial date number.
fwrite(fid, micros, 'float32');                                             %Microcontroller microsecond clock timestamp.
fwrite(fid, num_sensors, 'uint8');                                          %Number of sensors.
fwrite(fid, bitmask, 'uint8');                                              %Sensor status bitmask.