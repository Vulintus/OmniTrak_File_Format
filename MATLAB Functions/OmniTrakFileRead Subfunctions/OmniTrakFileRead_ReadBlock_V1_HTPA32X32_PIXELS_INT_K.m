function data = OmniTrakFileRead_ReadBlock_V1_HTPA32X32_PIXELS_INT_K(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1114
%		DEFINITION:		HTPA32X32_PIXELS_INT_K
%		DESCRIPTION:	The current HTPA32x32 pixel readings represented as 16-bit unsigned integers in units of deciKelvin (dK, or Kelvin * 10).

fprintf(1,'Need to finish coding for Block 1114: HTPA32X32_PIXELS_INT_K\n');

data = OmniTrakFileRead_Check_Field_Name(data,'module','num_pads');         %Call the subfunction to check for existing fieldnames.
module_i = fread(fid,1,'uint8');                                            %Read in the module index.
data.module(module_i).num_pads = fread(fid,1,'uint8');                      %Read in the number of texture pads.
if data.module(module_i).num_pads > 10                                      %If there's more than 10 texture pads.
    temp = 0;                                                               %Create a variable to hold the block code.
    while (temp ~= 2722) && ~feof(fid)                                      %Loop until we find the next expected block code.        
        fseek(fid,-1,'cof');                                                %Rewind one byte.
        temp = fread(fid,1,'uint16');                                       %Read in an unsigned 16-bit integer.
%         fprintf(1,'ftell(fid) = %1.0f, temp = %1.0f\n',ftell(fid),temp);
    end
    fseek(fid,-3,'cof');                                                    %Rewind 3 bytes.
    data.module(module_i).num_pads = fread(fid,1,'uint8');                  %Read in the number of texture pads.
end


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