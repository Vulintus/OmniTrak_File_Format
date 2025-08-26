function data = OmniTrakFileRead_ReadBlock_SYSTEM_NAME(fid,data)

%
% OmniTrakFileRead_ReadBlock_SYSTEM_NAME.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_SYSTEM_NAME reads in the "SYSTEM_NAME" 
%   data block from an *.OmniTrak format file. This block is intended to 
%   contain the overall system name, not just the name of the primary
%   device or controller, written as characters.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x0065
%		DEFINITION:		SYSTEM_NAME
%		DESCRIPTION:	Vulintus system name.
%
%   UPDATE LOG:
%   ????-??-?? - Drew Sloan - Function first created.
%   2025-06-19 - Drew Sloan - Updated function description to match the
%                             "ReadBlock" documentation style.
%

data = OmniTrakFileRead_Check_Field_Name(data,'system','name');             %Call the subfunction to check for existing fieldnames.         

N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.system.name = fread(fid,N,'*char')';                                   %Read in the characters of the system name.