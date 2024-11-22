function OmniTrakFileWrite_WriteBlock_V1_POKE_BITMASK(fid, block_code, micros, num_pokes, bitmask)

%
% OmniTrakFileWrite_WriteBlock_V1_POKE_BITMASK.m
%   
%   copyright 2024, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_V1_POKE_BITMASK writes the nosepokes'
%   status, as a bitmask, with the microcontroller microsecond and 
%   computer serial date number timestamps.
%   
%   UPDATE LOG:
%   2024-04-23 - Drew Sloan - Function first created.
%

data_block_version = 1;                                                     %POKE_STATUS block version.

fwrite(fid, block_code,'uint16');                                           %OmniTrak file format block code.
fwrite(fid,data_block_version,'uint8');                                     %Data block version.

fwrite(fid, now, 'float64');                                                %Serial date number.
fwrite(fid, micros, 'float32');                                             %Microcontroller microsecond clock timestamp.
fwrite(fid, num_pokes, 'uint8');                                            %Number of nosepokes.
fwrite(fid, bitmask, 'uint8');                                              %Nosepoke status bitmask.