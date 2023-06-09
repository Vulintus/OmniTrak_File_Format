function data = OmniTrakFileRead_ReadBlock_V1_BME680_TEMP_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1202
%		BME680_TEMP_FL

data = OmniTrakFileRead_Check_Field_Name(data,'temp');                      %Call the subfunction to check for existing fieldnames.
i = length(data.temp) + 1;                                                  %Grab a new temperature reading index.
data.temp(i).src = 'BME68X';                                                %Save the source of the temperature reading.
data.temp(i).id = fread(fid,1,'uint8');                                     %Read in the BME680/688 sensor index (there may be multiple sensors).
data.temp(i).timestamp = fread(fid,1,'uint32');                             %Save the microcontroller millisecond clock timestamp for the reading.
data.temp(i).celsius = fread(fid,1,'float32');                              %Save the temperature reading as a float32 value.