function OmniTrakFileWrite_WriteBlock_V1_SW_OPERANT_FEED(fid, block_code, feeder_index)

%
%OmniTrakFileWrite_WriteBlock_V1_SW_OPERANT_FEED.m - Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_V1_SW_OPERANT_FEED adds the time zone
%   offset, in units of days, between the local computer's time zone and
%   UTC time.
%   
%   UPDATE LOG:
%   2024-04-23 - Drew Sloan - Function first created.
%

fwrite(fid,block_code,'uint16');                                            %OmniTrak file format block code.
fwrite(fid, feeder_index, 'uint8');                                         %Write the dispenser index to the file.
fwrite(fid, now, 'float64');                                                %Write the serial date number to the file as a 64-bit floating point.
fwrite(fid, 1, 'uint16');                                                   %Write the number of feedings to the file.