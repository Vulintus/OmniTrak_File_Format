function data = OmniTrakFileRead_ReadBlock_MS_FILE_START(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2
%		MS_FILE_START

data = OmniTrakFileRead_Check_Field_Name(data,'file','start','millis');     %Call the subfunction to check for existing fieldnames.    

data.file.start.millis = fread(fid,1,'uint32');                             %Save the file start 32-bit millisecond clock timestamp.