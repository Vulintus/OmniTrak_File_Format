function data = OmniTrakFileRead_ReadBlock_FEED_SERVO_SPEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		191
%		FEED_SERVO_SPEED

data = OmniTrakFileRead_Check_Field_Name(data,'device','feeder');           %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.
data.device.feeder(i).servo_speed = fread(fid,1,'uint8');                   %Read in the current speed setting (0-180).