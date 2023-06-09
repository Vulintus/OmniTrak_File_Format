function data = OmniTrakFileRead_ReadBlock_V1_BATTERY_POWER(fid,data)

%	OmniTrak File Block Code (OFBC):
%		175
%		BATTERY_POWER

data = OmniTrakFileRead_Check_Field_Name(data,'bat','pwr');                 %Call the subfunction to check for existing fieldnames.    
j = length(data.bat.pwr) + 1;                                               %Grab a new reading index.   
data.bat.pwr(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.pwr(j).reading = double(fread(fid,1,'int16'))/1000;                %Save the average power draw, in Watts.