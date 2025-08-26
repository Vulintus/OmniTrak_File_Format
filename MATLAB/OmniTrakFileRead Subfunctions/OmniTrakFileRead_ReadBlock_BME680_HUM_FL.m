function data = OmniTrakFileRead_ReadBlock_BME680_HUM_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1221
%		DEFINITION:		BME680_HUM_FL
%		DESCRIPTION:	The current BME680 humidity reading as a converted float32 value, in percent (%).

data = OmniTrakFileRead_Check_Field_Name(data,'hum');                       %Call the subfunction to check for existing fieldnames.
i = length(data.hum) + 1;                                                   %Grab a new ambient humidity reading index.
data.hum(i).src = 'BME68X';                                                 %Save the source of the ambient humidity reading.
data.hum(i).id = fread(fid,1,'uint8');                                      %Read in the BME680/688 sensor index (there may be multiple sensors).
data.hum(i).timestamp = fread(fid,1,'uint32');                              %Save the microcontroller millisecond clock timestamp for the reading.
data.hum(i).percent = fread(fid,1,'float32');                               %Save the ambient humidity reading as a float32 value.