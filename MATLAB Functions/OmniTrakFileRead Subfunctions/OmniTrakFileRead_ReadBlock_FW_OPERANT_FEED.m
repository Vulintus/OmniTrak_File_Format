function data = OmniTrakFileRead_ReadBlock_FW_OPERANT_FEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2404
%		FW_OPERANT_FEED

data = OmniTrakFileRead_Check_Field_Name(data,'pellet',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.                
j = size(data.pellet(i).time,1) + 1;                                        %Find the next index for the pellet timestamp for this dispenser.
data.pellet(i).time(j,1) = fread(fid,1,'uint32');                           %Save the millisecond clock timestamp.
data.pellet(i).num(j,1) = fread(fid,1,'uint16');                            %Save the number of feedings.
data.pellet(i).source{j,1} = 'operant_firmware';                            %Save the feed trigger source.  