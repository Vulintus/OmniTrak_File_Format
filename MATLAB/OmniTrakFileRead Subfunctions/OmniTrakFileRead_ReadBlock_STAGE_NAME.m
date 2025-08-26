function data = OmniTrakFileRead_ReadBlock_STAGE_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		400
%		STAGE_NAME

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.stage.name = fread(fid,N,'*char')';                                    %Read in the characters of the behavioral session stage name.