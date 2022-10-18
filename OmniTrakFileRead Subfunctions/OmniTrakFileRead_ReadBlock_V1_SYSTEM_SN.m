function data = OmniTrakFileRead_ReadBlock_V1_SYSTEM_SN(fid,data)

%	OmniTrak File Block Code (OFBC):
%		104
%		SYSTEM_SN

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field.
    data.device = [];                                                       %Create the field.
end
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device.serial_num = char(fread(fid,N,'uchar')');                       %Read in the serial number.