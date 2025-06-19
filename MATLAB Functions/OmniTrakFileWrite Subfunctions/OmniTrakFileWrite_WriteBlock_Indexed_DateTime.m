function OmniTrakFileWrite_WriteBlock_Indexed_DateTime(fid, block_code, index, varargin)

%
% OmniTrakFileWrite_WriteBlock_Indexed_DateTime.m
% 
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_INDEXED_DATETIME writes a block to an
%   *.OmniTrak file, with a uint8 index preceding a float64 serial date
%   number.
%   
%   UPDATE LOG:
%   2025-06-18 - Drew Sloan - Function first created.
%

if isempty(varargin)                                                        %If there's no input arguments...
    timestamp = convertTo(datetime('now'),'datenum');                       %Grab the current serial date number.
else                                                                        %Otherwise...
    timestamp = convertTo(varargin{1},'datenum');                           %Grab the serial date number for the specified date/time.
end

fwrite(fid,block_code,'uint16');                                            %OmniTrak file format block code.
fwrite(fid,index,'uint8');                                                  %uint8 index.
fwrite(fid,timestamp,'float64');                                            %Serial date number.
