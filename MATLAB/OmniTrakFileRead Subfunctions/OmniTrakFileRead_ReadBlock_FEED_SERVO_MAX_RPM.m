function data = OmniTrakFileRead_ReadBlock_FEED_SERVO_MAX_RPM(fid,data)

%	OmniTrak File Block Code (OFBC):
%		190
%		FEED_SERVO_MAX_RPM

data = OmniTrakFileRead_Check_Field_Name(data,'device','feeder');           %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.
data.device.feeder(i).max_rpm = fread(fid,1,'float32');                     %Read in the maximum measure speed, in RPM.