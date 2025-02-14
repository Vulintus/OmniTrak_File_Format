function data = OmniTrakFileRead_ReadBlock_TIME_ZONE_OFFSET_HHMM(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	26
%		DEFINITION:		TIME_ZONE_OFFSET_HHMM
%		DESCRIPTION:	Computer clock time zone offset from UTC as two integers, one for hours, and the other for minutes


data = OmniTrakFileRead_Check_Field_Name(data,'clock');                     %Call the subfunction to check for existing fieldnames.    
i = length(data.clock) + 1;                                                 %Find the next available index for a new real-time clock synchronization.
hr = fread(fid,1,'int8');                                                   %Read in the hour of the time zone offset.
min = fread(fid,1,'uint8');                                                 %Read in the minutes of the time zone offset.
if hr < 0                                                                   %If the time zone offset is less than one.
    data.clock(i).time_zone = double(hr) - double(min)/60;                  %Save the time zone offset in fractional hours.
else                                                                        %Otherwise...
    data.clock(i).time_zone = double(hr) + double(min)/60;                  %Save the time zone offset in fractional hours.
end