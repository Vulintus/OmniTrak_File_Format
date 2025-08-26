function data = OmniTrakFileRead_ReadBlock_VL53L0X_FAIL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1301
%		VL53L0X_FAIL

if ~isfield(data,'dist')                                                    %If the structure doesn't yet have a "dist" field..
    data.dist = [];                                                         %Create the field.
end
i = length(data.dist) + 1;                                      %Grab a new distance reading index.
data.dist(i).src = 'SGP30';                                     %Save the source of the distance reading.
data.dist(i).id = fread(fid,1,'uint8');                         %Read in the VL53L0X sensor index (there may be multiple sensors).
data.dist(i).time = fread(fid,1,'uint32');                      %Save the millisecond clock timestamp for the reading.
data.dist(i).int = NaN;                                         %Save a NaN in place of a value to indicate a read failure.