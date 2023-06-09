function data = OmniTrakFileRead_ReadBlock_V1_VL53L0X_DIST(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1300
%		VL53L0X_DIST

if ~isfield(data,'dist')                                                    %If the structure doesn't yet have a "dist" field..
    data.dist = [];                                                         %Create the field.
end
i = length(data.dist) + 1;                                                  %Grab a new distance reading index.
data.dist(i).src = 'VL53L0X';                                               %Save the source of the distance reading.
data.dist(i).id = fread(fid,1,'uint8');                                     %Read in the VL53L0X sensor index (there may be multiple sensors).
data.dist(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.dist(i).int = fread(fid,1,'uint16');                                   %Save the distance reading as an unsigned 16-bit value.   