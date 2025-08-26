function OmniTrakFileWrite_WriteBlock_CAPSENSE_VALUE(fid, block_code, micros, index, value, num_sensors, bitmask)

%
% OmniTrakFileWrite_WriteBlock_CAPSENSE_VALUE.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_CAPSENSE_VALUE writes the capacitive 
%   sensor reading for one capacitive sensor, in ADC ticks or clock cycles,
%   with the microcontroller microsecond and computer serial date number 
%   timestamps.
%   
%   UPDATE LOG:
%   2025-06-04 - Drew Sloan - Function first created, adapted from
%                             "OmniTrakFileWrite_WriteBlock_Byte_Bitmask".
%

data_block_version = 1;                                                     %POKE_STATUS block version.

fwrite(fid, block_code, 'uint16');                                          %OmniTrak file format block code.
fwrite(fid, data_block_version, 'uint8');                                   %Data block version.

fwrite(fid, now, 'float64');                                                %#ok<TNOW1> %Serial date number.
fwrite(fid, micros, 'float32');                                             %Microcontroller microsecond clock timestamp.

fwrite(fid, num_sensors, 'uint8');                                          %Number of sensors.
fwrite(fid, bitmask, 'uint8');                                              %Nosepoke status bitmask.

fwrite(fid, index, 'uint8');                                                %Sensor index.
fwrite(fid, value, 'uint16');                                               %Capacitive sensor value.

