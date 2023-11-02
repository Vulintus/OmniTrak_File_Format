function data = OmniTrakFileRead_ReadBlock_V1_HWUI_MANUAL_FEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2401
%		HWUI_MANUAL_FEED

data = OmniTrakFileRead_Check_Field_Name(data,'pellet',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.                
j = size(data.pellet(i).time,1) + 1;                                        %Find the next index for the pellet timestamp for this dispenser.
if j == 1                                                                   %If this is the first manual feeding...
    data.feed(i).time = fread(fid,1,'float64');                             %Save the millisecond clock timestamp.
    data.feed(i).num = fread(fid,1,'uint16');                               %Save the number of feedings.
    data.feed(i).source = {'manual_hardware'};                              %Save the feed trigger source.  
else                                                                        %Otherwise, if this isn't the first manual feeding...
    data.feed(i).time(j,1) = fread(fid,1,'float64');                        %Save the millisecond clock timestamp.
    data.feed(i).num(j,1) = fread(fid,1,'uint16');                          %Save the number of feedings.
    data.feed(i).source{j,1} = 'manual_hardware';                           %Save the feed trigger source.
end