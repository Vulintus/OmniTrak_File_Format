function data = OmniTrakFileRead_ReadBlock_CLOCK_FILE_STOP(fid,data)

%	OmniTrak File Block Code (OFBC):
%		7
%		CLOCK_FILE_STOP

data = OmniTrakFileRead_Check_Field_Name(data,'file','stop','datenum');     %Call the subfunction to check for existing fieldnames.
data.file.stop.datenum = fread(fid,1,'float64');                            %Save the file stop 32-bit millisecond clock timestamp.