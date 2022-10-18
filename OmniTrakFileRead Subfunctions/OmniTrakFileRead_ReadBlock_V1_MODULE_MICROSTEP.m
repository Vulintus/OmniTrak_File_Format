function data = OmniTrakFileRead_ReadBlock_V1_MODULE_MICROSTEP(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2722
%		DEFINITION:		MODULE_MICROSTEP
%		DESCRIPTION:	Microstep setting on the specified OTMP module.
%
% fwrite(fid,ofbc.MODULE_MICROSTEP,'uint16');
% fwrite(fid,1,'uint8');
% fwrite(fid,handles.ctrl.sttc_get_microstep(),'uint8');
%

data = OmniTrakFileRead_Check_Field_Name(data,'module','microstep');        %Call the subfunction to check for existing fieldnames.
module_i = fread(fid,1,'uint8');                                            %Read in the module index.
data.module(module_i).microstep = fread(fid,1,'uint8');                     %Read in the microstop setting.