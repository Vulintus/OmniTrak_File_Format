function data = OmniTrakFileRead_ReadBlock_SW_OPERANT_FEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2407
%		SW_OPERANT_FEED

data = OmniTrakFileRead_Check_Field_Name(data,'pellet',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.                
j = size(data.pellet(i).time,1) + 1;                                        %Find the next index for the pellet timestamp for this dispenser.
data.pellet(i).time(j,1) = fread(fid,1,'float64');                          %Save the millisecond clock timestamp.
data.pellet(i).num(j,1) = fread(fid,1,'uint16');                            %Save the number of feedings.
data.pellet(i).source{j,1} = 'operant_software';                            %Save the feed trigger source.   