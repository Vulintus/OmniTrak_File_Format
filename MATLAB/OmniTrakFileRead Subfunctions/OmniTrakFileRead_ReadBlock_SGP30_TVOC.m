function data = OmniTrakFileRead_ReadBlock_SGP30_TVOC(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1420
%		SGP30_TVOC

if ~isfield(data,'tvoc')                                                    %If the structure doesn't yet have a "tvoc" field..
    data.tvoc = [];                                                         %Create the field.
end
i = length(data.tvoc) + 1;                                                  %Grab a new TVOC reading index.
data.tvoc(i).src = 'SGP30';                                                 %Save the source of the TVOC reading.
data.tvoc(i).id = fread(fid,1,'uint8');                                     %Read in the SGP30 sensor index (there may be multiple sensors).
data.tvoc(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.tvoc(i).int = fread(fid,1,'uint16');                                   %Save the TVOC reading as an unsigned 16-bit value.