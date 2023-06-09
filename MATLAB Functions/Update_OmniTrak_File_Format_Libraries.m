function Update_OmniTrak_File_Format_Libraries

%
%Update_OmniTrak_File_Format_Libraries.m - Vulintus, Inc., 2021.
%
%   UPDATE_OMNITRAK_FILE_FORMAT_LIBRARIES downloads constant value 
%   definitions for the *.OmniTrak file format block codes (OFBC) from 
%   the Markdown-formated files in the "Data Block Definitions" folder of
%   Vulintus's "OmniTrak_File_Format" GitHub repository and creates 
%   corresponding matched Arduino libraries and Matlab functions.
%
%   UPDATE LOG:
%   2021-09-14 - Drew Sloan - Function first created, adapted from
%                             Update_OmniTrak_Libraries.m
%   2023-06-08 - Drew Sloan - Changed the function name from
%                             "Update_OmniTrak_File_Block_Codes.m".
%


fclose all;                                                                 %Close any open files.

ofbc_format = struct([]);                                                   %Create a struction to hold the OFBC file format Google Spreadsheet addresses.

%OmniTrak File Format Version 1.
ofbc_format(1).ver = 1;                                                     %Set the OmniTrak File Format version (must always be an integer).
ofbc_format(1).sheet = {                                                    %List all sheets from the spreadsheet to check.
    'https://docs.google.com/spreadsheets/d/e/2PACX-1vSt8EQXvF5DNkU8MrZYNL_1TcYMDagQc-U6WyK51xt2nk6oHyXr6Z0jQPUfQTLzla4QNMagKPDmxKJ0/pub?gid=797885242&single=true&output=tsv';
	'https://docs.google.com/spreadsheets/d/e/2PACX-1vSt8EQXvF5DNkU8MrZYNL_1TcYMDagQc-U6WyK51xt2nk6oHyXr6Z0jQPUfQTLzla4QNMagKPDmxKJ0/pub?gid=709084454&single=true&output=tsv';
	'https://docs.google.com/spreadsheets/d/e/2PACX-1vSt8EQXvF5DNkU8MrZYNL_1TcYMDagQc-U6WyK51xt2nk6oHyXr6Z0jQPUfQTLzla4QNMagKPDmxKJ0/pub?gid=1682786712&single=true&output=tsv';
	'https://docs.google.com/spreadsheets/d/e/2PACX-1vSt8EQXvF5DNkU8MrZYNL_1TcYMDagQc-U6WyK51xt2nk6oHyXr6Z0jQPUfQTLzla4QNMagKPDmxKJ0/pub?gid=737813115&single=true&output=tsv';
	'https://docs.google.com/spreadsheets/d/e/2PACX-1vSt8EQXvF5DNkU8MrZYNL_1TcYMDagQc-U6WyK51xt2nk6oHyXr6Z0jQPUfQTLzla4QNMagKPDmxKJ0/pub?gid=2054720516&single=true&output=tsv';
    };


latest_ver = max(vertcat(ofbc_format.ver));                                 %Grab the highest file version.
github_url = 'https://github.com/Vulintus/OmniTrak_File_Format';            %Set the URL for the GitHub repository.

%Set the target directories.
config = struct(    'matlab_dir',   [], ...
                    'subfun_dir',   [], ...
                    'cpp_dir',      [], ...
                    'arduino_dir',  []);                                    %Create a structure to hold the configuration.

appdata_path = Vulintus_Set_AppData_Path('Library Update Functions');       %Set the AppData path for the library update functions.
config_file = ...
    fullfile(appdata_path,'update_omnitrak_file_block_codes_paths.json');   %Set the expected saved file paths JSON file.
if exist(config_file,'file')                                                %If the file paths were previously saved on this computer...
    temp_data = Vulintus_Read_JSON_File(config_file);                       %Read in the saved filenames.
    fields = fieldnames(config);                                            %Grab all of the fieldnames from the config file.
    for i = 1:length(fields)                                                %Step through each field of the configuration structure.
        if isfield(temp_data,fields{i})                                     %If a matching field value was stored...
            config.(fields{i}) = temp_data.(fields{i});                     %Copy the field value over.
        end
    end
end

[path, ~, ~] = fileparts(mfilename('fullpath'));                            %Grab the path from the present function.
if isempty(path)                                                            %If the path couldn't be grabbed.
    path = which(mfilename);                                                %Try to grab the path with the which function.
end
if ~exist(config.matlab_dir,'dir')                                          %If the MATLAB function path hasn't been set yet...
    config.matlab_dir = uigetdir(path,...
        'Locate the "\MATLAB Functions\" folder');                          %Have the user select the directory.
    if config.matlab_dir(1) == 0                                            %If the user clicked cancel...
        return                                                              %Skip execution of the rest of the function.
    end
end

if ~exist(config.subfun_dir,'dir')                                           %If the OmniTrakfileRead subfunctions path hasn't been set yet...
    config.subfun_dir = uigetdir(config.matlab_dir,...
        'Locate the "\OmniTrakFileRead Subfunctions\" folder');             %Have the user select the directory.
    if config.subfun_dir(1) == 0                                            %If the user clicked cancel...
        return                                                              %Skip execution of the rest of the function.
    end
end

[path, ~, ~] = fileparts(config.matlab_dir);                                %Set the default path to the next folder up from the matlab directory.
if ~exist(config.cpp_dir,'dir')                                             %If the C/C++ libraries path hasn't been set yet...
    config.cpp_dir = uigetdir(path,'Locate the "\C Libraries\" folder');    %Have the user select the directory.
    if config.cpp_dir(1) == 0                                               %If the user clicked cancel...
        return                                                              %Skip execution of the rest of the function.
    end
end

[path, ~, ~] = fileparts(userpath);                                         %Set the default path to the user's "Documents" folder.
if ~exist(config.arduino_dir,'dir')                                         %If the Arduino "Vulintus_OmniTrak_Library"  path hasn't been set yet...
    config.arduino_dir = uigetdir(path,...
        'Locate the Arduino Library: "Vulintus_OmniTrak_Library"');         %Have the user select the directory.
    if config.arduino_dir(1) == 0                                           %If the user clicked cancel...
        config.arduino_dir = [];                                            %Set the directory to empty brackets.
    end
end

Vulintus_Write_JSON_File(config,config_file);                               %Save the configuration in the AppData folder.

%Grab the current UTC time.
cur_time = datetime('now','timezone','utc');                                %Grab the current UTC time.
cur_time_str = char(cur_time,'yyyy-MM-dd, hh:mm:ss');                       %Convert the UTC time to a string.


%% Create the C/C++ library header file(s) for the OmniTrak file format block codes.
shortfile = 'OmniTrak_File_Block_Codes.h';                                  %Set the filename.
filename = fullfile(config.cpp_dir,shortfile);                              %Set the full filename.
fid = fopen(filename,'wt');                                                 %Open the file for writing as text.
fprintf(fid,'/*!\n');                                                       %Print a comments start indicator to the file.
fprintf(fid,'\t%s\n\n\tVulintus, Inc.\n\n',shortfile);                      %Print the filename to the file.
fprintf(fid,'\tOmniTrak File Format Block Code Libary\n\n');                %Print a library description to the file.
fprintf(fid,'\t%s\n\n',github_url);                                         %Print the GitHub repository link to the file.
fprintf(fid,'\tThis file was programmatically generated: ');                %Print a line to show the library was programmatically generated.
fprintf(fid,'%s (UTC).\n',cur_time_str);                                    %Print a timestamp to the file.   
fprintf(fid,'*/\n\n\n');                                                    %Print a comments end indicator to the file.

shortfile(shortfile == '.') = '_';                                          %Replace the period in the filename with an underscore.
shortfile = upper(shortfile);                                               %Make the filename all upper-case.
fprintf(fid,'#ifndef %s\n',shortfile);                                      %Create an "#ifndef" check to prevent double-loading of the library.
fprintf(fid,'#define %s\n\n',shortfile);                                    %Create a library-loaded definition.

fprintf(fid,'#ifndef OFBC_DEF_VERSION\n');                                  %Make a check to see if the definition version was pre-defined.
fprintf(fid,'\t#define OFBC_DEF_VERSION\t\t%1.0f\n',latest_ver);            %Set the default version to the latest version.
fprintf(fid,'#endif\n');                                                    %Close the "#ifndef".
fprintf(fid,'#define OFBC_CUR_DEF_VERSION\tOFBC_DEF_VERSION\n\n');          %Print the definition name to the file.

for f = 1:numel(ofbc_format)                                                %Step through each file format version.
    max_len = length('CUR_DEF_VERSION');                                    %Create a variable to hold the maximum definition character length.
    for s = 1:numel(ofbc_format(f).sheet)                                   %Step through the sheets of the spreadsheet.
        data = Read_Google_Spreadsheet(ofbc_format(f).sheet{s});            %Read in each spreadsheet.
        def_c = strcmpi(data(1,:),'definition name');                       %Find the column containing the definition name.
        for i = 2:size(data,1)                                              %Step through each row.
            if ~isempty(data{i,def_c})                                      %If there's a definition name in the row...
                def = data{i,def_c};                                        %Grab the definition name.
                def(def < 32) = [];                                         %Kick out any special characters.
                max_len = max(max_len, length(def));                        %Check for a new maximum definition length.
            end
        end
    end
    max_len = max_len + 10;                                                 %Add 5 more spaces to the maximum definition name length.
    cmt_sp = 10;                                                            %Set the starting position for comments.
end

for f = 1:numel(ofbc_format)                                                %Step through each file format version.

    if f == 1                                                               %If this is the first format version...
        fprintf(fid,'\n#if OFBC_DEF_VERSION == ');                          %Start an "#if" statement.
    else                                                                    %Otherwise, for following formats.
        fprintf(fid,'\n#elif OFBC_DEF_VERSION == ');                        %Start an "#elif" statement.
    end
    fprintf(fid,'%1.0f\n\n',ofbc_format(f).ver);                            %Print the definition version number.

    for s = 1:numel(ofbc_format(f).sheet)                                   %Step through the sheets of the spreadsheet.
        
        data = Read_Google_Spreadsheet(ofbc_format(f).sheet{s});            %Read in each spreadsheet.
        
        def_c = strcmpi(data(1,:),'definition name');                       %Find the column containing the definition name.
        blk_c = strncmpi(data(1,:),'block code', 10);                       %Find the column containing the block codes.
        desc_c = strncmpi(data(1,:),'description', 11);                     %Find the column containing the block description.
        
        add_line = 0;                                                       %Create a variable to add one carraige return between non-contiguous blocks of codes.
        fprintf(fid,'\n');                                                  %Print a carraige return.
        for i = 2:size(data,1)                                              %Step through each row.
            if ~isempty(data{i,def_c})                                      %If there's a definition name in the row...
                def_name = ['OFBC_' data{i,def_c}];                         %Set the definition name.
                def_name(def_name < 32) = [];                               %Kick out any special characters from the definition name.
                blk_val = data{i,blk_c};                                    %Grab the definition value.
                blk_val(blk_val < 48 | blk_val > 57) = [];                  %Kick out any special characters from the definition value..
                def_comment = data{i,desc_c};                               %Set the comment for the definition.
                def_comment(def_comment < 32) = [];                         %Kick out any special characters from the comment.
                fprintf(fid,'#define\t%s',def_name);                        %Print the definition name to the file.
                fprintf(fid,repmat(' ',1,max_len - length(def_name)));      %Add spaces after the definition name.
                fprintf(fid,'%s',blk_val);                                  %Print the definition value to the file.
                if ~isempty(def_comment)                                    %If there's a comment to include...
                    N = cmt_sp - length(blk_val);                           %Calculate the number of spaces before the definition.
                    fprintf(fid,repmat(' ',1,N));                           %Add spaces after the definition name.
                    fprintf(fid,'// %s',def_comment);                       %Print the comment.
                end
                fprintf(fid,'\n');                                          %Print a carriage return.
                add_line = 1;                                               %Print a line to the file if there's no entry on the following line.
            elseif add_line == 1                                            %Otherwise, if the previous entry wasn't empty...
                fprintf(fid,'\n');                                          %Print a carraige return.
                add_line = 0;                                               %Don't print any more line spaces until a new non-empty entry is found.
            end
        end
    end
end

fprintf(fid,'\n#endif\t\t// #if OFBC_DEF_VERSION == X\n');                  %Close the "#if".
fprintf(fid,'\n#endif\t\t// #ifndef %s\n',shortfile);                       %Close the "#ifndef".
fclose(fid);                                                                %Close the file.

if ~isempty(config.arduino_dir) && exist(config.arduino_dir,'dir')          %If the Arduino library directory has been set.
    copyfile(filename,config.arduino_dir,'f');                              %Copy the new file to the OmniTrak Arduino library.
end

winopen(filename);                                                          %Open the generated file for inspection.


%% Create the Matlab function for loading the OmniTrak file format block codes.
fcn_name = 'Load_OmniTrak_File_Block_Codes';                                %Set the function name.
filename = fullfile(config.matlab_dir, [fcn_name '.m']);                    %Set the full filename.
fid = fopen(filename,'wt');                                                 %Open the file for writing as text.
fprintf(fid,'function block_codes = %s(varargin)\n',fcn_name);              %Print the function name to the file.
fprintf(fid,'\n%%LOAD_OMNITRAK_FILE_BLOCK_CODES.m\n%%\n');                  %Print the start of a function description comment.
fprintf(fid,'%%\tVulintus, Inc.\n%%\n');                                    %Print Vulintus origin text to the file.
fprintf(fid,'%%\tOmniTrak file format block code libary.\n%%\n');           %Print a library description to the file.
fprintf(fid,'%%\t%s\n%%\n',github_url);                                     %Print the GitHub repository link to the file.
fprintf(fid,'%%\tThis file was programmatically generated: ');              %Print a line to show the library was programmatically generated.
fprintf(fid,'%s (UTC).\n',cur_time_str);                                    %Print a timestamp to the file.   
fprintf(fid,'%%\n\n');                                                      %Print a comments end indicator to the file.

fprintf(fid,'if nargin > 0\n');                                             %If the user specifies a format version.
fprintf(fid,'\tver = varargin{1};\n');                                      %Set the version to the specified version.
fprintf(fid,'else\n');                                                      %Otherwise...
fprintf(fid,'\tver = %1.0f;\n',latest_ver);                                 %Use the latest version by default.
fprintf(fid,'end\n\n');                                                     %Close the "if" statement.

fprintf(fid,'block_codes = [];\n\n');                                       %Print a line to create a structure.
fprintf(fid,'switch ver\n');                                                %Print a line to start a switch-case statement.
for f = 1:numel(ofbc_format)                                                %Step through each file format version.
    fprintf(fid,'\n\tcase %1.0f\n\n',ofbc_format(f).ver);                   %Print a case for this file format version.
    fprintf(fid,'\t\tblock_codes.CUR_DEF_VERSION = ');                      %Print a field to the "block_codes" structure for the definition version.    
    fprintf(fid,'%1.0f;\n\n',ofbc_format(f).ver);                           %Print the file format version to the file.
    for s = 1:numel(ofbc_format(f).sheet)                                   %Step through the sheets of the spreadsheet.
        data = Read_Google_Spreadsheet(ofbc_format(f).sheet{s});            %Read in each spreadsheet.+
        
        def_c = strcmpi(data(1,:),'definition name');                       %Find the column containing the definition name.
        blk_c = strncmpi(data(1,:),'block code', 10);                       %Find the column containing the block codes.
        desc_c = strncmpi(data(1,:),'description', 11);                     %Find the column containing the block description.
        
        add_line = 0;                                                       %Create a variable to add one carraige return between non-contiguous blocks of codes.
        for i = 2:size(data,1)                                              %Step through each row.
            if ~isempty(data{i,def_c})                                      %If there's a definition name in the row...
                def_name = data{i,def_c};                                   %Set the definition name.
                def_name(def_name < 32) = [];                               %Kick out any special characters from the definition name.
                blk_val = data{i,blk_c};                                    %Grab the definition value.
                blk_val(blk_val < 48 | blk_val > 57) = [];                  %Kick out any special characters from the definition value..
                def_comment = data{i,desc_c};                               %Set the comment for the definition.
                def_comment(def_comment < 32) = [];                         %Kick out any special characters from the comment.
                fprintf(fid,'\t\tblock_codes.%s = %s;',...
                    def_name,blk_val);                                      %Print the "serial_codes" structure name to the file.
                if ~isempty(def_comment)                                    %If there's a comment to include...
                    N = 52 - length(def_name) - length(blk_val);            %Calculate the number of spaces before the definition.
                    fprintf(fid,repmat(' ',1,N));                           %Add spaces after the definition name.
                    fprintf(fid,'%%%s',def_comment);                        %Print the comment.
                end
                fprintf(fid,'\n');                                          %Print a carriage return.
                add_line = 1;                                               %Print a line to the file if there's no entry on the following line.
            elseif add_line == 1                                            %Otherwise, if the previous entry wasn't empty...
                fprintf(fid,'\n');                                          %Print a carraige return.
                add_line = 0;                                               %Don't print any more line spaces until a new non-empty entry is found.
            end
        end
    end
end
fprintf(fid,'end\n');                                                       %Print an "end" to the switch-case statement.
fclose(fid);                                                                %Close the file.
winopen(filename);                                                          %Open the generated file for inspection.


%% Create the Matlab subfunctions for reading in OmniTrak file format block codes.
fcn_name = 'OmniTrakFileRead_ReadBlock';                                    %Set the function name.
filename = fullfile(config.subfun_dir,[fcn_name '.m']);                     %Set the filename.
fid = fopen(filename,'wt');                                                 %Open the file for writing as text.
fprintf(fid,'function data = %s(fid,block,data,verbose)\n',fcn_name);       %Print the function name to the file.
fprintf(fid,'\n%%OMNITRAKFILEREAD_READ_BLOCK.m\n%%\n');                     %Print the start of a function description comment.
fprintf(fid,'%%\tVulintus, Inc.\n%%\n');                                    %Print Vulintus origin text to the file.
fprintf(fid,'%%\tOmniTrak file block read subfunction router.\n%%\n');      %Print a function description to the file.
fprintf(fid,'%%\t%s\n%%\n',github_url);                                     %Print the GitHub repository link to the file.
fprintf(fid,'%%\tThis file was programmatically generated: ');              %Print a line to show the library was programmatically generated.
fprintf(fid,'%s (UTC).\n',cur_time_str);                                    %Print a timestamp to the file.   
fprintf(fid,'%%\n\n');                                                      %Print a comments end indicator to the file.

fprintf(fid,['block_codes = '...
    'Load_OmniTrak_File_Block_Codes(data.file_version);\n\n']);             %Print a line to load the OmniTrak block code structure.
fprintf(fid,'if verbose == 1\n');                                           %Print the start of an if statement.
fprintf(fid,'\tblock_names = fieldnames(block_codes)'';\n');                %Print a line of code.
fprintf(fid,'\tfor f = block_names\n');                                     %Print the start of a for loop.
fprintf(fid,'\t\tif block_codes.(f{1}) == block\n');                        %Print the start of an if statement.
fprintf(fid,['\t\t\tfprintf(1,''b%%1.0f\\t>>\\t%%1.0f: %%s\\n'','...
    'ftell(fid)-2,block,f{1});\n']);                                        %Print an fprintf statement.
fprintf(fid,'\t\tend\n\tend\nend\n\n');                                     %Print an end to the if statement.

fprintf(fid,'switch data.file_version\n\n');                                %Print a line to start a switch-case statement.
for f = 1:numel(ofbc_format)                                                %Step through each file format version.
    fprintf(fid,'\tcase %1.0f\n\n',ofbc_format(f).ver);                     %Print a case for this file format version.
    fprintf(fid,'\t\tswitch block\n\n');                                    %Print the switch statement.
    for s = 1:numel(ofbc_format(f).sheet)                                   %Step through the sheets of the spreadsheet.
        data = Read_Google_Spreadsheet(ofbc_format(f).sheet{s});            %Read in each spreadsheet.
        
        def_c = strcmpi(data(1,:),'definition name');                       %Find the column containing the definition name.
        blk_c = strncmpi(data(1,:),'block code', 10);                       %Find the column containing the block codes.
        desc_c = strncmpi(data(1,:),'description', 11);                     %Find the column containing the block description.
        
        for i = 2:size(data,1)                                              %Step through each row.
            if ~isempty(data{i,def_c}) && ~strcmpi(data{i,blk_c},'43981')   %If there's a definition name in the row...                
                def_name = data{i,def_c};                                   %Set the definition name.
                def_name(def_name < 32) = [];                               %Kick out any special characters from the definition name.
                blk_val = data{i,blk_c};                                    %Grab the definition value.
                blk_val(blk_val < 48 | blk_val > 57) = [];                  %Kick out any special characters from the definition value..
                def_comment = data{i,desc_c};                               %Set the comment for the definition.
                def_comment(def_comment < 32) = [];                         %Kick out any special characters from the comment.
                fprintf(fid,'\t\t\tcase block_codes.%s',def_name);          %Print the case.
                if ~isempty(def_comment)                                    %If there's a comment to include...
                    N = 47 - length(def_name);                              %Calculate the number of spaces before the definition.
                    fprintf(fid,repmat(' ',1,N));                           %Add spaces after the definition name.
                    fprintf(fid,'%%%s',def_comment);                        %Print the comment.
                end
                fcn_name = ...
                    sprintf('OmniTrakFileRead_ReadBlock_V%1.0f_%s',...
                    ofbc_format(f).ver, def_name);                          %Create the function name.
                fprintf(fid,'\n\t\t\t\tdata = %s(fid,data);\n\n',fcn_name); %Print the function call.
                subfilename = fullfile(config.subfun_dir,[fcn_name '.m']);  %Create the expected filename for the block-read function.
                if ~exist(subfilename,'file')                               %If the file doesn't exist yet.
                    subfid = fopen(subfilename,'wt');                       %Open the file for writing as text.
                    fprintf(subfid,['function data = '...
                        '%s(fid,data)\n\n'],fcn_name);                      %Print the function name to the file.
                    fprintf(subfid,...
                        '%%\tOmniTrak File Block Code (OFBC):\n');          %Print a label under the description.
                    fprintf(subfid,'%%\t\tBLOCK VALUE:\t%s\n',blk_val);     %Print the block code value.
                    fprintf(subfid,'%%\t\tDEFINITION:\t\t%s\n',def_name);   %Print the block definition name.
                    if ~isempty(def_comment)                                %If there's a comment to include...
                        fprintf(subfid,'%%\t\tDESCRIPTION:\t%s\n',...
                            def_comment);                                   %Print the block description.
                    end
                    fprintf(subfid,'\n');                                   %Print a carriage return.
                    fprintf(subfid,'fprintf(1,');                           %Print an fprintf statement.
                    fprintf(subfid,...
                        '''Need to finish coding for Block %s: ',...
                        data{i,blk_c});                                     %Print the message to show.
                    fprintf(subfid,'%s\\n'');', data{i,def_c});             %Print the block name.      
                    fclose(subfid);                                         %Close the file.
                    eval(sprintf('dbstop in ''%s''', subfilename));         %Add a debugging breakpoint to the new subfunction.
                end
            end
        end
    end
    fprintf(fid,'\t\t\totherwise');                                         %Print an otherwise case for non-matches.
    fprintf(fid,'%s%%No matching block.\n',repmat(' ',1,55));               %Print a comment.
    fcn_name = 'OmniTrakFileRead_Unrecognized_Block';                       %Create the function name.
    fprintf(fid,'\t\t\t\tdata = %s(fid,data);\n\n',fcn_name);               %Print the function call.    
    fprintf(fid,'\tend\n');                                                 %Print an "end" to the switch-case statement.
end
fprintf(fid,'end');                                                         %Print an "end" to the switch-case statement.
fclose(fid);                                                                %Close the file.
winopen(filename);                                                          %Open the generated file for inspection.