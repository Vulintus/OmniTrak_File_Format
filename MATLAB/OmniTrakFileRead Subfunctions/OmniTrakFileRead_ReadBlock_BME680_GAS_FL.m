function data = OmniTrakFileRead_ReadBlock_BME680_GAS_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1230
%		DEFINITION:		BME680_GAS_FL
%		DESCRIPTION:	The current BME680 gas resistance reading as a converted float32 value, in units of kOhms

data = OmniTrakFileRead_Check_Field_Name(data,'gas');                       %Call the subfunction to check for existing fieldnames.
i = length(data.gas) + 1;                                                   %Grab a new gas resistance reading index.
data.gas(i).src = 'BME68X';                                                 %Save the source of the gas resistance reading.
data.gas(i).id = fread(fid,1,'uint8');                                      %Read in the BME680/688 sensor index (there may be multiple sensors).
data.gas(i).timestamp = fread(fid,1,'uint32');                              %Save the microcontroller millisecond clock timestamp for the reading.
data.gas(i).kohms = fread(fid,1,'float32');                                 %Save the gas resistance reading as a float32 value.