function data = OmniTrakFileRead_ReadBlock_V1_BMP280_TEMP_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1201
%		BMP280_TEMP_FL

if ~isfield(data,'temp')                                                    %If the structure doesn't yet have a "temp" field..
    data.temp = [];                                                         %Create the field.
end
i = length(data.temp) + 1;                                                  %Grab a new temperature reading index.
data.temp(i).src = 'BMP280';                                                %Save the source of the temperature reading.
data.temp(i).id = fread(fid,1,'uint8');                                     %Read in the BMP280 sensor index (there may be multiple sensors).
data.temp(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.temp(i).float = fread(fid,1,'float32');                                %Save the temperature reading as a float32 value.