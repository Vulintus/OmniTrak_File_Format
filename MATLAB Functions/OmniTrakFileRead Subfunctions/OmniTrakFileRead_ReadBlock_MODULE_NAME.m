function data =  OmniTrakFileRead_ReadBlock_MODULE_NAME(fid,data)

%
% OmniTrakFileRead_ReadBlock_MODULE_NAME.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_MODULE_NAME reads in the "MODULE_NAME" data
%   block from an *.OmniTrak format file. This block is intended to contain
%   the name of a connected module, as well as the module's port index.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x0093
%		DEFINITION:		MODULE_NAME
%		DESCRIPTION:	OTMP module name, written as characters.
%
%   UPDATE LOG:
%   2025-06-19 - Drew Sloan - Function first created.
%

data = OmniTrakFileRead_Check_Field_Name(data,'module',{'port','name'});  %Call the subfunction to check for existing fieldnames.         

port_i = fread(fid,1,'uint8');                                              %Read in the port index.
existing_ports = vertcat(data.module.port);                                 %Fetch all the port indices already loaded in the structure...
if isempty(existing_ports)                                                  %If this is the first module...
    i = 1;                                                                  %Set the index to 1.
else                                                                        %Otherwise...
    i = (port_i == existing_ports);                                         %Check for a match to an already-loaded module.
    if ~any(i)                                                              %If the port index doesn't match any existing modules...
        i = length(data.module) + 1;                                        %Increment the index.
    end
end

N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.module(i).name = fread(fid,N,'*char')';                                %Add the module name.
data.module(i).port = port_i;                                               %Add the port index.
