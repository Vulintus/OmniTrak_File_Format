function data = OmniTrakFileRead_ReadBlock_LSM303_ACC_FL(fid,data)

%   Block Code: 1802
%   Block Definition: LSM303_ACC_FL
%   Description: "Current readings from the LSM303D accelerometer, as float values in m/s^2."
%   Status:
%   Block Format:
%     * 1x (uint8): LSM303D I2C address or ID.
%     * 1x (uint32): microcontroller timestamp, whole number of milliseconds.
%     * 3x (float32): x, y, & z acceleration readings, in m/s^2.


data = OmniTrakFileRead_Check_Field_Name(data,'accel');                     %Call the subfunction to check for existing fieldnames.
i = length(data.accel) + 1;                                                 %Grab a new accelerometer reading index.
data.accel(i).src = 'LSM303';                                               %Save the source of the accelerometer reading.
data.accel(i).id = fread(fid,1,'uint8');                                    %Read in the accelerometer sensor index (there may be multiple sensors).
data.accel(i).time = fread(fid,1,'uint32');                                 %Save the millisecond clock timestamp for the reading.
data.accel(i).xyz = fread(fid,3,'float32');                                 %Save the accelerometer x-y-z readings as float-32 values.