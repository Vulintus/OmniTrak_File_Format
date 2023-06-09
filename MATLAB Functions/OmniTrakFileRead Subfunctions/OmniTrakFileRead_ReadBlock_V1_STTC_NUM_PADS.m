function data = OmniTrakFileRead_ReadBlock_V1_STTC_NUM_PADS(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2721
%		DEFINITION:		STTC_NUM_PADS
%		DESCRIPTION:	Number of pads on the SensiTrak Tactile Carousel module.
%
% fwrite(fid,ofbc.STTC_NUM_PADS,'uint16');
% fwrite(fid,1,'uint8');
% fwrite(fid,handles.ctrl.sttc_get_num_pads(),'uint8');

data = OmniTrakFileRead_Check_Field_Name(data,'module','num_pads');         %Call the subfunction to check for existing fieldnames.
module_i = fread(fid,1,'uint8');                                            %Read in the module index.
data.module(module_i).num_pads = fread(fid,1,'uint8');                      %Read in the number of texture pads.
if data.module(module_i).num_pads > 10                                      %If there's more than 10 texture pads.
    temp = 0;                                                               %Create a variable to hold the block code.
    while (temp ~= 2722) && ~feof(fid)                                      %Loop until we find the next expected block code.        
        fseek(fid,-1,'cof');                                                %Rewind one byte.
        temp = fread(fid,1,'uint16');                                       %Read in an unsigned 16-bit integer.
%         fprintf(1,'ftell(fid) = %1.0f, temp = %1.0f\n',ftell(fid),temp);
    end
    fseek(fid,-3,'cof');                                                    %Rewind 3 bytes.
    data.module(module_i).num_pads = fread(fid,1,'uint8');                  %Read in the number of texture pads.
end
