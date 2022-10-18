function data = OmniTrakFileRead_ReadBlock_V1_CTRL_FW_FILENAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	141
%		DEFINITION:		CTRL_FW_FILENAME
%		DESCRIPTION:	Controller firmware filename, copied from the macro, written as characters.
%
% fwrite(fid,ofbc.CTRL_FW_FILENAME,'uint16');  
% fwrite(fid,length(str),'uint8');                
% fwrite(fid,str,'uchar');                                   

data = OmniTrakFileRead_Check_Field_Name(data,'device','controller',...
    'firmware','filename');                                                 %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device.controller.firmware.filename = char(fread(fid,N,'uchar')');     %Read in the firmware filename.