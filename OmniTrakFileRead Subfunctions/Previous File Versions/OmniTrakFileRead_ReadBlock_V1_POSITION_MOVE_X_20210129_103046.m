function data = OmniTrakFileRead_ReadBlock_V1_POSITION_MOVE_X(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2021
%		POSITION_MOVE_X

data = OmniTrakFileRead_Check_Field_Name(data,'pos','move');                %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the module index.
j = size(data.pos(i).move, 1) + 1;                                          %Find a new row index in the positioner movement matrix.
data.pos(i).move(j,:) = nan(1,4);                                           %Add 4 NaNs to a new row in the movement matrix.            
data.pos(i).move(j,1) = fread(fid,1,'uint32');                              %Save the millisecond clock timestamp for the movement.
data.pos(i).move(j,2) = fread(fid,1,'float32');                             %Save the new positioner x-value as a float32 value.     