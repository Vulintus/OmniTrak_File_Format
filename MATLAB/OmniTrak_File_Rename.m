function status = OmniTrak_File_Rename(old_filename,new_filename)

[~, old_filename_short, ext] = fileparts(old_filename);                     %Get the old filename without the path.
old_filename_short = [old_filename_short, ext];                             %Add the extension back onto the shortened old filename.
[~, new_filename_short, ext] = fileparts(new_filename);                     %Get the new filename without the path.
new_filename_short = [new_filename_short, ext];                             %Add the extension back onto the shortened new filename.

if ~strcmpi(old_filename_short, new_filename_short)                         %If the filename is being changed...
    
    old_fid = fopen(old_filename,'r');                                      %Open the input file.
    fseek(old_fid,0,'bof');                                                 %Rewind to the beginning of the file.

    block = fread(old_fid,1,'uint16');                                      %Read in the first data block code.
    if isempty(block) || block ~= hex2dec('ABCD')                           %If the first block isn't the expected OmniTrak file identifier...
        fclose(fid);                                                        %Close the input file.
        error(['ERROR IN ' upper(mfilename) ': The specified file '...
            'doesn''t start with the *.OmniTrak 0xABCD identifier '...
            'code!\n\t%s'],file);                                           %Throw an error.
    end

    block = fread(old_fid,1,'uint16');                                      %Read in the second data block code.
    if isempty(block) || block ~= 1                                         %If the second data block code isn't the format version...
        fclose(old_fid);                                                    %Close the input file.
        error(['ERROR IN ' upper(mfilename) ': The specified file doesn''t '...
            'specify an *.OmniTrak file version!\n\t%s'],file);             %Throw an error.
    end
    file_version = fread(old_fid,1,'uint16');                               %Read in the file version.

    block_codes = Load_OmniTrak_File_Block_Codes(file_version);             %Load the OmniTrak block code structure.

    new_fid = fopen(new_filename,'w');                                      %Create a new file with the new name for writing.
    fwrite(new_fid, block_codes.OMNITRAK_FILE_VERIFY, 'uint16');            %Write the OmniTrak verification code.
    fwrite(new_fid, block_codes.FILE_VERSION, 'uint16');                    %Write the file format version block code.
    fwrite(new_fid, file_version, 'uint16');                                %Write the file version.

    fwrite(new_fid,block_codes.RENAMED_FILE,'uint16');                      %Write the block code for the file renaming block.
    fwrite(new_fid,now,'float64');                                          %Write the serial date number to the file in double precision.
    N = length(old_filename_short);                                         %Grab the length of the old filename.
    fwrite(new_fid,N,'uint16');                                             %Write the the number of characters in the old filename.
    fwrite(new_fid,old_filename_short,'uchar');                             %Write the old filename.

    N = length(new_filename_short);                                         %Grab the length of the new filename.
    fwrite(new_fid,N,'uint16');                                             %Write the the number of characters in the new filename.
    fwrite(new_fid,new_filename_short,'uchar');                             %Write the old filename.

    fwrite(new_fid, fread(old_fid,'uint8'), 'uint8');                       %Copy over the rest of the file.

    fclose(new_fid);                                                        %Close the temporary file.
    fclose(old_fid);                                                        %Close the original file.

    delete(old_filename);                                                   %Delete the original file.

elseif ~strcmpi(old_filename, new_filename)                                 %If the file is simply being moved...
    [status, msg] = movefile(old_filename, new_filename, 'f');              %Use the movefile function to move/rename the file.
    if status == 0                                                          %If the file couldn't be moved...
        cprintf('Errors','OMNITRAK_FILE_RENAME ERROR: %s\n', msg);          %Print a warning to the serial line.
    end
end