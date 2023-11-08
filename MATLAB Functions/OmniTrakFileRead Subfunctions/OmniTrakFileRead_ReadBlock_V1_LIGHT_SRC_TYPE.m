function data = OmniTrakFileRead_ReadBlock_V1_LIGHT_SRC_TYPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2712
%		LIGHT_SRC_TYPE

data = OmniTrakFileRead_Check_Field_Name(data,'light_src','chan');          %Call the subfunction to check for existing fieldnames.
module_i = fread(fid,1,'uint8');                                            %Read in the module index.
ls_i = fread(fid,1,'uint16');                                               %Read in the light source channel index.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters in the light source type.
data.light_src(module_i).chan(ls_i).type = fread(fid,N,'*char')';           %Read in the characters of the light source type.