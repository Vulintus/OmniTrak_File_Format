function data = OmniTrakFileRead_ReadBlock_POSITION_START_X(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2020
%		POSITION_START_X

data = OmniTrakFileRead_Check_Field_Name(data,'pos','start');               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the module index.
data.pos(i).start = [fread(fid,1,'float32'), NaN, NaN];                     %Save the starting positioner x-value as a float32 value.   