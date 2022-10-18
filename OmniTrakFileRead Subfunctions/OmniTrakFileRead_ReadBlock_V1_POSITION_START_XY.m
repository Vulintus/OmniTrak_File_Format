function data = OmniTrakFileRead_ReadBlock_V1_POSITION_START_XY(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2022
%		POSITION_START_XY

data = OmniTrakFileRead_Check_Field_Name(data,'pos','start');               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the module index.
data.pos(i).start = [fread(fid,2,'float32'), NaN];                          %Save the starting positioner x- and y-value as a float32 value.   