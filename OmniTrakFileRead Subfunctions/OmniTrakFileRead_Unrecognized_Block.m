function data = OmniTrakFileRead_Unrecognized_Block(fid, data)

fseek(fid,-2,'cof');                                                        %Rewind 2 bytes.
data.unrecognized_block = [];                                               %Create an unrecognized block field.
data.unrecognized_block.pos = ftell(fid);                                   %Save the file position.
data.unrecognized_block.code = fread(fid,1,'uint16');                       %Read in the data block code.