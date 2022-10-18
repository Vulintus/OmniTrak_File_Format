function data = OmniTrakFileRead_ReadBlock_V1_SYSTEM_HW_VER(fid,data)

%	OmniTrak File Block Code (OFBC):
%		102
%		SYSTEM_HW_VER

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field.
    data.device = [];                                                       %Create the field.
end
data.device.hw_version = fread(fid,1,'float32');                            %Save the device hardware version.