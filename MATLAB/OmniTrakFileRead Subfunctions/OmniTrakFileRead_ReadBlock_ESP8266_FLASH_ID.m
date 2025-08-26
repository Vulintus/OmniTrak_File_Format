function data = OmniTrakFileRead_ReadBlock_ESP8266_FLASH_ID(fid,data)

%	OmniTrak File Block Code (OFBC):
%		123
%		ESP8266_FLASH_ID

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
data.device.flash_id = fread(fid,1,'uint32');                               %Save the device's unique flash chip ID.