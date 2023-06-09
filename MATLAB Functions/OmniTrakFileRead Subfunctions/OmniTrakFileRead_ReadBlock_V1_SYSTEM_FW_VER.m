function data = OmniTrakFileRead_ReadBlock_V1_SYSTEM_FW_VER(fid,data)

%	OmniTrak File Block Code (OFBC):
%		103
%		SYSTEM_FW_VER

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device.fw_version = char(fread(fid,N,'uchar')');                       %Read in the firmware version.