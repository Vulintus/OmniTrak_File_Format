function data = OmniTrakFileRead_ReadBlock_V1_MODULE_STEPS_PER_ROT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2723
%		DEFINITION:		MODULE_STEPS_PER_ROT
%		DESCRIPTION:	Steps per rotation on the specified OTMP module.
%
% fwrite(fid,ofbc.MODULE_STEPS_PER_ROT,'uint16');
% fwrite(fid,1,'uint8');
% fwrite(fid,handles.ctrl.sttc_get_steps_per_rot(),'uint16');
%

data = OmniTrakFileRead_Check_Field_Name(data,'module','steps_per_rot');    %Call the subfunction to check for existing fieldnames.
module_i = fread(fid,1,'uint8');                                            %Read in the module index.
data.module(module_i).steps_per_rot = fread(fid,1,'uint16');                %Read in the number of steps per rotation.