function data = OmniTrakFileRead_ReadBlock_V1_SYSTEM_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		101
%		SYSTEM_NAME

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field.
    data.device = [];                                                       %Create the field.
end
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device.system_name = fread(fid,N,'*char')';                            %Read in the characters of the system name.