function data = OmniTrakFileRead_ReadBlock_SAMD_CHIP_ID(fid,data)

%	OmniTrak File Block Code (OFBC):
%		112
%		SAMD_CHIP_ID

data = OmniTrakFileRead_Check_Field_Name(data,'device','samd_chip_id');     %Call the subfunction to check for existing fieldnames.    
data.device.samd_chip_id = fread(fid,4,'uint32');                           %Save the 32-bit SAMD chip ID.