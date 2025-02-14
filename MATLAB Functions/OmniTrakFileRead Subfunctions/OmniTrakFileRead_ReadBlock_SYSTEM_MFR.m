function data = OmniTrakFileRead_ReadBlock_SYSTEM_MFR(fid,data)

%	OmniTrak File Block Code (OFBC):
%		105
%		SYSTEM_MFR

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field.
    data.device = [];                                                       %Create the field.
end
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device.manufacturer = char(fread(fid,N,'uchar')');                     %Read in the manufacturer.