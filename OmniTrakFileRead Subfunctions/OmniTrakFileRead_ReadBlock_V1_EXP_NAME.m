function data = OmniTrakFileRead_ReadBlock_V1_EXP_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		300
%		EXP_NAME

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.exp_name = fread(fid,N,'*char')';                                      %Read in the characters of the user's experiment name.