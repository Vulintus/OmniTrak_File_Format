function data = OmniTrakFileRead_ReadBlock_MODULE_CENTER_OFFSET(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2731
%		DEFINITION:		MODULE_CENTER_OFFSET
%		DESCRIPTION:	Center offset, in millimeters, for the specified OTMP module.
%
% fwrite(fid,ofbc.MODULE_CENTER_OFFSET,'uint16');
% fwrite(fid,1,'uint8');
% val = double(handles.ctrl.stap_get_center_offset())/1000;
% fwrite(fid,val,'single');
%

data = OmniTrakFileRead_Check_Field_Name(data,'module','center_offset');    %Call the subfunction to check for existing fieldnames.
module_i = fread(fid,1,'uint8');                                            %Read in the module index.
data.module(module_i).center_offset = fread(fid,1,'single');                %Read in the handle's center offset, in millimeters.