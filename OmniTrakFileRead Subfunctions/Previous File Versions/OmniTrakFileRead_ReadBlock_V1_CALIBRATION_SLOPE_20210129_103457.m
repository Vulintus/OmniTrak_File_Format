function data = OmniTrakFileRead_ReadBlock_V1_CALIBRATION_SLOPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2201
%		CALIBRATION_SLOPE

data = OmniTrakFileRead_Check_Field_Name(data,'calibration',[]);            %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the module index.
data.calibration(i).slope = fread(fid,1,'float32');                         %Save the calibration baseline coefficient.