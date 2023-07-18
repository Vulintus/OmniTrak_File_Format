function data = OmniTrakFileRead_ReadBlock_V1_DOWNLOAD_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		42
%		DOWNLOAD_TIME

data = OmniTrakFileRead_Check_Field_Name(data,'file_info','download',...
    'time');                                                                %Call the subfunction to check for existing fieldnames.
data.file_info.download.time = fread(fid,1,'float64');                      %Read in the timestamp for the download.