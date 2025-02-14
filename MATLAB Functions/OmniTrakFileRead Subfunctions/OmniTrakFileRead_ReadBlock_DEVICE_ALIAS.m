function data = OmniTrakFileRead_ReadBlock_DEVICE_ALIAS(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	108
%		DEFINITION:		DEVICE_ALIAS
%		DESCRIPTION:	Human-readable Adjective + Noun alias/name for the device, assigned by Vulintus during manufacturing

data = OmniTrakFileRead_Check_Field_Name(data,'device','alias');            %Call the subfunction to check for existing fieldnames.
nchar = fread(fid,1,'uint8');                                               %Read in the number of characters in the device alias.
data.device.alias = char(fread(fid,nchar,'uchar')');                        %Save the 32-bit SAMD chip ID.