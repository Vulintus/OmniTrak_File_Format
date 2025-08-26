function data = OmniTrakFileRead_ReadBlock_SYSTEM_TYPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		100
%		SYSTEM_TYPE

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field.
    data.device = [];                                                       %Create the field.
end
data.device.type = fread(fid,1,'uint8');                                    %Save the device type value.