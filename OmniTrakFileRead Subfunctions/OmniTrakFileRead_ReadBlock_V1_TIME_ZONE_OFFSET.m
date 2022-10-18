function data = OmniTrakFileRead_ReadBlock_V1_TIME_ZONE_OFFSET(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	25
%		DEFINITION:		TIME_ZONE_OFFSET
%		DESCRIPTION:	Computer clock time zone offset from UTC.       
%
% fwrite(fid,ofbc.TIME_ZONE_OFFSET,'uint16');                          
% dt = datenum(datetime('now','TimeZone','local')) - ...
%     datenum(datetime('now','TimeZone','UTC'));                         
% fwrite(fid,dt,'float64');    

data = OmniTrakFileRead_Check_Field_Name(data,'clock');                     %Call the subfunction to check for existing fieldnames.
data.clock(1).time_zone = fread(fid,1,'float64');                           %Read in the time zone adjustment relative to UTC.