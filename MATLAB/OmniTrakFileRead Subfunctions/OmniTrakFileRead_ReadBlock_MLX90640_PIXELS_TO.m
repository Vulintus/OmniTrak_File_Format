function data = OmniTrakFileRead_ReadBlock_MLX90640_PIXELS_TO(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1510
%		MLX90640_PIXELS_TO

id = fread(fid,1,'uint8');                                                  %Read in the AMG8833 sensor index (there may be multiple sensors).
if ~isfield(data,'mlx')                                                     %If the structure doesn't yet have an "amg" field..
    data.mlx = [];                                                          %Create the field.
    data.mlx(1).id = id;                                                    %Save the file-specified index for this AMG8833.
end
temp = vertcat(data.mlx(:).id);                                             %Grab all of the existing AMG8833 indices.
i = find(temp == id);                                                       %Find the field index for the current AMG8833.
if ~isfield(data.mlx,'pixels')                                              %If the "amg" field doesn't yet have an "pixels" field..
    data.mlx.pixels = [];                                                   %Create the "pixels" field. 
end            
j = length(data.mlx(i).pixels) + 1;                                         %Grab a new reading index.   
data.mlx(i).pixels(j).timestamp = fread(fid,1,'uint32');                    %Save the millisecond clock timestamp for the reading.
data.mlx(i).pixels(j).float = nan(24,32);                                   %Create an 8x8 matrix to hold the pixel values.
for k = 1:24                                                                %Step through the rows of pixels.
    data.mlx(i).pixels(j).float(k,:) = fliplr(fread(fid,32,'float32'));     %Read in each row of pixel values.
end