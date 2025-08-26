function data = OmniTrakFileRead_ReadBlock_BH1749_RGB(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1120
%		BH1749_RGB

data = OmniTrakFileRead_Check_Field_Name(data,'light');                     %Call the subfunction to check for existing fieldnames.
i = length(data.light) + 1;                                                 %Grab a new ambient light reading index.
data.light(i).src = 'BH1749';                                               %Save the source of the ambient light reading.
data.light(i).id = fread(fid,1,'uint8');                                    %Read in the BME680/688 sensor index (there may be multiple sensors).
data.light(i).timestamp = fread(fid,1,'uint32');                            %Save the microcontroller millisecond clock timestamp for the reading.
data.light(i).rgb = fread(fid,3,'uint16');                                  %Save the primary RGB ADC readings as uint16 values.
data.light(i).nir = fread(fid,1,'uint16');                                  %Save the near-infrared (NIR) ADC reading as a uint16 value.
data.light(i).grn2 = fread(fid,1,'uint16');                                 %Save the secondary Green-2 ADC reading as a uint16 value.