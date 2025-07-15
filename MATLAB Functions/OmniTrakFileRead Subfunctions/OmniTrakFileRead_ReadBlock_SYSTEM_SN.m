function data = OmniTrakFileRead_ReadBlock_SYSTEM_SN(fid,data)

%
% OmniTrakFileRead_ReadBlock_SYSTEM_SN.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_SYSTEM_SN reads in the "SYSTEM_SN" data 
%   block from an *.OmniTrak format file. This block is intended to contain
%   the serial number of the primary device for the system collecting data,
%   written as characters.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x0068
%		DEFINITION:		SYSTEM_SN
%		DESCRIPTION:	System serial number, written as characters.
%
%   UPDATE LOG:
%   ????-??-?? - Drew Sloan - Function first created.
%   2025-07-02 - Drew Sloan - Updated function description to match the
%                             "ReadBlock" documentation style.
%


data = OmniTrakFileRead_Check_Field_Name(data,'system');                    %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.system.serial_num = char(fread(fid,N,'uchar')');                       %Read in the serial number.