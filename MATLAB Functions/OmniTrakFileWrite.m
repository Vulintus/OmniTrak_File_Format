function file_struct = OmniTrakFileWrite(filename)

%
% OmniTrakFileWrite.m
% 
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE opens a new *.OmniTrak format file with the specified
%   filename and passes back a structure with the file identifier, file 
%   name, and close function.
%
%   UPDATE LOG:
%   2025-02-14 - Drew Sloan - Function first created, split off from
%                             "OmniTrak_File_Writer" while replacing
%                             switch-case instances with dictionaries.
%


[fid,errmsg] = fopen(filename,'w');                                         %Open the data file as a binary file for writing.
if fid == -1                                                                %If the file could not be created...
    errordlg(sprintf(['Could not create the *.OmniTrak data file '...
        'at:\n\n%s\n\nError:\n\n%s'],filename,...
        errmsg),'OmniTrak File Write Error');                               %Show an error dialog box.
end

file_struct = struct('fid',fid,'name',filename,'close',[]);                 %Initialize a file structure.

ofbc = Load_OmniTrak_File_Block_Codes;                                      %Load the OmniTrak file format block code libary.

%File format verification and version.
fwrite(fid,ofbc('OMNITRAK_FILE_VERIFY'),'uint16');                          %The first block of the file should equal 0xABCD to indicate a Vulintus *.OmniTrak file.
fwrite(fid,ofbc('FILE_VERSION'),'uint16');                                  %The second block of the file should be the file version indicator.
fwrite(fid,1,'uint16');                                                     %Write the current OFBC version (will probably be a value of 1 forever).

file_struct.close = ...
    @()OmniTrakFileWrite_Close(fid, ofbc('CLOCK_FILE_STOP'));               %Add the file-closing function.

file_struct.write = OmniTrakFileWrite_WriteBlock_Dictionary(fid, ofbc);     %Load the block-writing dictionary.

file_struct.write{'CLOCK_FILE_START'}();                                    %Write the clock file start timestamp.




