function data = OmniTrakFileRead_ReadBlock_V1_PRIMARY_MODULE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		110
%		PRIMARY_MODULE

data = OmniTrakFileRead_Check_Field_Name(data,'module',[]);                 %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.module.primary = fread(fid,N,'*char')';                                %Read in the characters of the primary module name.