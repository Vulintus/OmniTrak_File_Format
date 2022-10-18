function data = OmniTrakFileRead_ReadBlock_V1_GROUP_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		201
%		GROUP_NAME

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.group = fread(fid,N,'*char')';                                         %Read in the characters of the group name.