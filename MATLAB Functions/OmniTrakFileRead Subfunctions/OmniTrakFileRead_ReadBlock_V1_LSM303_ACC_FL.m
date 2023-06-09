function data = OmniTrakFileRead_ReadBlock_V1_LSM303_ACC_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1802
%		LSM303_ACC_FL

data = OmniTrakFileRead_Check_Field_Name(data,'acc');                       %Call the subfunction to check for existing fieldnames.
i = length(data.acc) + 1;                                                   %Grab a new accelerometer reading index.
data.acc(i).src = 'LSM303';                                                 %Save the source of the accelerometer reading.
data.acc(i).id = fread(fid,1,'uint8');                                      %Read in the accelerometer sensor index (there may be multiple sensors).
data.acc(i).time = fread(fid,1,'uint32');                                   %Save the millisecond clock timestamp for the reading.
data.acc(i).xyz = fread(fid,3,'float32');                                   %Save the accelerometer x-y-z readings as float-32 values.