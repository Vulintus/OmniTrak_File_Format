function OmniTrakFileWrite_WriteBlock_uClock_uint16(fid, block_code, clocktime, uint16_val)

%
% OmniTrakFileWrite_WriteBlock_uClock_uint16.m
% 
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_UCLOCK_UINT16 writes a block with a
%   uint16 value, preceded by a uint32 microcontroller clock value, to an
%   *.OmniTrak file.
%   
%   UPDATE LOG:
%   2025-06-18 - Drew Sloan - Function first created.
%

fwrite(fid,block_code,'uint16');                                            %OmniTrak file format block code.
fwrite(fid,clocktime,'uint32');                                             %Microcontroller time, typically millis() or micros().
fwrite(fid,uint16_val,'uint16');                                            %uint16 value.