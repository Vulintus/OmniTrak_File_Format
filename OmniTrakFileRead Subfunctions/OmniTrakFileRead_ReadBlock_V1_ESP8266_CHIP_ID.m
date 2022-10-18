function data = OmniTrakFileRead_ReadBlock_V1_ESP8266_CHIP_ID(fid,data)

%	OmniTrak File Block Code (OFBC):
%		122
%		ESP8266_CHIP_ID

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
data.device.chip_id = fread(fid,1,'uint32');                                %Save the device's unique chip ID.