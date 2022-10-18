function data = OmniTrakFileRead_ReadBlock_V1_MS_FILE_STOP(fid,data)

%	OmniTrak File Block Code (OFBC):
%		3
%		MS_FILE_STOP

data = OmniTrakFileRead_Check_Field_Name(data,'file_stop',[]);              %Call the subfunction to check for existing fieldnames.   
data.file_stop.ms = fread(fid,1,'uint32');                                  %Save the file stop 32-bit millisecond clock timestamp.