function data = OmniTrakFileRead_ReadBlock_SWUI_MANUAL_FEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2405
%		SWUI_MANUAL_FEED

data = OmniTrakFileRead_Check_Field_Name(data,'feed',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.
if length(data.feed) < i                                                    %If the structure doesn't yet have this dispenser index...
    for j = (length(data.feed)+1):i                                         %Step through each missing index.
        data.feed(i) = struct('time',[],'num',[],'source',[]);              %Add new indices to the structure.
    end 
end
j = size(data.feed(i).time,1) + 1;                                          %Find the next index for the feed timestamp for this dispenser.
if j == 1                                                                   %If this is the first manual feeding...
    data.feed(i).time = fread(fid,1,'float64');                             %Save the millisecond clock timestamp.
    data.feed(i).num = fread(fid,1,'uint16');                               %Save the number of feedings.
    data.feed(i).source = {'manual_software'};                              %Save the feed trigger source.  
else                                                                        %Otherwise, if this isn't the first manual feeding...
    data.feed(i).time(j,1) = fread(fid,1,'float64');                        %Save the millisecond clock timestamp.
    data.feed(i).num(j,1) = fread(fid,1,'uint16');                          %Save the number of feedings.
    data.feed(i).source{j,1} = 'manual_software';                           %Save the feed trigger source.
end