function OmniTrakFileWrite_WriteBlock_Short_Character_Block(fid, block_code, varargin)

%
% OmniTrakFileWrite_WriteBlock_Short_Character_Block.m
% 
%   copyright 2024, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_SHORT_CHARACTER_BLOCK adds the
%   specified character block to an *.OmniTrak data file, with a maximum
%   character count of 255.
%   
%   UPDATE LOG:
%   2024-04-23 - Drew Sloan - Function first created.
%   2025-06-18 - Drew Sloan - Added variable input arguments to allow for
%                             indices preceding the characters.
%

fwrite(fid,block_code,'uint16');                                            %OmniTrak file format block code.
for i = 1:length(varargin)                                                  %Step through all input arguments.
    if isscalar(varargin{i}) && varargin{i} >= 0 && varargin{i} <= 255      %If the argument is scalar...
        fwrite(fid, varargin{i}, 'uint8');                                  %Write the value as a byte.
    elseif ischar(varargin{i})                                              %If the argument is a character array.
        fwrite(fid,length(varargin{i}),'uint8');                            %Number of characters in the specified string.
        fwrite(fid,varargin{i},'uchar');                                    %Characters of the string.
    end
end