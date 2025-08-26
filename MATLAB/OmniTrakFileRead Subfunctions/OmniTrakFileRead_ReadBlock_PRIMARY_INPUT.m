function data = OmniTrakFileRead_ReadBlock_PRIMARY_INPUT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		111
%		PRIMARY_INPUT

data = OmniTrakFileRead_Check_Field_Name(data,'input');                     %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.input(1).primary = fread(fid,N,'*char')';                              %Read in the characters of the primary module name.