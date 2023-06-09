function data = OmniTrakFileRead_ReadBlock_V1_AMG8833_THERM_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1101
%		AMG8833_THERM_FL

data = OmniTrakFileRead_Check_Field_Name(data,'temp');                      %Call the subfunction to check for existing fieldnames.
i = length(data.temp) + 1;                                                  %Grab a new temperature reading index.
data.temp(i).src = 'AMG8833';                                               %Save the source of the temperature reading.
data.temp(i).id = fread(fid,1,'uint8');                                     %Read in the AMG8833 sensor index (there may be multiple sensors).
data.temp(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.temp(i).float = fread(fid,1,'float32');                                %Save the temperature reading as a float32 value.