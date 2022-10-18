function data = OmniTrakFileRead_ReadBlock_V1_BMP280_PRES_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1211
%		BMP280_PRES_FL

if ~isfield(data,'pres')                                                    %If the structure doesn't yet have a "pres" field..
    data.pres = [];                                                         %Create the field.
end
i = length(data.pres) + 1;                                                  %Grab a new pressure reading index.
data.pres(i).src = 'BME280';                                                %Save the source of the pressure reading.
data.pres(i).id = fread(fid,1,'uint8');                                     %Read in the BME280 sensor index (there may be multiple sensors).
data.pres(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.pres(i).float = fread(fid,1,'float32');                                %Save the pressure reading as a float32 value.