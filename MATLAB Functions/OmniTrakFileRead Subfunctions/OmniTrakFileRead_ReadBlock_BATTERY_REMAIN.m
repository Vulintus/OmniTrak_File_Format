function data = OmniTrakFileRead_ReadBlock_BATTERY_REMAIN(fid,data)

%	OmniTrak File Block Code (OFBC):
%		174
%		BATTERY_REMAIN

data = OmniTrakFileRead_Check_Field_Name(data,'bat','rem');                 %Call the subfunction to check for existing fieldnames.    
j = length(data.bat.rem) + 1;                                               %Grab a new reading index.   
data.bat.rem(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.rem(j).reading = double(fread(fid,1,'uint16'))/1000;               %Save the battery's remaining capacity, in amp-hours.