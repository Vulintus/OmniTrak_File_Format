function data = OmniTrakFileRead_ReadBlock_V1_ZMOD4410_READING_INT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1704
%		ZMOD4410_READING_INT

data = OmniTrakFileRead_Check_Field_Name(data,'gas_adc');                   %Call the subfunction to check for existing fieldnames.
i = length(data.gas_adc) + 1;                                               %Grab a new TVOC reading index.
data.gas_adc(i).src = 'ZMOD4410';                                           %Save the source of the TVOC reading.
data.gas_adc(i).id = fread(fid,1,'uint8');                                  %Read in the SGP30 sensor index (there may be multiple sensors).
data.gas_adc(i).time = fread(fid,1,'uint32');                               %Save the millisecond clock timestamp for the reading.
data.gas_adc(i).int = fread(fid,1,'uint16');                                %Save the TVOC reading as an unsigned 16-bit value.