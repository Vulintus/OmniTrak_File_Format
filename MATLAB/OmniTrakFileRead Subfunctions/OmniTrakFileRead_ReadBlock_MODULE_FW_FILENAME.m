function data = OmniTrakFileRead_ReadBlock_MODULE_FW_FILENAME(fid,data)

%
% OmniTrakFileRead_ReadBlock_MODULE_FW_FILENAME.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OmniTrakFileRead_ReadBlock_MODULE_FW_FILENAME reads in the 
%   "MODULE_FW_FILENAME" data block from an *.OmniTrak format file. This 
%   block is intended to contain the firmware filename, written as 
%   characters, of a connected module, as well as the module's port index.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x0090
%		DEFINITION:		MODULE_FW_FILENAME
%		DESCRIPTION:	OTMP Module firmware filename, copied from the 
%                       macro, written as characters.
%
%   UPDATE LOG:
%   2025-06-19 - Drew Sloan - Function first created.
%

data = OmniTrakFileRead_Check_Field_Name(data,'device',...
    {'port','firmware'});                                                   %Call the subfunction to check for existing fieldnames.         

port_i = fread(fid,1,'uint8');                                              %Read in the port index.
existing_ports = vertcat(data.device.port);                                 %Fetch all the port indices already loaded in the structure...
if isempty(existing_ports)                                                  %If this is the first device...
    i = 1;                                                                  %Set the index to 1.
else                                                                        %Otherwise...
    i = (port_i == existing_ports);                                         %Check for a match to an already-loaded device.
    if ~any(i)                                                              %If the port index doesn't match any existing devices...
        i = length(data.device) + 1;                                        %Increment the index.
    end
end

N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device(i).firmware(1).filename = fread(fid,N,'*char')';                %Add the device firmware filename.
data.device(i).port = port_i;                                               %Add the port index.