function data =  OmniTrakFileRead_ReadBlock_ADMIN_NAME(fid,data)

%
% OmniTrakFileRead_ReadBlock_ADMIN_NAME.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_ADMIN_NAME reads in the "ADMIN_NAME" data
%   block from an *.OmniTrak format file. This block is intended to contain
%   the test administrator's name, i.e. the name of the human experimenter
%   administering the experiment/program.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x00E0
%		DEFINITION:		ADMIN_NAME
%		DESCRIPTION:	Test administrator's name.
%
%   UPDATE LOG:
%   2025-06-19 - Drew Sloan - Function first created.
%

data = OmniTrakFileRead_Check_Field_Name(data,'admin','name');              %Call the subfunction to check for existing fieldnames.         

N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
if isempty(data.admin.name)                                                 %If no administrator name is yet set...
    data.admin.name = fread(fid,N,'*char')';                                %Add the name to a cell array of names.
else                                                                        %Otherwise...
    if ~iscell(data.admin.name)                                             %If the name field isn't already a cell array.
        data.admin.name = cellstr(data.admin.name);                         %Convert it to a cell array.
    end
    data.admin.name{end+1} = fread(fid,N,'*char')';                         %Add the name to a cell array of names.
end                       
