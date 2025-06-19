function data = OmniTrakFileRead_ReadBlock_DEVICE_ALIAS(fid,data)

%
% OmniTrakFileRead_ReadBlock_DEVICE_ALIAS.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_DEVICE_ALIAS reads in the "DEVICE_ALIAS" 
%   data block from an *.OmniTrak format file. This block is intended to 
%   contain a unique human-readable serial number, typically an
%   adjective + noun combination such as ArdentAardvark or MellowMuskrat,
%   for example, written as characters.
%
%   Note that this data block assumes the device alias is for the primary 
%   device or controller, and assigns a port index of zero. Device aliases 
%   for connected modules should be saved with the "MODULE_VULINTUS_ALIAS"
%   block.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x006C
%		DEFINITION:		DEVICE_ALIAS
%		DESCRIPTION:	Human-readable Adjective + Noun alias/name for the
%                       device, assigned by Vulintus during manufacturing.
%
%   UPDATE LOG:
%   ????-??-?? - Drew Sloan - Function first created.
%   2025-06-19 - Drew Sloan - Updated function description to match the
%                             "ReadBlock" documentation style.
%

data = OmniTrakFileRead_Check_Field_Name(data,'device',{'alias','port'});   %Call the subfunction to check for existing fieldnames.

port_i = 0;                                                                 %Set the port index.

existing_ports = vertcat(data.device.port);                                 %Fetch all the port indices already loaded in the structure...
if isempty(existing_ports)                                                  %If this is the first module...
    i = 1;                                                                  %Set the index to 1.
else                                                                        %Otherwise...
    i = (port_i == existing_ports);                                         %Check for a match to an already-loaded module.
    if ~any(i)                                                              %If the port index doesn't match any existing modules...
        i = length(data.device) + 1;                                        %Increment the index.
    end
end

N = fread(fid,1,'uint8');                                                   %Read in the number of characters in the device alias.
data.device(i).alias = fread(fid,N,'*char')';                               %Save the 32-bit SAMD chip ID.
data.device(i).port = port_i;                                               %Add the port index.