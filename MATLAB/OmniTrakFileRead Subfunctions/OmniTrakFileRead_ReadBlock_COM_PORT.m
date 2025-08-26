function data = OmniTrakFileRead_ReadBlock_COM_PORT(fid,data)

%
% OmniTrakFileRead_ReadBlock_COM_PORT.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_COM_PORT reads in the "COM_PORT" data block
%   from an *.OmniTrak format file. This block is intended to contain the
%   the USB COM port name for the wired USB connection between the Vulintus
%   system and the computer running the data collection program, written as
%   characters.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x006B
%		DEFINITION:		COM_PORT
%		DESCRIPTION:	The COM port of a computer-connected system.
%
%   UPDATE LOG:
%   ????-??-?? - Drew Sloan - Function first created.
%   2025-06-19 - Drew Sloan - Updated function description to match the
%                             "ReadBlock" documentation style.
%

data = OmniTrakFileRead_Check_Field_Name(data,'system','com_port');         %Call the subfunction to check for existing fieldnames.

N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.system.com_port = char(fread(fid,N,'uchar')');                         %Read in the port name.