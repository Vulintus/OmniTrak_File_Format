function data = OmniTrakFileRead_ReadBlock_CLOCK_FILE_START(fid,data)

%	OmniTrak File Block Code (OFBC):
%		6
%		CLOCK_FILE_START

data = OmniTrakFileRead_Check_Field_Name(data,'file','start','datenum');    %Call the subfunction to check for existing fieldnames.    
data.file.start.datenum = fread(fid,1,'float64');                           %Save the file start 32-bit millisecond clock timestamp.