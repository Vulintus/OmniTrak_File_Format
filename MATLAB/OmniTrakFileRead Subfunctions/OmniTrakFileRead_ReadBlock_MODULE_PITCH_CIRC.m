function data = OmniTrakFileRead_ReadBlock_MODULE_PITCH_CIRC(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2730
%		DEFINITION:		MODULE_PITCH_CIRC
%		DESCRIPTION:	Pitch circumference, in millimeters, of the driving gear on the specified OTMP module.
%
% fwrite(fid,ofbc.MODULE_PITCH_CIRC,'uint16');
% fwrite(fid,1,'uint8');
% val = double(handles.ctrl.stap_get_pitch_circumference())/1000;
% fwrite(fid,val,'single');
%

data = OmniTrakFileRead_Check_Field_Name(data,'module',...
    'pitch_circumference');                                                 %Call the subfunction to check for existing fieldnames.
module_i = fread(fid,1,'uint8');                                            %Read in the module index.
data.module(module_i).pitch_circumference = fread(fid,1,'single');          %Read in the pitch circumference of the gear, in millimeters.