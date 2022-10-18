function data = OmniTrakFileRead_ReadBlock_V1_PELLET_FAILURE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2001
%		PELLET_FAILURE

data = OmniTrakFileRead_Check_Field_Name(data,'pellet','fail');             %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.
if length(data.pellet) < i                                                  %If there's no entry yet for this dispenser...
    data.pellet(i).fail = fread(fid,1,'uint32');                            %Save the millisecond clock timestamp for the pellet dispensing failure.
else                                                                        %Otherwise, if there's an entry for this dispenser.
    j = size(data.pellet(i).fail,1) + 1;                                    %Find the next index for the pellet failure timestamp.
    data.pellet(i).fail(j) = fread(fid,1,'uint32');                         %Save the millisecond clock timestamp for the pellet dispensing failure.
end       