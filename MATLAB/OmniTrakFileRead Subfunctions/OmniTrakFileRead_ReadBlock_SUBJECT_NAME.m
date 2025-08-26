function data = OmniTrakFileRead_ReadBlock_SUBJECT_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		200
%		SUBJECT_NAME

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.subject.name = fread(fid,N,'*char')';                                  %Read in the characters of the subject's name.