function data = OmniTrakFileRead_ReadBlock_V1_CTRL_FW_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	143
%		DEFINITION:		CTRL_FW_TIME
%		DESCRIPTION:	Controller firmware upload time, copied from the macro, written as characters.
%
% str = handles.ctrl.get_firmware_time();
% fwrite(fid,ofbc.CTRL_FW_TIME,'uint16');
% fwrite(fid,length(str),'uint8');
% fwrite(fid,str,'uchar');
%

data = OmniTrakFileRead_Check_Field_Name(data,'device','controller',...
    'firmware','upload_time');                                              %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
str = char(fread(fid,N,'uchar')');                                          %Read in the characters of the macro.
if numel(str) > 8                                                           %If there's more than 11 characters in the timestamp...
    N = N - 8;                                                              %Calculate how many extra bytes were read.
    fseek(fid,-N,'cof');                                                    %Rewind the data file back the extra bytes.
    a = ftell(fid);                                                         %Grab the starting position of the weird chunk.
    block_code = 0;                                                         %Create a block code checker.
    while block_code ~= 110 && ~feof(fid)                                   %Loop until we get to the firmware time.
        block_code = fread(fid,1,'uint16');                                 %Read in two bytes as a block code.
        fseek(fid,-1,'cof');                                                %Rewind one byte.
    end
    fseek(fid,-1,'cof');                                                    %Rewind another byte.
    b = ftell(fid);                                                         %Grab the starting position of the weird chunk.
    fprintf(1,'FW_TIME Weirdness: %1.0f extra bytes.\n',b-a);               %Write the number of bytes in between.
end
time_val = rem(datenum(str(1:8)),1);                                        %Convert the time string to a date number.
if ~isempty(data.device.controller.firmware.upload_time)                    %If there's already an upload time listed...
    date_val = fix(data.device.controller.firmware.upload_time);            %Grab the non-fractional part of the timestamp.
else                                                                        %Otherwise...
    date_val = 0;                                                           %Set the non-fractional time to zero.
end
data.device.controller.firmware.upload_time = date_val + time_val;          %Save the date with any existing fractional time.