function data = OmniTrakFileRead_ReadBlock_V1_DOWNLOAD_SYSTEM(fid,data)

%	OmniTrak File Block Code (OFBC):
%		43
%		DOWNLOAD_SYSTEM

data = OmniTrakFileRead_Check_Field_Name(data,'file_info','download');      %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.file_info.download.computer = ...
    char(fread(fid,N,'uchar')');                                            %Read in the computer name.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.file_info.download.port = char(fread(fid,N,'uchar')');                 %Read in the port name.