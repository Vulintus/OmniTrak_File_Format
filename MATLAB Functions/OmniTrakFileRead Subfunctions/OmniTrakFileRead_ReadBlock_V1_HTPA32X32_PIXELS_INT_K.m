function data = OmniTrakFileRead_ReadBlock_V1_HTPA32X32_PIXELS_INT_K(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1114
%		DEFINITION:		HTPA32X32_PIXELS_INT_K
%		DESCRIPTION:	The current HTPA32x32 pixel readings represented as 16-bit unsigned integers in units of deciKelvin (dK, or Kelvin * 10).


data = OmniTrakFileRead_Check_Field_Name(data,'htpa','id');                 %Call the subfunction to check for existing fieldnames.
id = fread(fid,1,'uint8');                                                  %Read in the HTPA sensor index (there may be multiple sensors).
if isempty(data.htpa(1).id)                                                 %If this is the first reading for any HTPA sensor.
    sensor_i = 1;                                                           %Set the sensor index to 1.
    data.htpa(sensor_i).id = id;                                            %Save the sensor index.
else                                                                        %Otherwise...
    existing_ids = vertcat(data.htpa.id);                                   %Grab all of the existing HTAP sensor IDs.
    sensor_i = find(id == existing_ids);                                    %Find the index for the current sensor.
end
data.htpa = OmniTrakFileRead_Check_Field_Name(data.htpa,'pixels');          %Call the subfunction to check for existing fieldnames.
reading_i = length(data.htpa(sensor_i).pixels) + 1;                         %Increment the sensor index.
data.htpa(sensor_i).pixels(reading_i).timestamp = fread(fid,1,'uint32');    %Save the microcontroller millisecond clock timestamp for the reading.
temp = fread(fid,1024,'uint8');                                             %Read in the pixel values as 16-bit unsigned integers of deciKelvin.
% temp = fread(fid,1024,'uint16');                                            %Read in the pixel values as 16-bit unsigned integers of deciKelvin.
data.htpa(sensor_i).pixels(reading_i).decikelvin = reshape(temp,32,32)';    %Reshape the values into a 32x32 matrix.
