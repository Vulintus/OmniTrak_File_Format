function OmniTrakFileWrite_WriteBlock_V1_Timestamped_Event(fid, block_code, varargin)

%
% OmniTrakFileWrite_WriteBlock_V1_Timestamped_Event.m
% 
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_V1_TIMESTAMPED_EVENT writes a block with a
%   only a float64 serial date number, as an event timing marker, to an
%   *.OmniTrak file.
%   
%   UPDATE LOG:
%   2025-02-11 - Drew Sloan - Function first created.
%

if isempty(varargin)                                                        %If there's no input arguments...
    timestamp = convertTo(datetime('now'),'datenum');                       %Grab the current serial date number.
else                                                                        %Otherwise...
    timestamp = varargin{1};                                                %Grab the specified serial date number.
end
fwrite(fid,block_code,'uint16');                                            %OmniTrak file format block code.
fwrite(fid,timestamp,'float64');                                            %Serial date number.
fwrite(fid,uint16_val,'uint16');                                            %uint16 value.