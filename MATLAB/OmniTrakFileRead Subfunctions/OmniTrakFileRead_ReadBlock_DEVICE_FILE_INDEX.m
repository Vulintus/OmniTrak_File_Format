function data = OmniTrakFileRead_ReadBlock_DEVICE_FILE_INDEX(fid,data)

%	OmniTrak File Block Code (OFBC):
%		10
%		DEVICE_FILE_INDEX

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
data.device.file_index = fread(fid,1,'uint32');                             %Save the 32-bit integer file index.