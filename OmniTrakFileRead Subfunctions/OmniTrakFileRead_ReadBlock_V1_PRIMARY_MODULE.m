function data = OmniTrakFileRead_ReadBlock_V1_PRIMARY_MODULE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	110
%		DEFINITION:		PRIMARY_MODULE
%		DESCRIPTION:	Primary module name, for systems with interchangeable modules.
%
% str = handles.ctrl.module();
% fwrite(fid,ofbc.PRIMARY_MODULE,'uint16');
% fwrite(fid,length(str),'uint8');
% fwrite(fid,str,'uchar');

data = OmniTrakFileRead_Check_Field_Name(data,'module');                    %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.module(1).name = fread(fid,N,'*char')';                                %Read in the characters of the primary module name.