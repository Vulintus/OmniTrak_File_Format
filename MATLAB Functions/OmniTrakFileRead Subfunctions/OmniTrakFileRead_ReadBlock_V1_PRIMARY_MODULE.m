function data = OmniTrakFileRead_ReadBlock_V1_PRIMARY_MODULE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	110
%		DEFINITION:		PRIMARY_MODULE
%		DESCRIPTION:	Primary module name, for systems with interchangeable modules.
%
%   UPDATE LOG:
%   2024-01-19 - Drew Sloan - Added handling for old files in which the
%                             character count was written as a uint16.
%

data = OmniTrakFileRead_Check_Field_Name(data,'module');                    %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
temp_str = fread(fid,N,'*char')';                                           %Read in the characters of the primary module name.
if temp_str(1) == 0                                                         %If the first character is zero...
    fseek(fid,-(N+1),'cof');                                                %Rewind to the character count.
    N = fread(fid,1,'uint16');                                              %Read in the number of characters.
    temp_str = fread(fid,N,'*char')';                                       %Read in the characters of the primary module name.
end
data.module(1).name = temp_str;                                             %Save the primary module name.