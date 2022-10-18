function data = OmniTrakFileRead_ReadBlock_V1_BATTERY_VOLTS(fid,data)

%	OmniTrak File Block Code (OFBC):
%		171
%		BATTERY_VOLTS

data = OmniTrakFileRead_Check_Field_Name(data,'bat','volt');                %Call the subfunction to check for existing fieldnames.         
j = length(data.bat.volt) + 1;                                              %Grab a new reading index.   
data.bat.volt(j).timestamp = readtime;                                      %Save the millisecond clock timestamp for the reading.
data.bat.volt(j).reading = double(fread(fid,1,'uint16'))/1000;              %Save the battery voltage, in volts.