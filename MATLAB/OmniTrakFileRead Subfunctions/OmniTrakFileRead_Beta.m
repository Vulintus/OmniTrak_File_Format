function data = OmniTrakFileRead_Beta(file,varargin)

%
% OmniTrakFileRead.m
% 
%   copyright 2018, Vulintus, Inc.
%
%   OMNITRAKFILEREAD reads in behavioral data from Vulintus' *.OmniTrak
%   file format and returns data organized in the fields of the output
%   "data" structure.
%
%   OMNITRAKFILEREAD_BETA is a beta-testing version of the OmniTrakFileRead
%   function. Use "Deploy_OmniTrakFileRead.m" to generate release versions
%   of OmniTrakFileRead from OmniTrakFileRead_Beta.
%
%   UPDATE LOG:
%   2018-02-22 - Drew Sloan - Function first created.
%   2020-01-29 - Drew Sloan - Block code routing separated into a
%                             programmatically generated switch-case 
%                             subfunction, with separate subfunctions for 
%                             each block code. Coinciding updates were made
%                             to "Update_OmniTrak_Libraries.m" to collate 
%                             all new subfunctions into a release-version 
%                             OmniTrakFileRead.m.
%   2022-03-16 - Drew Sloan - Added an option input argument that
%                             terminates the file read after the header 
%                             information (subject, device type, and 
%                             session start time) is read.
%   2025-02-14 - Drew Sloan - Converted the switch-case statements in the
%                             ReadBlock routing function into a dictionary.
%


verbose = false;                                                            %Default to non-verbose output.
header_only = false;                                                        %Default to reading the entire file, not just the header.
show_waitbar = false;                                                       %Default to not showing a waitbar.
for i = 1:numel(varargin)                                                   %Step through each optional input argument.
    switch lower(varargin{i})                                               %Switch between the recognized input arguments.
        case 'header'                                                       %Just read the header.
            header_only = true;                                             %Set the header only flag to 1.
        case 'verbose'                                                      %Request verbose output.
            verbose = true;                                                 %Set the verbose flag to 1.
        case 'waitbar'                                                      %Request a waitbar.
            show_waitbar = true;                                            %Set the waitbar flag to 1.
    end
end

if ~exist(file,'file') == 2                                                 %If the file doesn't exist...
    error('ERROR IN %s: The specified file doesn''t exist!\n\t%s',...
        upper(mfilename), file);                                            %Throw an error.
end

[~, shortfile, ext] = fileparts(file);                                      %Grab the filename minus the path.
data = struct('file',[]);                                                   %Create a data structure.
data.file.name = [shortfile ext];                                           %Save the filename.

fid = fopen(file,'r');                                                      %Open the input file for read access.
fseek(fid,0,'eof');                                                         %Fast forward to the end of the file.
file_size = ftell(fid);                                                     %Read in the number of bytes in the file.
fseek(fid,0,'bof');                                                         %Rewind to the beginning of the file.

block = fread(fid,1,'uint16');                                              %Read in the first data block code.
if isempty(block) || block ~= hex2dec('ABCD')                               %If the first block isn't the expected OmniTrak file identifier...
    fclose(fid);                                                            %Close the input file.
    error(['ERROR IN %s: The specified file doesn''t start with the '...
        '*.OmniTrak 0xABCD identifier code!\n\t%s'],...
        upper(mfilename), file);                                            %Throw an error.
end

block = fread(fid,1,'uint16');                                              %Read in the second data block code.
if isempty(block) || block ~= 1                                             %If the second data block code isn't the format version.
    fclose(fid);                                                            %Close the input file.
    error(['ERROR IN %s: The specified file doesn''t specify an '...
        '*.OmniTrak file version!\n\t%s'], upper(mfilename), file);         %Throw an error.
end
data.file.version = fread(fid,1,'uint16');                                  %Save the file version.

block_read = OmniTrakFileRead_ReadBlock_Dictionary(fid);                    %Load the block read function dictionary.

waitbar_closed = false;                                                     %Create a flag to indicate when the waitbar is closed.
if show_waitbar                                                             %If we're showing a progress waitbar.
    waitbar_str = sprintf('Reading: %s%s',shortfile,ext);                   %Create a string for the waitbar.
    waitbar = big_waitbar('title','OmniTrakFileRead Progress',...
        'string',waitbar_str,...
        'value',ftell(fid)/file_size);                                      %Create a waitbar figure.
end

try                                                                         %Attempt to read in the file.
    
    while ~feof(fid) && ~waitbar_closed                                     %Loop until the end of the file. 
        
        block = fread(fid,1,'uint16');                                      %Read in the next data block code.
        if isempty(block)                                                   %If there was no new block code to read.
            continue                                                        %Skip the rest of the loop.
        end
        
        if verbose && isKey(block_read, block)                              %If verbose output is enabled and this block is recognized...
            fprintf(1,'b%1.0f\t>>\t0x%s: %s\n',...
                ftell(fid)-2,...
                dec2hex(block,4),...
                block_read(block).def_name);                                %Print the block location in the file.
        end
        
        if isKey(block_read, block)                                         %If this block is recognized...
            data = block_read(block).fcn(data);                             %Call the subfunction to read the block.
        else                                                                %Otherwise, if the block isn't recognized...
            fseek(fid,-2,'cof');                                            %Rewind 2 bytes.
            data.unrecognized_block = [];                                   %Create an unrecognized block field.
            data.unrecognized_block.pos = ftell(fid);                       %Save the file position.
            data.unrecognized_block.code = block;                           %Save the data block code.
            fprintf(1,'b%1.0f\t>>\t0x%s: UNRECOGNIZED BLOCK CODE!\n',...
                ftell(fid),...
                dec2hex(block,4));                                          %Print the block location in the file.
            fclose(fid);                                                    %Close the file.
            return                                                          %Skip execution of the rest of the function.
        end
        
        if header_only                                                      %If we're only reading the header.
            if isnt_empty_field(data,'subject','name') && ...
                    isnt_empty_field(data,'file','start') && ...
                    isnt_empty_field(data,'device','type')                  %If all the header fields are read in...
                fclose(fid);                                                %Close the file.
                return                                                      %Skip execution of the rest of the function.
            end
                    
        end

        if show_waitbar                                                     %If we're showing the waitbar...
            if waitbar.isclosed()                                           %If the user closed the waitbar figure...
                waitbar_closed = true;                                      %Set the waitbar closed flag to 1.
            else                                                            %If the waitbar hasn't been closed...
                waitbar.value(ftell(fid)/file_size);                        %Update the waitbar value.
                waitbar.string(sprintf('%s (%1.0f/%1.0f)',waitbar_str,...
                    ftell(fid),file_size));                                 %Update the waitbar text.
            end
        end

    end

catch err                                                                   %If an error occured...
    
    fprintf(1,'\n');                                                        %Print a carriage return.
    cprintf(-[1,0.5,0],'* FILE READ ERROR IN OMNITRAKFILEREAD:');           %Print a warning message.
    [path,filename,ext] = fileparts(file);                                  %Break the filename into parts.     
    cprintf([1,0.5,0],'\n\n\tFILE: %s%s\n', filename, ext);                 %Print the filename.
    if ~isempty(path)                                                       %If the path is included in the filename...
        cprintf([1,0.5,0],'\tPATH: %s\n', path);                            %Print the path.
    end
    cprintf([1,0.5,0],'\n\tERROR: %s (%s)\n', err.message, err.identifier); %Print the error message.
    for i = numel(err.stack):-1:1                                           %Step through each level of the error stack.
        cprintf([1,0.5,0],repmat('\t',1,(numel(err.stack)-i) + 2));         %Print tabs according to the program level.
        cprintf([1,0.5,0],'%s ', err.stack(i).name);                        %Print the offending function name.
        cprintf([1,0.5,0],['<a href="matlab:opentoline(''%s'','...
            '%1.0f)">(line %1.0f)</a>\n'], err.stack(i).file,...
            err.stack(i).line, err.stack(i).line);                          %Print a link to the offending line of code.
    end
    fprintf(1,'\n');                                                        %Print a carriage return.
    
end

fclose(fid);                                                                %Close the input file.

if show_waitbar && ~waitbar.isclosed()                                      %If we're showing the waitbar and it's not yet closed....
    waitbar.close();                                                        %Close the waitbar.
end