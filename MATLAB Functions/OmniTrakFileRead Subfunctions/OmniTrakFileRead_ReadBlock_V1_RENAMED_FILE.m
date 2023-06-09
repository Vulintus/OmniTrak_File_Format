function data = OmniTrakFileRead_ReadBlock_V1_RENAMED_FILE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		41
%		RENAMED_FILE

data = OmniTrakFileRead_Check_Field_Name(data,'file_info','rename');        %Call the subfunction to check for existing fieldnames.
i = length(data.file_info.rename) + 1;                                      %Find the next available index for a renaming event.
data.file_info.rename(i).time = fread(fid,1,'float64');                     %Read in the timestamp for the renaming.
N = fread(fid,1,'uint16');                                                  %Read in the number of characters in the old filename.
data.file_info.rename(i).old = char(fread(fid,N,'uchar')');                 %Read in the old filename.
N = fread(fid,1,'uint16');                                                  %Read in the number of characters in the new filename.
data.file_info.rename(i).new = char(fread(fid,N,'uchar')');                 %Read in the new filename.     