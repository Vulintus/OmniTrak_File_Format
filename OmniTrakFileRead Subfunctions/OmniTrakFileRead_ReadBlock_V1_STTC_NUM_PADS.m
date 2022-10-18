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