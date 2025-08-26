function data = OmniTrakFileRead_ReadBlock_SUBJECT_DEPRECATED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		4
%		SUBJECT_DEPRECATED

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.subject = fread(fid,N,'*char')';                                       %Read in the characters of the subject's name.