function OmniTrakFileWrite_WriteBlock_DateTime_uint16(fid, block_code, uint16_val, varargin)

%
% OmniTrakFileWrite_WriteBlock_DateTime_uint16.m
% 
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_DATETIME_UINT16 write a block with a
%   uint16 value, preceded by a float64 serial date number, to an
%   *.OmniTram file.
%   
%   UPDATE LOG:
%   2025-02-10 - Drew Sloan - Function first created.
%

if isempty(varargin)                                                        %If there's no input arguments...
    timestamp = convertTo(datetime('now'),'datenum');                       %Grab the current serial date number.
else                                                                        %Otherwise...
    timestamp = varargin{1};                                                %Grab the specified serial date number.
end

fwrite(fid,block_code,'uint16');                                            %OmniTrak file format block code.
fwrite(fid,timestamp,'float64');                                            %Serial date number.
fwrite(fid,uint16_val,'uint16');                                            %uint16 value.