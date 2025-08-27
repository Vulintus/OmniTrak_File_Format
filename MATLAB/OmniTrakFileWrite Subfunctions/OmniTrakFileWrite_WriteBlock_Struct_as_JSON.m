function OmniTrakFileWrite_WriteBlock_Struct_as_JSON(fid, block_code, varargin)

%
% OmniTrakFileWrite_WriteBlock_Struct_as_JSON
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_STRUCT_AS_JSON creates a block of
%   JSON-formatted text listing out all of the fields and values
%   from the passed structure. These type of blocks are  intended to be 
%   failsafes which can capture pertinent experimental parameters that 
%   might have been omitted from other data blocks.
%
%   UPDATE LOG:
%   2025-08-26 - Drew Sloan - Function first created.
%


data_struct = varargin{1};                                                  %The session class will be the first optional input argument.

data_block_version = 1;                                                     %Set the data block version.

fwrite(fid,block_code,'uint16');                                            %OmniTrak file format block code.
fwrite(fid,data_block_version,'uint8');                                     %Data block version.

txt = jsonencode(data_struct,PrettyPrint=true);                             %Convert the data to JSON-formatted text.
if any(txt == '\')                                                          %If there's any forward slashes...    
    txt = strrep(txt,'\','\\');                                             %Replace all single forward slashes with two slashes.
    i = strfind(txt,'\\\');                                                 %Look for any triple forward slashes...
    txt(i) = [];                                                            %Kick out the extra forward slashes.
end

fwrite(fid,length(txt),'uint32');                                           %Number of characters in the JSON-encoded text.
fwrite(fid,txt,'uchar');                                                    %Characters of the JSON-encoded text.