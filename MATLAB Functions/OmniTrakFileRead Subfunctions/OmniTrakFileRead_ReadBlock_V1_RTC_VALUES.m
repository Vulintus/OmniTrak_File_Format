function data = OmniTrakFileRead_ReadBlock_V1_RTC_VALUES(fid,data)

%	OmniTrak File Block Code (OFBC):
%		32
%		RTC_VALUES

data = OmniTrakFileRead_Check_Field_Name(data,'clock');                     %Call the subfunction to check for existing fieldnames.    
i = length(data.clock) + 1;                                                 %Find the next available index for a new real-time clock synchronization.
data.clock(i).ms = fread(fid,1,'uint32');                                   %Save the 32-bit millisecond clock timestamp.
yr = fread(fid,1,'uint16');                                                 %Read in the year.
mo = fread(fid,1,'uint8');                                                  %Read in the month.
dy = fread(fid,1,'uint8');                                                  %Read in the day.
hr = fread(fid,1,'uint8');                                                  %Read in the hour.
mn = fread(fid,1,'uint8');                                                  %Read in the minute.
sc = fread(fid,1,'uint8');                                                  %Read in the second.            
data.clock(i).datenum = datenum(yr, mo, dy, hr, mn, sc);                    %Save the RTC time as a MATLAB serial date number.
data.clock(i).source = 'RTC';                                               %Indicate that the date/time source was a real-time clock.