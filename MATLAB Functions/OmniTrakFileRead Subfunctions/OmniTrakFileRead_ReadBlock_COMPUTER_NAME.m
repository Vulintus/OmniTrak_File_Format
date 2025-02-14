function data = OmniTrakFileRead_ReadBlock_COMPUTER_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		106
%		COMPUTER_NAME

data = OmniTrakFileRead_Check_Field_Name(data,'device','computer');         %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device.computer = char(fread(fid,N,'uchar')');                         %Read in the computer name.