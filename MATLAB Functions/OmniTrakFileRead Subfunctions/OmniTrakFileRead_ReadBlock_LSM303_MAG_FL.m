function data = OmniTrakFileRead_ReadBlock_LSM303_MAG_FL(fid,data)

%   Block Code: 1803
%   Block Definition: LSM303_MAG_FL
%   Description: "Current readings from the LSM303D magnetometer, as float values in uT."
%   Status:
%   Block Format:
%     * 1x (uint8): LSM303D I2C address or ID.
%     * 1x (uint32): microcontroller timestamp, whole number of milliseconds.
%     * 3x (float32): x, y, & z magnetometer readings, in uT.


data = OmniTrakFileRead_Check_Field_Name(data,'mag');                       %Call the subfunction to check for existing fieldnames.
i = length(data.mag) + 1;                                                   %Grab a new magnetometer reading index.
data.mag(i).src = 'LSM303';                                                 %Save the source of the magnetometer reading.
data.mag(i).id = fread(fid,1,'uint8');                                      %Read in the magnetometer sensor index (there may be multiple sensors).
data.mag(i).time = fread(fid,1,'uint32');                                   %Save the millisecond clock timestamp for the reading.
data.mag(i).xyz = fread(fid,3,'float32');                                   %Save the magnetometer x-y-z readings as float-32 values.