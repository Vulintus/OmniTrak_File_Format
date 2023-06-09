function data = OmniTrakFileRead_ReadBlock_V1_STAGE_DESCRIPTION(fid,data)

%	OmniTrak File Block Code (OFBC):
%		401
%		STAGE_DESCRIPTION

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.stage_description = fread(fid,N,'*char')';                             %Read in the characters of the behavioral session stage description.