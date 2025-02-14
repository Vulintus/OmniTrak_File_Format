function Update_OmniTrak_File_Format_Libraries

%
% Update_OmniTrak_File_Format_Libraries.m
% 
%   copyright 2021, Vulintus, Inc.
%
%   UPDATE_OMNITRAK_FILE_FORMAT_LIBRARIES takes the *.OmniTrak file format
%   data block codes (OFBC) from the principal list markdown file 
%   ("OFBC Codes Principal List.md") in Vulintus's "OmniTrak_File_Format" 
%   GitHub repository and creates corresponding matched Arduino libraries 
%   and MATLAB functions.
%
%   UPDATE LOG:
%   2021-09-14 - Drew Sloan - Function first created, adapted from
%                             Update_OmniTrak_Libraries.m
%   2023-06-08 - Drew Sloan - Changed the function name from
%                             "Update_OmniTrak_File_Block_Codes.m".
%   2025-02-13 - Drew Sloan - Switched from using the Google Spreadsheet as
%                             the principal list to using the principal
%                             list markdown file in the repository.
%


tbl_start = '<!---table starts below--->';                                  %Set the expected comment marking the table start.
tbl_end = '<!---table ends above--->';                                      %Set the expected comment marking the table start.
repo_url = 'https://github.com/Vulintus/OmniTrak_File_Format';              %Set the repository URL.

%Set the expected names of the principal definition list.
principal_list_file = 'OmniTrak_File_Block_Codes.md';                       %Set the expected name of the principal code list.

%Find the main directory for the OFBC repository.
repo_dir = [];                                                              %Find the main directory for the repository.
temp = which(principal_list_file);                                          %Check to see if the principal_list file is already in the search path.
if ~isempty(temp)                                                           %If the principal list was found...
    [repo_dir, ~, ~] = fileparts(temp);                                     %Grab the repository main directory from the full filename.
else                                                                        %Otherwise, if the principal list wasn't found.
    [temp, cur_dir, ~] = fileparts(mfilename('fullpath'));                  %Grab the full path for the current m-file.
    while ~isempty(cur_dir)                                                 %Loop until there's no more folders below the current folder.
        if exist(fullfile(temp,principal_list_file),'file')                 %If the principle list is in the current folder...
            repo_dir = temp;                                                %Set the repository main directory to the current older.
            cur_dir = [];                                                   %Set the current directory to empty to exit the loop.
        else                                                                %Otherwise...
            [temp, cur_dir, ~] = fileparts(temp);                           %Drop down another folder level.
        end
    end
    if isempty(repo_dir)                                                    %If we still haven't found the repository main directory...
        prompt = sprintf('Where is "%s"?"',principal_list_file);            %Create a prompt string.
        [file, repo_dir] = uigetfile(principal_list_file,prompt);           %Have the user find the file.
        if file(1) == 0 || ~strcmpi(file,principal_list_file)               %If no file was selected or the file doesn't match...
            return                                                          %Skip execution of the rest of the function.
        end
    end
end
principal_list_file = fullfile(repo_dir, principal_list_file);              %Add the repository directory to the expected filename.

%Set the target directories.
matlab_dir = fullfile(repo_dir,'MATLAB Functions');                         %Set the directory for MATLAB functions.
if ~exist(matlab_dir,'dir')                                                 %If the MATLAB directory doesn't yet exist...
    mkdir(matlab_dir);                                                      %Create it.
end
lib_dir = fullfile(repo_dir,'C Libraries');                                 %Set the directory for Arduino-compatible libraries.
if ~exist(lib_dir,'dir')                                                    %If the library directory doesn't yet exist...
    mkdir(lib_dir);                                                         %Create it.
end
description_dir = fullfile(repo_dir,'Data Block Descriptions');             %Set the the data block description markdown files.
if ~exist(description_dir,'dir')                                            %If the description directory doesn't yet exist...
    mkdir(description_dir);                                                 %Create it.
end

%Read in the OFBC data block codes.
ofbc_codes = Read_Principal_Code_List(principal_list_file, tbl_start);

%Update the description markdown file.
Update_Description_Markdown_files(ofbc_codes, description_dir);           

%Create the Arduino library header file(s) for the OmniTrak File Block Codes (OFBC).
Write_OFBC_Library_Header(lib_dir, ofbc_codes, repo_url);

%Create the MATLAB function for loading the OmniTrak File Block Codes.
Write_OFBC_Loading_Script(matlab_dir, ofbc_codes, repo_url);

%Create the MATLAB subfunctions for reading in OmniTrak file data blocks.
Write_OmniTrakFileRead_Subfunctions(matlab_dir, ofbc_codes, repo_url);


%% Read in the OFBC data block codes.
function ofbc_codes = Read_Principal_Code_List(principal_list_file,...
    tbl_start)

ofbc_codes = struct([]);                                                    %Create a structure to hold the OmniTrak File Block Codes (OFBC).

%Read in the markdown file.
[fid, errmsg] = fopen(principal_list_file,'rt');                            %Open the principal list for reading as text.
if fid == -1                                                                %If the file could not be opened...
    fclose(fid);                                                            %Close the file.
    error(sprintf(['Could not open the OFBC Principal Code List file!'...
        '\n\nError: %s'],errmsg),'File Read Error');                        %Throw an error.    
end
txt = fread(fid,'*char')';                                                  %Read in the file data as text.
fclose(fid);                                                                %Close the principal list.
tbl_start = strfind(txt,tbl_start);                                         %Find the start of the table.
if isempty(tbl_start)                                                       %If we couldn't find the start or end of the table...
    error(['Could not find the code list table in the OFBC Principal '...
        'Code List file!'],'File Read Error');                              %Throw an error.    
end
tbl_start = tbl_start + find(txt(tbl_start:end) == newline,1,'first');      %Find the first new line after the table start comment.
md_header = txt(1:tbl_start-1);                                             %Grab the header that precedes the table.
txt = txt(tbl_start:end);                                                   %Grab just the table.
ln_i = find(txt == newline);                                                %Find all new line characters in the text.
ln = txt(1:ln_i(1));                                                        %Grab the top line.
col_j = find(ln == '|');                                                    %Find the column markers in the line.
column_headings = cell(1,length(col_j)-1);                                  %Pre-allocate a cell array to hold column headings.
for j = 1:length(col_j) - 1                                                 %Step through each column.
    str = strtrim(ln(col_j(j)+1:col_j(j+1)-1));                             %Grab the entry in this column.
    column_headings{j} = str;                                               %Save each column heading.
end
hex_col = find(strcmpi(column_headings,'block code (hex)'));                %Find the hex block code column index.
uint_col = find(strcmpi(column_headings,'block code (uint16)'));            %Find the uint16 block code column index.
def_col = find(strcmpi(column_headings,'definition name'));                 %Find the definition name column index.
desc_col = find(strcmpi(column_headings,'description'));                    %Find the description column index.
min_cols = max([hex_col, uint_col, def_col, desc_col]) + 1;                 %Set the minimum number of columns per row.
for i = 3:length(ln_i)                                                      %Step through each line of the table.
    ln = txt(ln_i(i-1):ln_i(i));                                            %Grab the current line.
    col_j = find(ln == '|');                                                %Find the column markers in the line.
    if length(col_j) < min_cols                                             %If there's not enough entries in this line...
        continue                                                            %Skip to the next line.
    end
    hex_code = strtrim(ln(col_j(hex_col)+1:col_j(hex_col+1)-1));            %Grab the hex code.
    uint_code = strtrim(ln(col_j(uint_col)+1:col_j(uint_col+1)-1));         %Grab the uint16 code.
    def_name = strtrim(ln(col_j(def_col)+1:col_j(def_col+1)-1));            %Grab the definition name.
    if (~isempty(hex_code) || ~isempty(uint_code)) && ~isempty(def_name)    %If there's a block code and a definition name.
        c = length(ofbc_codes) + 1;                                         %Increment the OFBC code structure.
        ofbc_codes(c).uint = str2double(uint_code);                         %Convert the uint16 text to a number.
        ofbc_codes(c).hex = hex_code;                                       %Save the hex_code.
        ofbc_codes(c).def = def_name;                                       %Save the definition name.
        ofbc_codes(c).description = ...
            strtrim(ln(col_j(desc_col)+1:col_j(desc_col+1)-1));             %Save the block description.
        if ~isempty(ofbc_codes(c).hex) && ...
                ~isempty(ofbc_codes(c).uint) && ...
                (ofbc_codes(c).uint ~= hex2dec(ofbc_codes(c).hex))          %If the hex and uint16 values don't match...
            ofbc_codes(c).uint = [];                                        %The hex value should take precedence.
        end
    end
end

%Clean up the OFBC codes structure.
for c = 1:length(ofbc_codes)                                                %Step through the OFBC codes.    
    if (isempty(ofbc_codes(c).uint) || isnan(ofbc_codes(c).uint)) && ...
            ~isempty(ofbc_codes(c).hex)                                     %If there's a hex value, but not a uint16 value...
        ofbc_codes(c).uint = hex2dec(ofbc_codes(c).hex);                    %Convert the hex value to a uint16 value.
    end
    ofbc_codes(c).hex = ['0x' dec2hex(ofbc_codes(c).uint,4)];               %Convert the uint16 value to a hex value.
    a = find(ofbc_codes(c).def == '[',1,'first') + 1;                       %Find the first left bracket in the definition name.
    b = find(ofbc_codes(c).def == ']',1,'first') - 1;                       %Find the first right bracket in the definition name.
    if ~isempty(a) && ~isempty(b)                                           %If left and right brackets were found...
        ofbc_codes(c).def = ofbc_codes(c).def(a:b);                         %Trim down the entry to just the definition name.
    end
    str = upper(ofbc_codes(c).def);                                         %Make the definition name all upper-case.
    str(str == ' ') = '_';                                                  %Replace all spaces with underscores.
    str(str < 48) = [];                                                     %Kick out all special and symbol characters.
    str((str > 57) & (str < 65)) = [];                                      %Kick out all punctuation characters.  
    str((str > 90) & (str ~= 95)) = [];                                     %Kick out all other characters except underscores.
    ofbc_codes(c).def = str;                                                %Put the definition name back in the structure.
end
all_codes = vertcat(ofbc_codes.uint);                                       %Put all of the codes in a matrix.
duplicates = zeros(size(all_codes));                                        %Create a matrix to track duplicates.
for i = 1:length(all_codes)-1                                               %Step through each entry to check for duplicates.
    if duplicates(i) == 0                                                   %If this entry isn't already a duplicate...
        j = find(all_codes(i) == all_codes(i+1:end)) + i;                   %Check for any duplicates.
        if ~isempty(j)                                                      %If any duplicates were found...
            duplicates([i,j]) = max(duplicates) + 1;                        %Mark the entries as duplicates.
        end
    end
end
if any(duplicates > 0)                                                      %If any duplicates were found...
    str = 'Duplicate block values were found:\n';                           %Start an error string.    
    for i = 1:max(duplicates)                                               %Step through each set of duplicates.
        temp = all_codes(duplicates == i);                                  %Grab the code value.
        str = sprintf('%s%05.0f: ',str,temp(1));                            %Show the code value.
        str = [str, sprintf('%s, ',ofbc_codes(duplicates == i).def)];       %Show the definition names for each duplicate value.
        str = [str(1:end-2) '\n'];                                          %Add a carriage return.
    end
    error(str,'Duplicate Block Error');                                     %Throw an error.
end
all_defs = {ofbc_codes.def}';                                               %Put all of the definitions in a cell array.
duplicates = zeros(size(all_defs));                                         %Create a matrix to track duplicates.
for i = 1:length(all_codes)-1                                               %Step through each entry to check for duplicates.
    if duplicates(i) == 0                                                   %If this entry isn't already a duplicate...
        j = find(strcmpi(all_defs{i},all_defs(i+1:end))) + i;               %Check for any duplicates.
        if ~isempty(j)                                                      %If any duplicates were found...
            duplicates([i,j]) = max(duplicates) + 1;                        %Mark the entries as duplicates.
        end
    end
end
if any(duplicates > 0)                                                      %If any duplicates were found...
    str = 'Duplicate definition names were found:\n';                       %Start an error string.    
    for i = 1:max(duplicates)                                               %Step through each set of duplicates.
        temp = all_defs(duplicates == i);                                   %Grab the definition names.
        str = sprintf('%s%s: ',str,temp{1});                                %Show the definition name.
        str = [str, sprintf('%s, ',ofbc_codes(duplicates == i).hex)];       %Show the block values for each duplicate definition.
        str = [str(1:end-2) '\n'];                                          %Add a carriage return.
    end
    error(str,'Duplicate Block Error');                                     %Throw an error.
end

%Recreate the OFBC codes principal list with the cleaned-up values.
column_headings = {'Block Code (hex)', 'Block Code (uint16)',...
    'Definition Name', 'Description', 'MATLAB Scripts'};                    %List the column headings.
rel_path = '/Data%20Block%20Descriptions/';                                 %Set the relative path for markdown links.
fid = fopen(principal_list_file,'wt');                                      %Open the file for writing as text.
fprintf(fid,md_header);                                                     %Print the header to the new file.
for i = 1:length(column_headings)                                           %Step through the column headings.
    fprintf(fid,'| %s ',column_headings{i});                                %Print each column heading.
end
fprintf(fid,'|\n');                                                         %Print a carriage return.
fprintf(fid,'| :---: | :---: | :--- | :--- | :--- |\n');                    %Print the table formating.
for c = 1:length(ofbc_codes)                                                %Step through each OFBC code.
    file = [ofbc_codes(c).hex(1:4) '00-' ofbc_codes(c).hex(1:4) 'FF.md'];   %Create the expected description file name.    
    def = sprintf('[%s](%s%s#block-code-%s)',ofbc_codes(c).def,...
        rel_path,file,ofbc_codes(c).hex);                                   %Create the markdown link.
    if c > 1 && (ofbc_codes(c).uint - ofbc_codes(c-1).uint) > 1             %If this definition value is non-contiguous with the previous one...
        fprintf(fid,'||\n||\n');                                            %Print an empty row.
    end    
    fprintf(fid,'| %s | %1.0f ', ofbc_codes(c).hex, ofbc_codes(c).uint);    %Print the hex and uint values of the code.
    fprintf(fid,'| %s ',def);                                               %Print the definition name.
    fprintf(fid,'| %s ',ofbc_codes(c).description);                         %Print the description.
    fprintf(fid,'|\n');                                                     %Close the row and print a carriage return.
end
fclose(fid);                                                                %Close the file.


%% Update the description markdown file.
function Update_Description_Markdown_files(ofbc_codes, description_dir)

%Find all of the existing description markdown files.
description_files = dir(fullfile(description_dir,'0x*.md'));                %Find all existing description markdown files.
description_files = rmfield(description_files,...
    {'folder','date','bytes','isdir','datenum'});                           %Keep only the folder names.
for i = 1:length(description_files)                                         %Step through each existing description file...
    description_files(i).range_start = ...
        hex2dec(description_files(i).name(3:6));                            %Grab the starting range for each file.
end


%% Create the Arduino library header file(s) for the OmniTrak File Block Codes (OFBC).
function Write_OFBC_Library_Header(lib_dir, ofbc_codes, repo_url)
shortfile = 'OmniTrak_File_Block_Codes.h';                                  %Set the shortfilename.
filename = fullfile(lib_dir,shortfile);                                     %Set the full filename.
timestamp = char(datetime('now','TimeZone','UTC'),'yyy-MM-dd, hh:mm:ss');   %Grab a text timestamp.
fid = fopen(filename,'wt');                                                 %Open the file for writing as text.
fprintf(fid,'/*\n');                                                        %Print a comments start indicator to the file.
fprintf(fid,'\t%s\n\n\tVulintus, Inc.\n\n',shortfile);                      %Print the filename to the file.
fprintf(fid,'\tOmniTrak File Format Block Codes (OFBC) Libary\n\n');        %Print a library description to the file.
fprintf(fid,'\tLibrary documentation:\n\t%s\n\n',repo_url);                 %Print the library documenation link to the file.
fprintf(fid,'\tThis file was programmatically generated: ');                %Print a line to show the library was programmatically generated.
fprintf(fid,'%s (UTC)\n',timestamp);                                        %Print a timestamp to the file.   
fprintf(fid,'*/\n\n');                                                      %Print a comments end indicator to the file.

fprintf(fid,'#ifndef _VULINTUS_OFBC_BLOCK_CODES_H_\n');                     %Print a redundancy check.
fprintf(fid,'#define _VULINTUS_OFBC_BLOCK_CODES_H_\n\n');                   %Print a header definition.

fprintf(fid,'#ifndef OFBC_DEF_VERSION\n');                                  %Make a check to see if the definition version was pre-defined.
fprintf(fid,'\t#define OFBC_DEF_VERSION\t\t1\n');                           %Set the default version to the latest version.
fprintf(fid,'#endif\n');                                                    %Close the "#ifndef".
fprintf(fid,'#define OFBC_CUR_DEF_VERSION\tOFBC_DEF_VERSION\n\n');          %Print the definition name to the file.

max_len = 0;                                                                %Create a variable to hold the maximum definition character length.
for c = 1:length(ofbc_codes)                                                %Step through the OFBC codes.    
    max_len = max(max_len, length(ofbc_codes(c).def));                      %Check for a new maximum definition length.
end
max_len = max_len + length('OFBC_');                                        %Add the length of the OFBC prefix to the maximum definition length.
cmt_sp = 4;                                                                 %Minimum space between the comments and the definitions.
for c = 1:length(ofbc_codes)                                                %Step through the OFBC codes.
    def_name = ['OFBC_' ofbc_codes(c).def];                                 %Set the definition name.
    blk_val = ofbc_codes(c).hex;                                            %Grab the definition hex value.
    def_comment = ofbc_codes(c).description;                                %Set the comment for the definition.
    def_comment(def_comment < 32) = [];                                     %Kick out any special characters from the comment.
    if c > 1 && abs(ofbc_codes(c).uint - ofbc_codes(c-1).uint) > 1          %If this definition value is non-contiguous with the previous one...
        fprintf(fid,'\n');                                                  %Print a carriage return.
    end    
    fprintf(fid,'const uint16_t %s = ', def_name);                          %Print the constant name to the file.
    fprintf(fid,'%s;',blk_val);                                             %Print the definition value to the file.
    if ~isempty(def_comment)                                                %If there's a comment to include...
        N = max_len - length(def_name) + cmt_sp;                            %Calculate the number of spaces before the comment.
        fprintf(fid,repmat(' ',1,N));                                       %Add spaces after the definition name.
        fprintf(fid,'// %s',def_comment);                                   %Print the comment.
    end
    fprintf(fid,'\n');                                                      %Print a carriage return.
end
fprintf(fid,'\n#endif');                                                    %Close the header definition.
N = length('const uint16_t  = 0x0000;') + max_len - ...
    length('#endif') + cmt_sp;                                              %Calculate the number of spaces before the comment.  
fprintf(fid,repmat(' ',1,N));                                               %Add spaces to line up the comments.
fprintf(fid,'// #ifndef _VULINTUS_OFBC_BLOCK_CODES_H_\n');                  %Add a definition closing comment.
fclose(fid);                                                                %Close the file.
winopen(filename);                                                          %Open the generated file for inspection.


%% Create the MATLAB function for loading the OmniTrak File Block Codes (OFBC).
function Write_OFBC_Loading_Script(matlab_dir, ofbc_codes, repo_url)
fcn_name = 'Load_OmniTrak_File_Block_Codes';                                %Set the function name.
shortfile = sprintf('%s.m',fcn_name);                                       %Set the shortfilename.
filename = fullfile(matlab_dir,shortfile);                                  %Set the full filename.
timestamp = char(datetime('now','TimeZone','UTC'),'yyy-MM-dd, hh:mm:ss');   %Grab a text timestamp.
fid = fopen(filename,'wt');                                                 %Open the file for writing as text.

fprintf(fid,'function ofbc = %s\n',fcn_name);                               %Print the function name to the file.
fprintf(fid,'\n%%\t%s.m\n%%\n',fcn_name);                                   %Print the start of a function description comment.
fprintf(fid,'%%\tVulintus, Inc.\n%%\n');                                    %Print Vulintus origin text to the file.
fprintf(fid,'%%\tOmniTrak File Format Block Codes (OFBC) library.\n%%\n');  %Print a library description to the file.
fprintf(fid,'%%\tLibrary documentation:\n%%\t%s\n%%\n',repo_url);           %Print the library documenation link for each version to the file.
fprintf(fid,'%%\tThis function was programmatically generated: ');          %Print a line to show the library was programmatically generated.
fprintf(fid,'%s (UTC)\n',timestamp);                                        %Print a timestamp to the file.   
fprintf(fid,'%%\n\n');                                                      %Print a comments end indicator to the file.

fprintf(fid,'ofbc = dictionary;\n\n');                                      %Print a line to create a dictionary.

max_len = 0;                                                                %Create a variable to hold the maximum definition character length.
for c = 1:length(ofbc_codes)                                                %Step through the OFBC codes.    
    max_len = max(max_len, length(ofbc_codes(c).def));                      %Check for a new maximum definition length.
end
cmt_sp = 4;                                                                 %Minimum space between the comments and the definitions.
for i = 1:length(ofbc_codes)                                                %Step through the OFBC codes.
    def_name = ofbc_codes(i).def;                                           %Set the definition name.
    blk_val = num2str(ofbc_codes(i).uint,'%1.0f');                          %Grab the definition hex value.
    def_comment = ofbc_codes(i).description;                                %Set the comment for the definition.
    def_comment(def_comment < 32) = [];                                     %Kick out any special characters from the comment.
    if i > 1 && (ofbc_codes(i).uint - ofbc_codes(i-1).uint) > 1             %If this definition value is non-contiguous with the previous one...
        fprintf(fid,'\n');                                                  %Print a carriage return.
    end
    fprintf(fid,'ofbc(''%s'') = %s;',def_name,blk_val);                     %Print the "ofbc" structure name to the file.
    if ~isempty(def_comment)                                                %If there's a comment to include...
        N = (max_len - length(def_name)) + (5 - length(blk_val)) + cmt_sp;  %Calculate the number of spaces before the definition.
        fprintf(fid,repmat(' ',1,N));                                       %Add spaces after the definition name.
        fprintf(fid,'%%%s',def_comment);                                    %Print the comment.
    end
    fprintf(fid,'\n');                                                      %Print a carriage return.
end
fclose(fid);                                                                %Close the file.
winopen(filename);                                                          %Open the function in MATLAB.


%% Create the MATLAB subfunctions for reading in OmniTrak file data blocks.
function Write_OmniTrakFileRead_Subfunctions(matlab_dir, ofbc_codes, repo_url)

fcn_name = 'OmniTrakFileRead_ReadBlock_Dictionary';                         %Set the function name.
matlab_dir = fullfile(matlab_dir,'OmniTrakFileRead Subfunctions');          %Set the directory for OFBC data block-reading subfunctions.
if ~exist(matlab_dir,'dir')                                                 %If the MATLAB directory doesn't yet exist...
    mkdir(matlab_dir);                                                      %Create it.
end
filename = fullfile(matlab_dir,[fcn_name '.m']);                            %Set the filename.
timestamp = char(datetime('now','TimeZone','UTC'),'yyy-MM-dd, hh:mm:ss');   %Grab a text timestamp.
fid = fopen(filename,'wt');                                                 %Open the file for writing as text.

fprintf(fid,'function block_read = %s(fid)\n',fcn_name);                    %Print the function name to the file.
fprintf(fid,'\n%%%s.m\n%%\n',fcn_name);                                     %Print the start of a function description comment.
fprintf(fid,'%%\tVulintus, Inc.\n%%\n');                                    %Print Vulintus origin text to the file.
fprintf(fid,'%%\tOmniTrak file data block read subfunction router.\n%%\n'); %Print a function description to the file.
fprintf(fid,'%%\tLibrary documentation:\n%%\t%s\n%%\n',repo_url);           %Print the library documenation link for each version to the file.
fprintf(fid,'%%\tThis function was programmatically generated: ');          %Print a line to show the library was programmatically generated.
fprintf(fid,'%s (UTC)\n',timestamp);                                        %Print a timestamp to the file.   
fprintf(fid,'%%\n\n');                                                      %Print a comments end indicator to the file.

fprintf(fid,'block_read = dictionary;\n');                                  %Print a line to create a dictionary.

for i = 1:length(ofbc_codes)                                                %Step through the OFBC codes.
    if ofbc_codes(i).uint == 43981                                                     %If this is the verification block values...
        continue                                                            %Skip to the next code.
    end
    def_name = ofbc_codes(i).def;                                           %Set the definition name.
    def_comment = ofbc_codes(i).description;                                %Set the comment for the definition.
    def_comment(def_comment < 32) = [];                                     %Kick out any special characters from the comment.
    if i > 1 && abs(ofbc_codes(i).uint - ofbc_codes(i-1).uint) > 1          %If this definition value is non-contiguous with the previous one...
        fprintf(fid,'\n');                                                  %Print a carriage return.
    end
    old_fcn_name = sprintf('OmniTrakFileRead_ReadBlock_V1_%s', def_name);   %Create the old function name.
    subfcn_name = sprintf('OmniTrakFileRead_ReadBlock_%s', def_name);       %Create the function name.
    if exist(fullfile(matlab_dir,[old_fcn_name '.m']),'file')               %If the old function name exists...
        if ~exist(fullfile(matlab_dir,[subfcn_name '.m']),'file')           %If the new function name doesn't exist...
            copyfile(fullfile(matlab_dir,[old_fcn_name '.m']),...
                fullfile(matlab_dir,[subfcn_name '.m']), 'f');              %Copy the old function to the new function name.
        end
        delete(fullfile(matlab_dir,[old_fcn_name '.m']));                   %Delete the old function.
    end
    if ~exist(fullfile(matlab_dir,[subfcn_name '.m']),'file')               %If the subfunction doesn't exist yet.
        subfid = fopen(fullfile(matlab_dir,[subfcn_name '.m']),'wt');       %Open the file for writing as text.
        fprintf(subfid,'function data =  %s(fid,data)\n\n', subfcn_name);   %Print the function name to the file.
        fprintf(subfid,'%%\tOmniTrak File Block Code (OFBC):\n');           %Print a label under the description.
        fprintf(subfid,'%%\t\tBLOCK VALUE:\t%s\n',ofbc_codes(i).hex);       %Print the block code value.
        fprintf(subfid,'%%\t\tDEFINITION:\t\t%s\n',def_name);               %Print the block definition name.
        if ~isempty(def_comment)                                            %If there's a comment to include...
            fprintf(subfid,'%%\t\tDESCRIPTION:\t%s\n', def_comment);        %Print the block description.
        end
        fprintf(subfid,'\n');                                               %Print a carriage return.
        fprintf(subfid,['error(''Need to finish coding for OFBC block '...
            '%s ("%s")!'');\n'], ofbc_codes(i).hex, def_name);              %Print an error message to show.
        fclose(subfid);                                                     %Close the file.
        eval(sprintf('dbstop in ''%s''', subfcn_name));                     %Add a debugging breakpoint to the new subfunction.
    end
    if ~isempty(def_comment)                                                %If there's a comment to include...
        fprintf(fid,'\n%% %s\n',def_comment);                               %Print the comment.
    end
    fprintf(fid,['block_read(%1.0f) = struct(''def_name'', ''%s'', '...
        '''fcn'', @(data)%s(fid,data));\n'],...
        ofbc_codes(i).uint,...
        def_name,...
        subfcn_name);                                                       %Create a string.
end
fclose(fid);                                                                %Close the file.
winopen(filename);                                                          %Open the function in MATLAB.