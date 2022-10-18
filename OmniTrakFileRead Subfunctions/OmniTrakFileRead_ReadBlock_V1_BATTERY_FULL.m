function data = OmniTrakFileRead_ReadBlock_V1_BATTERY_FULL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		173
%		BATTERY_FULL

data = OmniTrakFileRead_Check_Field_Name(data,'bat','full');                %Call the subfunction to check for existing fieldnames.    
j = length(data.bat.full) + 1;                                              %Grab a new reading index.   
data.bat.full(j).timestamp = readtime;                                      %Save the millisecond clock timestamp for the reading.
data.bat.full(j).reading = double(fread(fid,1,'uint16'))/1000;              %Save the battery's full capacity, in amp-hours.