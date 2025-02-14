function data = OmniTrakFileRead_ReadBlock_LSM303_TEMP_FL(fid,data)

%   Block Code: 1804
%   Block Definition: LSM303_TEMP_FL
%   Description: ."Current readings from the LSM303 temperature sensor, as float value in degrees Celsius."
%   Status:
%   Block Format:
%     * 1x (uint8) LSM303 I2C address or ID. 
%     * 1x (uint32) millisecond timestamp. 
%     * 1x (float32) temperature reading, in Celsius.


data = OmniTrakFileRead_Check_Field_Name(data,'temp');                      %Call the subfunction to check for existing fieldnames.
i = length(data.temp) + 1;                                                  %Grab a new temperature reading index.
data.temp(i).src = 'LSM303';                                                %Save the source of the temperature reading.
data.temp(i).id = fread(fid,1,'uint8');                                     %Read in the HTPA sensor index (there may be multiple sensors).
data.temp(i).timestamp = fread(fid,1,'uint32');                             %Save the microcontroller millisecond clock timestamp for the reading.
data.temp(i).celsius = fread(fid,1,'float32');                              %Save the temperature reading as a float32 value.