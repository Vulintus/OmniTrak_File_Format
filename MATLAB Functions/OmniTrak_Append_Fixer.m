function OmniTrak_Append_Fixer(file)

block_codes = Load_OmniTrak_File_Block_Codes(1);                            %Load the OmniTrak block code structure.
old_fid = fopen(file,'r');                                                  %Open the input file.
fseek(old_fid,-50,'eof');                                                   %Rewind to the beginning of the file.
str = char(fread(old_fid,'uchar')');                                        %Read in the last 5 characters.
if any(strfind(str,'COM')) || any(strfind(str,'.OmniTrak'))                 %If there was a "COM" at the end of the file...
    checker = 1;
    while checker == 1
        checker = 0;
        fseek(old_fid,-9,'eof');                                                %Rewind to the beginning of the file.
        str = char(fread(old_fid,'uchar')');                                    %Read in the last 9 characters.
        if any(strfind(str,'.OmniTrak'))                               
            fseek(old_fid,-100,'eof');
            str = char(fread(old_fid,'uchar')');
            i = strfind(str,'.OTK');
            new_filename = str(i + 6:end);                                 
            old_filename = str(i-8:i+3);
            fseek(old_fid,-100 + i - 19,'eof');
            timestamp = fread(old_fid,1,'float64');
            fseek(old_fid,-100 + i - 21,'eof');
            pos = ftell(old_fid);
            [path, ~, ~] = fileparts(file);
            new_fid = fopen(fullfile(path,'omnitrak_fix.OTK'),'w');
            fseek(old_fid,0,'bof');
            fwrite(new_fid,fread(old_fid,6,'uint8'),'uint8');            
            fwrite(new_fid,block_codes.RENAMED_FILE,'uint16');                      %Write the block code for the file renaming block.
            fwrite(new_fid,timestamp,'float64');                                          %Write the serial date number to the file in double precision.
            N = length(old_filename);                                         %Grab the length of the old filename.
            fwrite(new_fid,N,'uint16');                                             %Write the the number of characters in the old filename.
            fwrite(new_fid,old_filename,'uchar');                             %Write the old filename.
            N = length(new_filename);                                         %Grab the length of the new filename.
            fwrite(new_fid,N,'uint16');                                             %Write the the number of characters in the new filename.
            fwrite(new_fid,new_filename,'uchar');                             %Write the old filename.
            while ftell(old_fid) < pos
                fwrite(new_fid,fread(old_fid,1,'uint8'),'uint8');
            end
            fclose(new_fid);
            fclose(old_fid);
            copyfile(fullfile(path,'omnitrak_fix.OTK'),file,'f');           
            delete(fullfile(path,'omnitrak_fix.OTK'));
            old_fid = fopen(file,'r');                                                  %Open the input file.
            checker = 1;
        elseif any(strfind(str,'COM'))
            checker = 1;
        end
    end
end