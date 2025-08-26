function data = OmniTrakFileRead_ReadBlock_SYSTEM_FW_VER(fid,data)

%
% OmniTrakFileRead_ReadBlock_SYSTEM_SN.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_SYSTEM_SN reads in the "SYSTEM_FW_VER" data 
%   block from an *.OmniTrak format file. This block is intended to contain
%   the firmware version for the primary device for the system collecting 
%   data, written as characters.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x0067
%		DEFINITION:		SYSTEM_SN
%		DESCRIPTION:	System firmware version, written as characters.
%
%   UPDATE LOG:
%   ????-??-?? - Drew Sloan - Function first created.
%   2025-07-02 - Drew Sloan - Updated function description to match the
%                             "ReadBlock" documentation style.
%


data = OmniTrakFileRead_Check_Field_Name(data,'system');                    %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.system.fw_version = char(fread(fid,N,'uchar')');                       %Read in the firmware version.