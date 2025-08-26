function data = OmniTrakFileRead_ReadBlock_HTPA32X32_AMBIENT_TEMP(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1115
%		DEFINITION:		HTPA32X32_AMBIENT_TEMP
%		DESCRIPTION:	The current ambient temperature measured by the HTPA32x32, represented as a 32-bit float, in units of Celcius.


data = OmniTrakFileRead_Check_Field_Name(data,'temp');                      %Call the subfunction to check for existing fieldnames.
i = length(data.temp) + 1;                                                  %Grab a new temperature reading index.
data.temp(i).src = 'HTPA32x32';                                             %Save the source of the temperature reading.
data.temp(i).id = fread(fid,1,'uint8');                                     %Read in the HTPA sensor index (there may be multiple sensors).
data.temp(i).timestamp = fread(fid,1,'uint32');                             %Save the microcontroller millisecond clock timestamp for the reading.
data.temp(i).celsius = fread(fid,1,'float32');                              %Save the temperature reading as a float32 value.
