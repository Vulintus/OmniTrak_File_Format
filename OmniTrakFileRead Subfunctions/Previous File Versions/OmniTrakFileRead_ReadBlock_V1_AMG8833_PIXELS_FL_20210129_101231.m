function data = OmniTrakFileRead_ReadBlock_V1_AMG8833_PIXELS_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1111
%		AMG8833_PIXELS_FL

id = fread(fid,1,'uint8');                                                  %Read in the AMG8833 sensor index (there may be multiple sensors).
if ~isfield(data,'amg')                                                     %If the structure doesn't yet have an "amg" field..
    data.amg = [];                                                          %Create the field.
    data.amg(1).id = id;                                                    %Save the file-specified index for this AMG8833.
end
temp = vertcat(data.amg(:).id);                                             %Grab all of the existing AMG8833 indices.
i = find(temp == id);                                                       %Find the field index for the current AMG8833.
if ~isfield(data.amg,'pixels')                                              %If the "amg" field doesn't yet have an "pixels" field..
    data.amg.pixels = [];                                                   %Create the "pixels" field. 
end            
j = length(data.amg(i).pixels) + 1;                                         %Grab a new reading index.   
data.amg(i).pixels(j).timestamp = fread(fid,1,'uint32');                    %Save the millisecond clock timestamp for the reading.
data.amg(i).pixels(j).float = nan(8,8);                                     %Create an 8x8 matrix to hold the pixel values.
for k = 8:-1:1                                                              %Step through the rows of pixels.
    data.amg(i).pixels(j).float(k,:) = fliplr(fread(fid,8,'float32'));      %Read in each row of pixel values.
end