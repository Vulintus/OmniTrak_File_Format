function OmniTrakFileWrite_WriteBlock_V1_Timestamped_uint16(fid, block_code, uint16_val)

%
% OmniTrakFileWrite_WriteBlock_V1_Timestamped_uint16.m
% 
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_V1_TIMESTAMPED_UINT16 write a block with a
%   uint16 value, preceded by a float64 serial date number, to an
%   *.OmniTram file.
%   
%   UPDATE LOG:
%   2025-02-10 - Drew Sloan - Function first created.
%

fwrite(fid,block_code,'uint16');                                            %OmniTrak file format block code.
fwrite(fid,convertTo(datetime('now'),'datenum'),'float64');                 %Serial date number.
fwrite(fid,uint16_val,'uint16');                                            %uint16 value.