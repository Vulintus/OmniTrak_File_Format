function data = OmniTrakFileRead_ReadBlock_V1_BATTERY_SOH(fid,data)

%	OmniTrak File Block Code (OFBC):
%		176
%		BATTERY_SOH

data = OmniTrakFileRead_Check_Field_Name(data,'bat','sof');                 %Call the subfunction to check for existing fieldnames.    
j = length(data.bat.soh) + 1;                                               %Grab a new reading index.   
data.bat.soh(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.soh(j).reading = fread(fid,1,'int16');                             %Save the state-of-health reading, in percent.