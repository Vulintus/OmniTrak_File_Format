function data = OmniTrakFileRead_ReadBlock_V1_BME280_HUM_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1220
%		BME280_HUM_FL

if ~isfield(data,'hum')                                                     %If the structure doesn't yet have a "hum" field..
    data.hum = [];                                                          %Create the field.
end
i = length(data.hum) + 1;                                                   %Grab a new pressure reading index.
data.hum(i).src = 'BME280';                                                 %Save the source of the pressure reading.
data.hum(i).id = fread(fid,1,'uint8');                                      %Read in the BME280 sensor index (there may be multiple sensors).
data.hum(i).time = fread(fid,1,'uint32');                                   %Save the millisecond clock timestamp for the reading.
data.hum(i).float = fread(fid,1,'float32');                                 %Save the pressure reading as a float32 value.