function data = OmniTrakFileRead_ReadBlock_SWUI_MANUAL_FEED_DEPRECATED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2403
%		SWUI_MANUAL_FEED_DEPRECATED

data = OmniTrakFileRead_Check_Field_Name(data,'pellet',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = 1;                                                                      %Read in the dispenser index.                
j = size(data.pellet(i).time,1) + 1;                                        %Find the next index for the pellet timestamp for this dispenser.
data.pellet(i).time(j,1) = fread(fid,1,'float64');                          %Save the millisecond clock timestamp.
data.pellet(i).num(j,1) = fread(fid,1,'uint8');                             %Save the number of feedings.
data.pellet(i).source{j,1} = 'manual_software';                             %Save the feed trigger source.