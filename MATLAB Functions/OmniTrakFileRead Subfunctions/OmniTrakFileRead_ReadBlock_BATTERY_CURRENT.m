function data = OmniTrakFileRead_ReadBlock_BATTERY_CURRENT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		172
%		BATTERY_CURRENT

data = OmniTrakFileRead_Check_Field_Name(data,'bat','cur');                 %Call the subfunction to check for existing fieldnames.         
j = length(data.bat.current) + 1;                                           %Grab a new reading index.   
data.bat.cur(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.cur(j).reading = double(fread(fid,1,'int16'))/1000;                %Save the average current draw, in amps.