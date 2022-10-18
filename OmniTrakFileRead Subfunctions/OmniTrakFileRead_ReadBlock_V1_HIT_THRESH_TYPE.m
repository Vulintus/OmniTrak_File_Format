function data = OmniTrakFileRead_ReadBlock_V1_HIT_THRESH_TYPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2300
%		HIT_THRESH_TYPE

data = OmniTrakFileRead_Check_Field_Name(data,'hit_thresh_type');           %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the signal index.
if isempty(data.hit_thresh_type)                                            %If there's no hit threshold type yet set...
    data.hit_thresh_type = cell(i,1);                                       %Create a cell array to hold the threshold types.
end
N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.hit_thresh_type{i} = fread(fid,N,'*char')';                            %Read in the characters of the user's experiment name.