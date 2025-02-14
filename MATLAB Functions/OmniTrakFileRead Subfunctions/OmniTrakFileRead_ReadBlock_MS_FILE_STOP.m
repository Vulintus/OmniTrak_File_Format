function data = OmniTrakFileRead_ReadBlock_MS_FILE_STOP(fid,data)

%	OmniTrak File Block Code (OFBC):
%		3
%		MS_FILE_STOP

data = OmniTrakFileRead_Check_Field_Name(data,'file','stop','millis');      %Call the subfunction to check for existing fieldnames.   

data.file.stop.millis = fread(fid,1,'uint32');                              %Save the file stop 32-bit millisecond clock timestamp.