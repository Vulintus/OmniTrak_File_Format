function data = OmniTrakFileRead_ReadBlock_V1_ALSPT19_LIGHT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1600
%		ALSPT19_LIGHT

if ~isfield(data,'amb')                                                     %If the structure doesn't yet have an "amb" field..
    data.amb = [];                                                          %Create the field.
end
i = length(data.amb) + 1;                                                   %Grab a new ambient light reading index.
data.amb(i).src = 'ALSPT19';                                                %Save the source of the ambient light reading.
data.amb(i).id = fread(fid,1,'uint8');                                      %Read in the ambient light sensor index (there may be multiple sensors).
data.amb(i).time = fread(fid,1,'uint32');                                   %Save the millisecond clock timestamp for the reading.
data.amb(i).int = fread(fid,1,'uint16');                                    %Save the ambient light reading as an unsigned 16-bit value.