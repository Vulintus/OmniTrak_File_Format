function data = OmniTrakFileRead_ReadBlock_V1_USER_SYSTEM_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		130
%		USER_SYSTEM_NAME

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
if N < 255                                                                  %If there's less than 255 characters in the system name.
    data.device.user_system_name = fread(fid,N,'*char')';                   %Read in the characters of the system name.
else                                                                        %Otherwise...
    data.device.user_system_name = 'USER_SYSTEM_NAME_ERROR';                %Show that there was an error in the system name.
    temp = 'xxx';                                                           %Create a temporary string for comparison.
    while ~strcmpi(temp,'COM')                                              %Loop until we find the characters "COM"...
        fseek(fid,-2,'cof');                                                %Rewind 2 bytes.
        temp = fread(fid,3,'*char')';                                       %Read in the characters of the system name.
    end
    fseek(fid,-6,'cof');                                                    %Rewind 5 bytes.
end