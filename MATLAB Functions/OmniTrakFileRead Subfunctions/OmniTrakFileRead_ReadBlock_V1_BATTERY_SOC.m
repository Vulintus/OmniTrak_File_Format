function data = OmniTrakFileRead_ReadBlock_V1_BATTERY_SOC(fid,data)

%	OmniTrak File Block Code (OFBC):
%		170
%		BATTERY_SOC

data = OmniTrakFileRead_Check_Field_Name(data,'bat','soc');                 %Call the subfunction to check for existing fieldnames.         
j = length(data.bat.soc) + 1;                                               %Grab a new reading index.   
data.bat.soc(j).timestamp = fread(fid,1,'uint32');                          %Save the millisecond clock timestamp for the reading.
data.bat.soc(j).percent = fread(fid,1,'uint16');                            %Save the state-of-charge reading, in percent.