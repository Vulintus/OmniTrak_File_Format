function data = OmniTrakFileRead_ReadBlock_COMPUTER_NAME(fid,data)

%
% OmniTrakFileRead_ReadBlock_COMPUTER_NAME.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_COMPUTER_NAME reads in the "COMPUTER_NAME" 
%   data block from an *.OmniTrak format file. This block is intended to 
%   contain the computer name set in Windows for the computer running the
%   data collection program, written as characters.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x006A
%		DEFINITION:		COMPUTER_NAME
%		DESCRIPTION:	Windows PC computer name.
%
%   UPDATE LOG:
%   ????-??-?? - Drew Sloan - Function first created.
%   2025-06-19 - Drew Sloan - Updated function description to match the
%                             "ReadBlock" documentation style.
%

data = OmniTrakFileRead_Check_Field_Name(data,'system','computer');         %Call the subfunction to check for existing fieldnames.

N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.system.computer = fread(fid,N,'*char')';                               %Read in the computer name.