function data = OmniTrakFileRead_ReadBlock_V1_CLOCK_FILE_START(fid,data)

%	OmniTrak File Block Code (OFBC):
%		6
%		CLOCK_FILE_START

data = OmniTrakFileRead_Check_Field_Name(data,'file_start',[]);             %Call the subfunction to check for existing fieldnames.    
data.file_start.datenum = fread(fid,1,'float64');                           %Save the file start 32-bit millisecond clock timestamp.