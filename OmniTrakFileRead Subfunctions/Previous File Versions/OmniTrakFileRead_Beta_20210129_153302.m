function data = OmniTrakFileRead_Beta(file,varargin)

%
%OMNITRAKFILEREAD.m - Vulintus, Inc., 2018.
%
%   OMNITRAKFILEREAD reads in behavioral data from Vulintus' *.OmniTrak
%   file format and returns data organized in the fields of the output
%   "data" structure.
%
%   UPDATE LOG:
%   02/22/2018 - Drew Sloan - Function first created.
%

if nargin > 1                                                               %If there's any optional input arguments...
    verbose = any(strcmpi(varargin,'verbose'));                             %Check to see if the user requested verbose output.
else                                                                        %Otherwise, if there's not optional input arguments...
    verbose = 0;                                                            %Default to non-verbose output.
end

data = [];                                                                  %Create a structure to receive the data.

if ~exist(file,'file') == 2                                                 %If the file doesn't exist...
    error(['ERROR IN ' upper(mfilename) ': The specified file doesn''t '...
        'exist!\n\t%s'],file);                                              %Throw an error.
end

fid = fopen(file,'r');                                                      %Open the input file for read access.
fseek(fid,0,-1);                                                            %Rewind to the beginning of the file.

block = fread(fid,1,'uint16');                                              %Read in the first data block code.
if isempty(block) || block ~= hex2dec('ABCD')                               %If the first block isn't the expected OmniTrak file identifier...
    fclose(fid);                                                            %Close the input file.
    error(['ERROR IN ' upper(mfilename) ': The specified file doesn''t '...
        'start with the *.OmniTrak 0xABCD identifier code!\n\t%s'],file);   %Throw an error.
end

block = fread(fid,1,'uint16');                                              %Read in the second data block code.
if isempty(block) || block ~= 1                                             %If the second data block code isn't the format version.
    fclose(fid);                                                            %Close the input file.
    error(['ERROR IN ' upper(mfilename) ': The specified file doesn''t '...
        'specify an *.OmniTrak file version!\n\t%s'],file);                 %Throw an error.
end
data.file_version = fread(fid,1,'uint16');                                  %Read in the file version.

block_codes = Load_OmniTrak_File_Block_Codes(data.file_version);            %Load the OmniTrak block code structure.   

f_names = fieldnames(block_codes);
f_values = zeros(size(f_names));
for i = 1:length(f_names)
    f_values(i) = block_codes.(f_names{i});
end

bad_block_start = [];                                                       %Create a variable to check for bad blocks.

try                                                                         %Attempt to read in the file.
    
    while ~feof(fid)                                                        %Loop until the end of the file.

        block_start = ftell(fid);                                           %Grab the current file position.
        
        if ~isempty(bad_block_start) && bad_block_start == block_start      %If this is a known incomplete block...
            fseek(bad_block_end);                                           %Skip over the block.
        end
        
        block = fread(fid,1,'uint16');                                      %Read in the next data block code.
        if isempty(block)                                                   %If there was no new block code to read.
            continue                                                        %Skip the rest of the loop.
        end

        i = (block == f_values);                                            %Find the index for the matching block code.
        fprintf(1,'%s\n',f_names{i});                                       %Print the block code name.
        
        data = OmniTrakFileRead_ReadBlock(fid, block, data, verbose);       %Call the subfunction to read the block.
        
        if isfield(data,'unrecognized_block')                               %If the last block was unrecognized...

            i = (block == f_values);                                        %Find the index for the matching block code.
            fprintf(1,'%s\n',f_names{i});                                   %Print the block code name.

            fprintf(1,'UNRECOGNIZED BLOCK CODE: %1.0f!\n',block);           %Print the block code.
            fclose(fid);                                                    %Close the file.
            return                                                          %Skip execution of the rest of the function.

        end
    end

catch err                                                                   %If an error occured...
    if strcmpi(err.identifier, 'MATLAB:subsassigndimmismatch')              %If the error was a subscript mismatch...
        data.incomplete_block = block;                                      %Save incomplete block ID.
    else                                                                    %Otherwise...
        fprintf(1,'Add error handler for: %s\n', err.identifier);           %Print a message to add error handling for this error.
    end
    data.incomplete_block = block;                                          %Add an indicator to structure to indicate the file was not read in completely.
    
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