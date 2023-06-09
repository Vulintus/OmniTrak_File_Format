function data = OmniTrakFileRead_ReadBlock_V1_DEVICE_RESET_COUNT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		140
%		DEVICE_RESET_COUNT

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
data.device.reset_count = fread(fid,1,'uint16');                            %Save the device's reset count for the file.