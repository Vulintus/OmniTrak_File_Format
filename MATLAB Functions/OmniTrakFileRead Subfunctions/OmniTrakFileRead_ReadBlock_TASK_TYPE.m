function data = OmniTrakFileRead_ReadBlock_TASK_TYPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		301
%		TASK_TYPE

data = OmniTrakFileRead_Check_Field_Name(data,'task');                    %Call the subfunction to check for existing fieldnames.                
N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.task(1).type = fread(fid,N,'*char')';                                  %Read in the characters of the user's task type.