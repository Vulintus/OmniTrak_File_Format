function data = OmniTrakFileRead_ReadBlock_V1_BME680_PRES_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1212
%		BME680_PRES_FL

data = OmniTrakFileRead_Check_Field_Name(data,'pres');                      %Call the subfunction to check for existing fieldnames.
i = length(data.pres) + 1;                                                  %Grab a new ambient pressure reading index.
data.pres(i).src = 'BME68X';                                                %Save the source of the ambient pressure reading.
data.pres(i).id = fread(fid,1,'uint8');                                     %Read in the BME680/688 sensor index (there may be multiple sensors).
data.pres(i).timestamp = fread(fid,1,'uint32');                             %Save the microcontroller millisecond clock timestamp for the reading.
data.pres(i).pascals = fread(fid,1,'float32');                              %Save the ambient pressure reading as a float32 value.