function data = OmniTrakFileRead_ReadBlock_SGP30_EC02(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1410
%		SGP30_EC02

if ~isfield(data,'eco2')                                                    %If the structure doesn't yet have a "eco2" field..
    data.eco2 = [];                                                         %Create the field.
end
i = length(data.eco2) + 1;                                                  %Grab a new eCO2 reading index.
data.eco2(i).src = 'SGP30';                                                 %Save the source of the eCO2 reading.
data.eco2(i).id = fread(fid,1,'uint8');                                     %Read in the SGP30 sensor index (there may be multiple sensors).
data.eco2(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.eco2(i).int = fread(fid,1,'uint16');                                   %Save the eCO2 reading as an unsigned 16-bit value.