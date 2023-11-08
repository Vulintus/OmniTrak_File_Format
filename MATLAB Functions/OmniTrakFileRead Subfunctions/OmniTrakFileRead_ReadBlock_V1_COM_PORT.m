function data = OmniTrakFileRead_ReadBlock_V1_COM_PORT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		107
%		COM_PORT

data = OmniTrakFileRead_Check_Field_Name(data,'device','com_port');         %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device.com_port = char(fread(fid,N,'uchar')');                         %Read in the port name.