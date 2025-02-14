function data = OmniTrakFileRead_ReadBlock_SYSTEM_HW_VER(fid,data)

%	OmniTrak File Block Code (OFBC):
%		102
%		SYSTEM_HW_VER

data = OmniTrakFileRead_Check_Field_Name(data,'device');                    %Call the subfunction to check for existing fieldnames.    
data.device.hw_version = fread(fid,1,'float32');                            %Save the device hardware version.